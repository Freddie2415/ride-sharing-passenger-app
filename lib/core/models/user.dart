import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String uuid,
    required String phone,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? name,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'middle_name') String? middleName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    String? avatar,
    String? locale,
    String? timezone,
    @JsonKey(name: 'phone_verified') @Default(false) bool phoneVerified,
    @JsonKey(name: 'email_verified') @Default(false) bool emailVerified,
    @Default([]) List<String> roles,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  bool get isDriver => roles.contains('driver');
  bool get isPassenger => roles.contains('passenger');
}
