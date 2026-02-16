import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';

part 'notifications_state.freezed.dart';

enum NotificationsStatus { initial, loading, loaded, error }

@Freezed(fromJson: false, toJson: false)
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(NotificationsStatus.initial) NotificationsStatus status,
    @Default([]) List<AppNotification> notifications,
    @Default(0) int unreadCount,
    @Default(1) int currentPage,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasPendingNavigation,
    String? errorMessage,
  }) = _NotificationsState;
}
