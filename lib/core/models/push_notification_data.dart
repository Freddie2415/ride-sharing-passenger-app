import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_data.freezed.dart';
part 'push_notification_data.g.dart';

/// Parsed push notification payload from FCM RemoteMessage.
@freezed
abstract class PushNotificationData with _$PushNotificationData {
  const factory PushNotificationData({
    String? title,
    String? body,
    String? type,
    @Default(<String, String>{}) Map<String, String> data,
  }) = _PushNotificationData;

  factory PushNotificationData.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationDataFromJson(json);
}
