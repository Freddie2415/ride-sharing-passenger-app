import 'package:passenger/features/notifications/models/notification_list_response.dart';

/// Service for managing in-app notifications via backend API.
abstract class NotificationService {
  Future<NotificationListResponse> getNotifications({
    int page = 1,
    int perPage = 20,
  });

  Future<int> getUnreadCount();

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<void> deleteNotification(String notificationId);
}
