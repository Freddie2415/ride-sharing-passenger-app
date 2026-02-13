import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:passenger/core/models/user.dart';

part 'auth_result.freezed.dart';
part 'auth_result.g.dart';

@freezed
abstract class AuthResult with _$AuthResult {
  const factory AuthResult({
    required User user,
    required String token,
    @JsonKey(name: 'is_new_user') @Default(false) bool isNewUser,
    @JsonKey(name: 'has_driver_profile') @Default(false) bool hasDriverProfile,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
  }) = _AuthResult;

  factory AuthResult.fromJson(Map<String, dynamic> json) =>
      _$AuthResultFromJson(json);

  /// Parses from API response with separate data and meta maps.
  factory AuthResult.fromResponse(
    Map<String, dynamic> data,
    Map<String, dynamic> meta,
  ) {
    return AuthResult(
      user: User.fromJson(data['user'] as Map<String, dynamic>),
      isNewUser: data['is_new_user'] as bool? ?? false,
      hasDriverProfile: data['has_driver_profile'] as bool? ?? false,
      token: meta['token'] as String,
      tokenType: meta['token_type'] as String? ?? 'Bearer',
    );
  }
}
