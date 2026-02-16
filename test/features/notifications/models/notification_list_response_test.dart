import 'package:flutter_test/flutter_test.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';
import 'package:passenger/features/notifications/models/notification_list_response.dart';

void main() {
  group('NotificationListResponse', () {
    group('fromJson', () {
      test('parses complete JSON correctly', () {
        final json = {
          'notifications': [
            {
              'id': 'notif-1',
              'type': 'trip_booked',
              'title': 'Trip Booked',
              'message': 'Your trip has been booked',
              'created_at': '2026-01-15T12:00:00.000Z',
              'read_at': null,
            },
            {
              'id': 'notif-2',
              'type': 'chat_message',
              'title': 'New Message',
              'message': 'You have a new message',
              'created_at': '2026-01-15T11:00:00.000Z',
              'read_at': '2026-01-15T11:30:00.000Z',
            },
          ],
          'current_page': 1,
          'last_page': 3,
          'per_page': 20,
          'total': 50,
        };

        final response = NotificationListResponse.fromJson(json);

        expect(response.notifications.length, 2);
        expect(response.notifications[0].id, 'notif-1');
        expect(response.notifications[1].id, 'notif-2');
        expect(response.currentPage, 1);
        expect(response.lastPage, 3);
        expect(response.perPage, 20);
        expect(response.total, 50);
      });

      test('parses JSON with empty notifications', () {
        final json = {
          'notifications': <dynamic>[],
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
          'total': 0,
        };

        final response = NotificationListResponse.fromJson(json);

        expect(response.notifications, isEmpty);
        expect(response.total, 0);
      });
    });

    group('toJson', () {
      test('serializes to JSON correctly', () {
        final response = NotificationListResponse(
          notifications: [
            AppNotification(
              id: 'notif-1',
              type: 'trip_booked',
              title: 'Trip',
              message: 'Booked',
              createdAt: DateTime.utc(2026, 1, 15, 12),
            ),
          ],
          currentPage: 2,
          lastPage: 5,
          perPage: 10,
          total: 50,
        );

        final json = response.toJson();

        expect(json['current_page'], 2);
        expect(json['last_page'], 5);
        expect(json['per_page'], 10);
        expect(json['total'], 50);
        expect((json['notifications'] as List).length, 1);
      });
    });

    group('equality', () {
      test('two responses with same values are equal', () {
        final notifications = [
          AppNotification(
            id: '1',
            type: 'trip_booked',
            title: 'Test',
            message: 'Test',
            createdAt: DateTime(2026, 1, 15),
          ),
        ];

        final a = NotificationListResponse(
          notifications: notifications,
          currentPage: 1,
          lastPage: 1,
          perPage: 20,
          total: 1,
        );
        final b = NotificationListResponse(
          notifications: notifications,
          currentPage: 1,
          lastPage: 1,
          perPage: 20,
          total: 1,
        );

        expect(a, equals(b));
      });
    });
  });
}
