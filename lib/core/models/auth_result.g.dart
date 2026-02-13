// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthResult _$AuthResultFromJson(Map<String, dynamic> json) => _AuthResult(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
  isNewUser: json['is_new_user'] as bool? ?? false,
  hasDriverProfile: json['has_driver_profile'] as bool? ?? false,
  tokenType: json['token_type'] as String? ?? 'Bearer',
);

Map<String, dynamic> _$AuthResultToJson(_AuthResult instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'is_new_user': instance.isNewUser,
      'has_driver_profile': instance.hasDriverProfile,
      'token_type': instance.tokenType,
    };
