// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  uuid: json['uuid'] as String,
  phone: json['phone'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  name: json['name'] as String?,
  firstName: json['first_name'] as String?,
  middleName: json['middle_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String?,
  avatar: json['avatar'] as String?,
  locale: json['locale'] as String?,
  timezone: json['timezone'] as String?,
  phoneVerified: json['phone_verified'] as bool? ?? false,
  emailVerified: json['email_verified'] as bool? ?? false,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'phone': instance.phone,
  'created_at': instance.createdAt.toIso8601String(),
  'name': instance.name,
  'first_name': instance.firstName,
  'middle_name': instance.middleName,
  'last_name': instance.lastName,
  'email': instance.email,
  'avatar': instance.avatar,
  'locale': instance.locale,
  'timezone': instance.timezone,
  'phone_verified': instance.phoneVerified,
  'email_verified': instance.emailVerified,
  'roles': instance.roles,
};
