import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/models/push_notification_data.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/network/connectivity_service.dart';
import 'package:passenger/core/services/notification_service.dart';
import 'package:passenger/core/services/push_notification_service.dart';
import 'package:passenger/features/notifications/cubit/notifications_state.dart';
import 'package:passenger/features/notifications/models/notification_list_response.dart';

export 'package:passenger/features/notifications/cubit/notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required NotificationService notificationService,
    required ConnectivityService connectivity,
    required PushNotificationService pushNotificationService,
  })  : _notificationService = notificationService,
        _connectivity = connectivity,
        _pushNotificationService = pushNotificationService,
        super(const NotificationsState());

  final NotificationService _notificationService;
  final ConnectivityService _connectivity;
  final PushNotificationService _pushNotificationService;

  /// Subscription for foreground push on the notifications screen (silent refresh).
  StreamSubscription<PushNotificationData>? _foregroundSub;

  /// Global subscription for foreground push (badge increment).
  StreamSubscription<PushNotificationData>? _foregroundPushSub;

  /// Global subscription for background tap.
  StreamSubscription<PushNotificationData>? _backgroundTapSub;

  Future<void> loadNotifications({bool refresh = false}) async {
    if (!refresh && state.status == NotificationsStatus.loading) return;

    emit(state.copyWith(status: NotificationsStatus.loading));

    if (!await _connectivity.checkConnectivity()) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: ErrorMessages.noConnection,
        ),
      );
      return;
    }

    try {
      final response = await _notificationService.getNotifications();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: response.notifications,
          currentPage: response.currentPage,
          hasMore: response.currentPage < response.lastPage,
          errorMessage: null,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    if (!await _connectivity.checkConnectivity()) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final response = await _notificationService.getNotifications(
        page: nextPage,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          notifications: [...state.notifications, ...response.notifications],
          currentPage: response.currentPage,
          hasMore: response.currentPage < response.lastPage,
          isLoadingMore: false,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      debugPrint('[Notifications] loadMore error: ${e.message}');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refreshUnreadCount() async {
    try {
      final count = await _notificationService.getUnreadCount();
      if (isClosed) return;
      emit(state.copyWith(unreadCount: count));
    } on ApiException catch (e) {
      debugPrint('[Notifications] refreshUnreadCount error: ${e.message}');
    }
  }

  Future<void> markAsRead(String id) async {
    if (!await _connectivity.checkConnectivity()) return;

    try {
      await _notificationService.markAsRead(id);
      if (isClosed) return;

      final updated = state.notifications.map((n) {
        if (n.id == id && !n.isRead) {
          return n.copyWith(readAt: DateTime.now());
        }
        return n;
      }).toList();

      final newUnread = (state.unreadCount - 1).clamp(0, state.unreadCount);
      emit(
        state.copyWith(notifications: updated, unreadCount: newUnread),
      );
    } on ApiException catch (e) {
      debugPrint('[Notifications] markAsRead error: ${e.message}');
    }
  }

  Future<void> markAllAsRead() async {
    if (!await _connectivity.checkConnectivity()) return;

    try {
      await _notificationService.markAllAsRead();
      if (isClosed) return;

      final updated = state.notifications
          .map((n) => n.isRead ? n : n.copyWith(readAt: DateTime.now()))
          .toList();

      emit(state.copyWith(notifications: updated, unreadCount: 0));
    } on ApiException catch (e) {
      debugPrint('[Notifications] markAllAsRead error: ${e.message}');
    }
  }

  Future<void> deleteNotification(String id) async {
    if (!await _connectivity.checkConnectivity()) return;

    // Optimistic removal
    final previous = state.notifications;
    final wasUnread = previous.any((n) => n.id == id && !n.isRead);
    final updated = previous.where((n) => n.id != id).toList();
    final newUnread = wasUnread
        ? (state.unreadCount - 1).clamp(0, state.unreadCount)
        : state.unreadCount;

    emit(state.copyWith(notifications: updated, unreadCount: newUnread));

    try {
      await _notificationService.deleteNotification(id);
    } on ApiException catch (e) {
      debugPrint('[Notifications] deleteNotification error: ${e.message}');
      if (isClosed) return;
      // Revert on failure
      emit(
        state.copyWith(
          notifications: previous,
          unreadCount: state.unreadCount + (wasUnread ? 1 : 0),
        ),
      );
    }
  }

  /// Increment unread count (e.g. on foreground push).
  void incrementUnreadCount() {
    if (isClosed) return;
    emit(state.copyWith(unreadCount: state.unreadCount + 1));
  }

  /// Clear the pending navigation flag after the UI has navigated.
  void clearPendingNavigation() {
    if (isClosed) return;
    emit(state.copyWith(hasPendingNavigation: false));
  }

  /// Subscribe to global push events: foreground → badge, background tap → navigate.
  void subscribeToPushUpdates() {
    unawaited(_foregroundPushSub?.cancel());
    _foregroundPushSub =
        _pushNotificationService.onForegroundMessage.listen((_) {
      incrementUnreadCount();
    });

    unawaited(_backgroundTapSub?.cancel());
    _backgroundTapSub =
        _pushNotificationService.onMessageOpenedApp.listen((_) {
      unawaited(refreshUnreadCount());
      if (isClosed) return;
      emit(state.copyWith(hasPendingNavigation: true));
    });

    // App launched via notification tap (terminated state)
    unawaited(_pushNotificationService.getInitialMessage().then((message) {
      if (message != null) {
        unawaited(refreshUnreadCount());
      }
    }));
  }

  /// Cancel global push subscriptions (e.g. on logout).
  void cancelPushSubscriptions() {
    unawaited(_foregroundPushSub?.cancel());
    _foregroundPushSub = null;
    unawaited(_backgroundTapSub?.cancel());
    _backgroundTapSub = null;
  }

  /// Start listening for foreground push messages to auto-refresh the list.
  /// Call from the notifications screen initState.
  void startRealtimeUpdates() {
    unawaited(_foregroundSub?.cancel());
    _foregroundSub =
        _pushNotificationService.onForegroundMessage.listen((_) {
      unawaited(_silentRefresh());
    });
  }

  /// Stop listening for foreground push messages.
  /// Call from the notifications screen dispose.
  void stopRealtimeUpdates() {
    unawaited(_foregroundSub?.cancel());
    _foregroundSub = null;
  }

  /// Refresh notifications list without showing loading indicator.
  Future<void> _silentRefresh() async {
    if (state.status != NotificationsStatus.loaded) return;

    try {
      final results = await Future.wait([
        _notificationService.getNotifications(),
        _notificationService.getUnreadCount(),
      ]);
      if (isClosed) return;

      final response = results[0] as NotificationListResponse;
      final unreadCount = results[1] as int;

      emit(
        state.copyWith(
          notifications: response.notifications,
          currentPage: response.currentPage,
          hasMore: response.currentPage < response.lastPage,
          unreadCount: unreadCount,
        ),
      );
    } on ApiException catch (e) {
      debugPrint('[Notifications] silentRefresh error: ${e.message}');
    }
  }

  @override
  Future<void> close() {
    unawaited(_foregroundSub?.cancel());
    unawaited(_foregroundPushSub?.cancel());
    unawaited(_backgroundTapSub?.cancel());
    return super.close();
  }
}
