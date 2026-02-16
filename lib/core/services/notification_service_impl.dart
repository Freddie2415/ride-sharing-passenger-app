import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/network/api_client.dart';
import 'package:passenger/core/services/notification_service.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';
import 'package:passenger/features/notifications/models/notification_list_response.dart';

@LazySingleton(as: NotificationService)
class NotificationServiceImpl implements NotificationService {
  NotificationServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<NotificationListResponse> getNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/notifications',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final body = asResponseMap(response.data);
      final data = asResponseMap(body['data']);
      final meta = asResponseMap(body['meta']);
      final notificationsJson = data['notifications'] as List<dynamic>? ?? [];

      final notifications = notificationsJson
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList();

      return NotificationListResponse(
        notifications: notifications,
        currentPage: meta['current_page'] as int? ?? page,
        lastPage: meta['last_page'] as int? ?? 1,
        perPage: meta['per_page'] as int? ?? perPage,
        total: meta['total'] as int? ?? 0,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get<dynamic>('/notifications/unread-count');
      final body = asResponseMap(response.data);
      final data = asResponseMap(body['data']);
      return data['unread_count'] as int? ?? 0;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.post<dynamic>('/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dio.post<dynamic>('/notifications/read-all');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _dio.delete<dynamic>('/notifications/$notificationId');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
