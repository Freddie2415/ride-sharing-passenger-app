import 'package:flutter_test/flutter_test.dart';
import 'package:passenger/core/models/push_notification_data.dart';

void main() {
  group('PushNotificationData', () {
    test('fromJson with all fields', () {
      final json = {
        'title': 'Trip Update',
        'body': 'Your driver is arriving',
        'type': 'trip_update',
        'data': {'trip_id': '123', 'status': 'arriving'},
      };

      final data = PushNotificationData.fromJson(json);

      expect(data.title, 'Trip Update');
      expect(data.body, 'Your driver is arriving');
      expect(data.type, 'trip_update');
      expect(data.data, {'trip_id': '123', 'status': 'arriving'});
    });

    test('fromJson with null optional fields', () {
      final json = <String, dynamic>{};

      final data = PushNotificationData.fromJson(json);

      expect(data.title, isNull);
      expect(data.body, isNull);
      expect(data.type, isNull);
      expect(data.data, isEmpty);
    });

    test('toJson produces correct map', () {
      const data = PushNotificationData(
        title: 'New Message',
        body: 'You have a new message from the driver',
        type: 'chat_message',
        data: {'chat_id': '456'},
      );

      final json = data.toJson();

      expect(json['title'], 'New Message');
      expect(json['body'], 'You have a new message from the driver');
      expect(json['type'], 'chat_message');
      expect(json['data'], {'chat_id': '456'});
    });

    test('toJson roundtrip', () {
      const original = PushNotificationData(
        title: 'Test',
        body: 'Test body',
        type: 'test_type',
        data: {'key': 'value'},
      );

      final json = original.toJson();
      final restored = PushNotificationData.fromJson(json);

      expect(restored, original);
    });

    test('default data is empty map', () {
      const data = PushNotificationData();

      expect(data.data, <String, String>{});
    });

    test('equality', () {
      const a = PushNotificationData(title: 'A', body: 'B');
      const b = PushNotificationData(title: 'A', body: 'B');
      const c = PushNotificationData(title: 'C', body: 'B');

      expect(a, b);
      expect(a, isNot(c));
    });

    test('copyWith', () {
      const original = PushNotificationData(
        title: 'Original',
        body: 'Body',
      );

      final modified = original.copyWith(title: 'Modified');

      expect(modified.title, 'Modified');
      expect(modified.body, 'Body');
    });
  });
}
