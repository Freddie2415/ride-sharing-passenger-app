import 'package:flutter_test/flutter_test.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';

void main() {
  group('AppNotification', () {
    group('fromJson', () {
      test('parses complete JSON correctly', () {
        final json = {
          'id': 'notif-123',
          'type': 'trip_booked',
          'title': 'Trip Booked',
          'message': 'Your trip from A to B has been booked',
          'created_at': '2026-01-15T12:00:00.000Z',
          'data': {'trip_id': '456'},
          'read_at': '2026-01-15T13:00:00.000Z',
        };

        final notification = AppNotification.fromJson(json);

        expect(notification.id, 'notif-123');
        expect(notification.type, 'trip_booked');
        expect(notification.title, 'Trip Booked');
        expect(notification.message, 'Your trip from A to B has been booked');
        expect(notification.createdAt, DateTime.utc(2026, 1, 15, 12));
        expect(notification.data, {'trip_id': '456'});
        expect(notification.readAt, DateTime.utc(2026, 1, 15, 13));
      });

      test('parses JSON with null read_at', () {
        final json = {
          'id': 'notif-123',
          'type': 'trip_booked',
          'title': 'Trip Booked',
          'message': 'Your trip has been booked',
          'created_at': '2026-01-15T12:00:00.000Z',
        };

        final notification = AppNotification.fromJson(json);

        expect(notification.readAt, isNull);
        expect(notification.data, isEmpty);
      });

      test('parses JSON with empty data', () {
        final json = {
          'id': 'notif-123',
          'type': 'chat_message',
          'title': 'New Message',
          'message': 'You have a new message',
          'created_at': '2026-01-15T12:00:00.000Z',
          'data': <String, dynamic>{},
          'read_at': null,
        };

        final notification = AppNotification.fromJson(json);

        expect(notification.data, isEmpty);
      });
    });

    group('toJson', () {
      test('serializes to JSON correctly', () {
        final notification = AppNotification(
          id: 'notif-123',
          type: 'trip_booked',
          title: 'Trip Booked',
          message: 'Your trip has been booked',
          createdAt: DateTime.utc(2026, 1, 15, 12),
          readAt: DateTime.utc(2026, 1, 15, 13),
        );

        final json = notification.toJson();

        expect(json['id'], 'notif-123');
        expect(json['type'], 'trip_booked');
        expect(json['title'], 'Trip Booked');
        expect(json['message'], 'Your trip has been booked');
        expect(json['created_at'], '2026-01-15T12:00:00.000Z');
        expect(json['read_at'], '2026-01-15T13:00:00.000Z');
      });

      test('serializes null read_at correctly', () {
        final notification = AppNotification(
          id: 'notif-123',
          type: 'trip_booked',
          title: 'Trip Booked',
          message: 'Your trip has been booked',
          createdAt: DateTime.utc(2026, 1, 15, 12),
        );

        final json = notification.toJson();

        expect(json['read_at'], isNull);
      });
    });

    group('isRead', () {
      test('returns true when readAt is not null', () {
        final notification = AppNotification(
          id: '1',
          type: 'trip_booked',
          title: 'Trip Booked',
          message: 'Test',
          createdAt: DateTime(2026, 1, 15),
          readAt: DateTime(2026, 1, 15, 13),
        );

        expect(notification.isRead, true);
      });

      test('returns false when readAt is null', () {
        final notification = AppNotification(
          id: '1',
          type: 'trip_booked',
          title: 'Trip Booked',
          message: 'Test',
          createdAt: DateTime(2026, 1, 15),
        );

        expect(notification.isRead, false);
      });
    });

    group('copyWith', () {
      test('creates a copy with updated readAt', () {
        final notification = AppNotification(
          id: '1',
          type: 'trip_booked',
          title: 'Trip Booked',
          message: 'Test',
          createdAt: DateTime(2026, 1, 15),
        );

        final read = notification.copyWith(readAt: DateTime(2026, 1, 15, 13));

        expect(read.isRead, true);
        expect(notification.isRead, false);
        expect(read.id, notification.id);
      });
    });

    group('equality', () {
      test('two notifications with same values are equal', () {
        final a = AppNotification(
          id: '1',
          type: 'trip_booked',
          title: 'Test',
          message: 'Test',
          createdAt: DateTime(2026, 1, 15),
        );
        final b = AppNotification(
          id: '1',
          type: 'trip_booked',
          title: 'Test',
          message: 'Test',
          createdAt: DateTime(2026, 1, 15),
        );

        expect(a, equals(b));
      });

      test('two notifications with different ids are not equal', () {
        final a = AppNotification(
          id: '1',
          type: 'trip_booked',
          title: 'Test',
          message: 'Test',
          createdAt: DateTime(2026, 1, 15),
        );
        final b = AppNotification(
          id: '2',
          type: 'trip_booked',
          title: 'Test',
          message: 'Test',
          createdAt: DateTime(2026, 1, 15),
        );

        expect(a, isNot(equals(b)));
      });
    });
  });
}