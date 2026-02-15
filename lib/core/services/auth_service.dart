import 'package:passenger/core/models/auth_result.dart';

/// Authentication service — OTP-based phone auth.
abstract class AuthService {
  Future<void> sendOtp({required String phone});

  Future<AuthResult> verifyOtp({
    required String phone,
    required String code,
    required String deviceName,
  });

  /// Logout current session. If [deviceToken] is provided, the backend
  /// deactivates that FCM token during logout.
  Future<void> logout({String? deviceToken});

  /// Logout from all devices. The backend deactivates all device tokens.
  Future<void> logoutAll();

  /// Save auth token to secure storage.
  Future<void> saveToken(String token);

  /// Check if a stored auth token exists.
  Future<bool> hasToken();

  /// Clear stored auth token.
  Future<void> clearToken();
}
