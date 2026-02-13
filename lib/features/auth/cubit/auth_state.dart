import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:passenger/core/models/auth_result.dart';
import 'package:passenger/core/models/user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  initial,
  loading,
  otpSent,
  authenticated,
  unauthenticated,
  error,
}

enum ErrorType {
  network,
  server,
  validation,
  rateLimit,
  timeout,
  unauthorized,
  conflict,
  unknown,
}

@Freezed(fromJson: false, toJson: false)
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    User? user,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
    ErrorType? errorType,
    AuthResult? lastAuthResult,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}
