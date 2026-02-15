// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushNotificationData _$PushNotificationDataFromJson(
  Map<String, dynamic> json,
) => _PushNotificationData(
  title: json['title'] as String?,
  body: json['body'] as String?,
  type: json['type'] as String?,
  data:
      (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$PushNotificationDataToJson(
  _PushNotificationData instance,
) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'type': instance.type,
  'data': instance.data,
};
