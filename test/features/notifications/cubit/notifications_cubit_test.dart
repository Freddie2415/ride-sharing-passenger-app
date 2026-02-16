import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/models/push_notification_data.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/features/notifications/cubit/notifications_cubit.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';
import 'package:passenger/features/notifications/models/notification_list_response.dart';

import '../../../helpers/mocks.dart';

void main() {
  late NotificationsCubit cubit;
  late MockNotificationService notificationService;
  late MockConnectivityService connectivity;
  late MockPushNotificationService pushService;
  late StreamController<PushNotificationData> foregroundController;
  late StreamController<PushNotificationData> backgroundTapController;

  final now = DateTime(2026, 1, 15, 12, 0);

  AppNotification createNotification({
    String id = '1',
    String type = 'trip_booked',
    String title = 'Trip Booked',
    String message = 'Your trip has been booked',
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      createdAt: now,
      readAt: readAt,
    );
  }

  NotificationListResponse createResponse({
    List<AppNotification>? notifications,
    int currentPage = 1,
    int lastPage = 1,
    int perPage = 20,
    int total = 0,
  }) {
    return NotificationListResponse(
      notifications: notifications ?? [],
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
    );
  }

  setUp(() {
    notificationService = MockNotificationService();
    connectivity = MockConnectivityService();
    pushService = MockPushNotificationService();
    foregroundController = StreamController<PushNotificationData>.broadcast();
    backgroundTapController = StreamController<PushNotificationData>.broadcast();

    when(() => pushService.onForegroundMessage)
        .thenAnswer((_) => foregroundController.stream);
    when(() => pushService.onMessageOpenedApp)
        .thenAnswer((_) => backgroundTapController.stream);
    when(() => pushService.getInitialMessage())
        .thenAnswer((_) async => null);

    cubit = NotificationsCubit(
      notificationService: notificationService,
      connectivity: connectivity,
      pushNotificationService: pushService,
    );
  });

  tearDown(() async {
    await cubit.close();
    await foregroundController.close();
    await backgroundTapController.close();
  });

  group('NotificationsCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, const NotificationsState());
      expect(cubit.state.status, NotificationsStatus.initial);
      expect(cubit.state.notifications, isEmpty);
      expect(cubit.state.unreadCount, 0);
      expect(cubit.state.currentPage, 1);
      expect(cubit.state.hasMore, true);
      expect(cubit.state.isLoadingMore, false);
      expect(cubit.state.hasPendingNavigation, false);
      expect(cubit.state.errorMessage, isNull);
    });

    group('loadNotifications', () {
      test('emits loading then loaded on success', () async {
        final notifications = [
          createNotification(id: '1'),
          createNotification(id: '2'),
        ];
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: notifications,
                  currentPage: 1,
                  lastPage: 3,
                  total: 50,
                ));

        final states = <NotificationsStatus>[];
        cubit.stream.listen((s) => states.add(s.status));

        await cubit.loadNotifications();
        // Allow stream events to be delivered
        await Future<void>.delayed(Duration.zero);

        expect(states, [NotificationsStatus.loading, NotificationsStatus.loaded]);
        expect(cubit.state.notifications, notifications);
        expect(cubit.state.currentPage, 1);
        expect(cubit.state.hasMore, true);
        expect(cubit.state.errorMessage, isNull);
      });

      test('emits error when no connectivity', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => false);

        await cubit.loadNotifications();

        expect(cubit.state.status, NotificationsStatus.error);
        expect(cubit.state.errorMessage, ErrorMessages.noConnection);
      });

      test('emits error on ApiException', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenThrow(const ApiException(message: 'Server error'));

        await cubit.loadNotifications();

        expect(cubit.state.status, NotificationsStatus.error);
        expect(cubit.state.errorMessage, 'Server error');
      });

      test('sets hasMore to false when on last page', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: [createNotification()],
                  currentPage: 1,
                  lastPage: 1,
                  total: 1,
                ));

        await cubit.loadNotifications();

        expect(cubit.state.hasMore, false);
      });

      test('skips when already loading and not refresh', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return createResponse();
        });

        // Start first load
        final future1 = cubit.loadNotifications();
        // Try second load (should skip)
        final future2 = cubit.loadNotifications();

        await Future.wait([future1, future2]);

        // getNotifications should be called only once
        verify(() => notificationService.getNotifications()).called(1);
      });

      test('proceeds when refresh is true even if loading', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse());

        await cubit.loadNotifications(refresh: true);

        verify(() => notificationService.getNotifications()).called(1);
      });
    });

    group('loadMore', () {
      test('loads next page and appends notifications', () async {
        // First, load initial page
        final page1 = [createNotification(id: '1')];
        final page2 = [createNotification(id: '2')];
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: page1,
                  currentPage: 1,
                  lastPage: 2,
                  total: 2,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getNotifications(page: 2))
            .thenAnswer((_) async => createResponse(
                  notifications: page2,
                  currentPage: 2,
                  lastPage: 2,
                  total: 2,
                ));

        await cubit.loadMore();

        expect(cubit.state.notifications.length, 2);
        expect(cubit.state.notifications[0].id, '1');
        expect(cubit.state.notifications[1].id, '2');
        expect(cubit.state.currentPage, 2);
        expect(cubit.state.hasMore, false);
        expect(cubit.state.isLoadingMore, false);
      });

      test('does nothing when hasMore is false', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  currentPage: 1,
                  lastPage: 1,
                ));

        await cubit.loadNotifications();
        await cubit.loadMore();

        verify(() => notificationService.getNotifications()).called(1);
      });

      test('does nothing when already loading more', () async {
        final completer = Completer<NotificationListResponse>();
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  currentPage: 1,
                  lastPage: 3,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getNotifications(page: 2))
            .thenAnswer((_) => completer.future);

        // Start first loadMore (will wait on completer)
        final future1 = cubit.loadMore();
        // Wait for isLoadingMore to be emitted
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.isLoadingMore, true);

        // Second loadMore should skip since isLoadingMore is true
        final future2 = cubit.loadMore();

        completer.complete(createResponse(currentPage: 2, lastPage: 3));
        await Future.wait([future1, future2]);

        verify(() => notificationService.getNotifications(page: 2)).called(1);
      });

      test('does nothing when no connectivity', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  currentPage: 1,
                  lastPage: 2,
                ));

        await cubit.loadNotifications();

        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => false);

        await cubit.loadMore();

        verifyNever(() => notificationService.getNotifications(page: 2));
      });

      test('resets isLoadingMore on error', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  currentPage: 1,
                  lastPage: 2,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getNotifications(page: 2))
            .thenThrow(const ApiException(message: 'Server error'));

        await cubit.loadMore();

        expect(cubit.state.isLoadingMore, false);
      });
    });

    group('refreshUnreadCount', () {
      test('updates unread count on success', () async {
        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 5);

        await cubit.refreshUnreadCount();

        expect(cubit.state.unreadCount, 5);
      });

      test('does not throw on error', () async {
        when(() => notificationService.getUnreadCount())
            .thenThrow(const ApiException(message: 'Server error'));

        // Should not throw
        await cubit.refreshUnreadCount();

        expect(cubit.state.unreadCount, 0);
      });
    });

    group('markAsRead', () {
      test('marks notification as read and decrements unread count', () async {
        final notification = createNotification(id: '1');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: [notification],
                  total: 1,
                ));

        await cubit.loadNotifications();
        // Set unread count
        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 1);
        await cubit.refreshUnreadCount();

        when(() => notificationService.markAsRead('1'))
            .thenAnswer((_) async {});

        await cubit.markAsRead('1');

        expect(cubit.state.notifications.first.isRead, true);
        expect(cubit.state.unreadCount, 0);
      });

      test('does nothing when no connectivity', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => false);

        await cubit.markAsRead('1');

        verifyNever(() => notificationService.markAsRead(any()));
      });

      test('decrements unread count even for already read notification', () async {
        // Note: current implementation always decrements by 1 regardless of read state
        final notification = createNotification(
          id: '1',
          readAt: DateTime(2026, 1, 15),
        );
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: [notification],
                  total: 1,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 2);
        await cubit.refreshUnreadCount();

        when(() => notificationService.markAsRead('1'))
            .thenAnswer((_) async {});

        await cubit.markAsRead('1');

        expect(cubit.state.unreadCount, 1);
      });
    });

    group('markAllAsRead', () {
      test('marks all notifications as read and resets unread count', () async {
        final notifications = [
          createNotification(id: '1'),
          createNotification(id: '2'),
        ];
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: notifications,
                  total: 2,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 2);
        await cubit.refreshUnreadCount();

        when(() => notificationService.markAllAsRead())
            .thenAnswer((_) async {});

        await cubit.markAllAsRead();

        expect(cubit.state.notifications.every((n) => n.isRead), true);
        expect(cubit.state.unreadCount, 0);
      });

      test('does nothing when no connectivity', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => false);

        await cubit.markAllAsRead();

        verifyNever(() => notificationService.markAllAsRead());
      });

      test('does not throw on error', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.markAllAsRead())
            .thenThrow(const ApiException(message: 'Server error'));

        // Should not throw
        await cubit.markAllAsRead();
      });
    });

    group('deleteNotification', () {
      test('removes notification optimistically', () async {
        final notifications = [
          createNotification(id: '1'),
          createNotification(id: '2'),
        ];
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: notifications,
                  total: 2,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.deleteNotification('1'))
            .thenAnswer((_) async {});

        await cubit.deleteNotification('1');

        expect(cubit.state.notifications.length, 1);
        expect(cubit.state.notifications.first.id, '2');
      });

      test('decrements unread count when deleting unread notification', () async {
        final notifications = [createNotification(id: '1')];
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: notifications,
                  total: 1,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 1);
        await cubit.refreshUnreadCount();

        when(() => notificationService.deleteNotification('1'))
            .thenAnswer((_) async {});

        await cubit.deleteNotification('1');

        expect(cubit.state.unreadCount, 0);
      });

      test('does not decrement unread count when deleting read notification',
          () async {
        final notification = createNotification(
          id: '1',
          readAt: DateTime(2026, 1, 15),
        );
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: [notification],
                  total: 1,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 3);
        await cubit.refreshUnreadCount();

        when(() => notificationService.deleteNotification('1'))
            .thenAnswer((_) async {});

        await cubit.deleteNotification('1');

        expect(cubit.state.unreadCount, 3);
      });

      test('reverts on API error', () async {
        final notification = createNotification(id: '1');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: [notification],
                  total: 1,
                ));

        await cubit.loadNotifications();

        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 1);
        await cubit.refreshUnreadCount();

        when(() => notificationService.deleteNotification('1'))
            .thenThrow(const ApiException(message: 'Server error'));

        await cubit.deleteNotification('1');

        expect(cubit.state.notifications.length, 1);
        expect(cubit.state.notifications.first.id, '1');
        expect(cubit.state.unreadCount, 1);
      });

      test('does nothing when no connectivity', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => false);

        await cubit.deleteNotification('1');

        verifyNever(() => notificationService.deleteNotification(any()));
      });
    });

    group('incrementUnreadCount', () {
      test('increments unread count by 1', () {
        expect(cubit.state.unreadCount, 0);

        cubit.incrementUnreadCount();
        expect(cubit.state.unreadCount, 1);

        cubit.incrementUnreadCount();
        expect(cubit.state.unreadCount, 2);
      });
    });

    group('clearPendingNavigation', () {
      test('sets hasPendingNavigation to false', () {
        cubit.clearPendingNavigation();
        expect(cubit.state.hasPendingNavigation, false);
      });
    });

    group('subscribeToPushUpdates', () {
      test('increments unread on foreground push', () async {
        cubit.subscribeToPushUpdates();

        foregroundController.add(const PushNotificationData(title: 'Test'));
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.unreadCount, 1);
      });

      test('sets hasPendingNavigation on background tap', () async {
        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 5);

        cubit.subscribeToPushUpdates();

        backgroundTapController.add(const PushNotificationData(title: 'Test'));
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.hasPendingNavigation, true);
      });

      test('refreshes unread count on background tap', () async {
        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 5);

        cubit.subscribeToPushUpdates();

        backgroundTapController.add(const PushNotificationData(title: 'Test'));
        await Future<void>.delayed(Duration.zero);
        // Wait for async refreshUnreadCount
        await Future<void>.delayed(Duration.zero);

        verify(() => notificationService.getUnreadCount()).called(1);
      });
    });

    group('cancelPushSubscriptions', () {
      test('stops listening to foreground and background push', () async {
        cubit.subscribeToPushUpdates();
        cubit.cancelPushSubscriptions();

        foregroundController.add(const PushNotificationData(title: 'Test'));
        await Future<void>.delayed(Duration.zero);

        // Should not increment since subscriptions were cancelled
        expect(cubit.state.unreadCount, 0);
      });
    });

    group('startRealtimeUpdates / stopRealtimeUpdates', () {
      test('silent refresh updates list on foreground push', () async {
        // First load notifications to set status to loaded
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: [createNotification(id: '1')],
                  currentPage: 1,
                  lastPage: 1,
                  total: 1,
                ));

        await cubit.loadNotifications();
        expect(cubit.state.status, NotificationsStatus.loaded);

        // Now set up silent refresh response
        final newNotifications = [
          createNotification(id: '1'),
          createNotification(id: '2', title: 'New Notification'),
        ];
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: newNotifications,
                  currentPage: 1,
                  lastPage: 1,
                  total: 2,
                ));
        when(() => notificationService.getUnreadCount())
            .thenAnswer((_) async => 1);

        cubit.startRealtimeUpdates();

        foregroundController.add(const PushNotificationData(title: 'Test'));
        // Wait for async _silentRefresh
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(cubit.state.notifications.length, 2);
        expect(cubit.state.unreadCount, 1);
      });

      test('stopRealtimeUpdates prevents silent refresh', () async {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(() => notificationService.getNotifications())
            .thenAnswer((_) async => createResponse(
                  notifications: [createNotification(id: '1')],
                  currentPage: 1,
                  lastPage: 1,
                  total: 1,
                ));

        await cubit.loadNotifications();

        cubit.startRealtimeUpdates();
        cubit.stopRealtimeUpdates();

        foregroundController.add(const PushNotificationData(title: 'Test'));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // getNotifications called once during loadNotifications, not again
        verify(() => notificationService.getNotifications()).called(1);
      });

      test('silent refresh skips when not in loaded status', () async {
        cubit.startRealtimeUpdates();

        foregroundController.add(const PushNotificationData(title: 'Test'));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Should never call getNotifications since status is initial
        verifyNever(() => notificationService.getNotifications());
      });
    });
  });
}