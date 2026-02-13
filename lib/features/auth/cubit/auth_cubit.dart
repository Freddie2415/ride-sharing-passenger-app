import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/network/connectivity_service.dart';
import 'package:passenger/core/services/auth_service.dart';
import 'package:passenger/core/utils/device_utils.dart';
import 'package:passenger/core/utils/phone_utils.dart';
import 'package:passenger/features/auth/cubit/auth_state.dart';

export 'package:passenger/features/auth/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthService authService,
    required ConnectivityService connectivity,
  }) : _authService = authService,
       _connectivity = connectivity,
       super(const AuthState());

  final AuthService _authService;
  final ConnectivityService _connectivity;

  /// Check if a stored token exists (for splash screen).
  Future<bool> hasStoredToken() => _authService.hasToken();

  /// Send OTP to phone number.
  Future<void> sendOtp(String phone) async {
    await _withErrorHandling(() async {
      await _authService.sendOtp(phone: cleanPhoneNumber(phone));
      emit(
        state.copyWith(
          status: AuthStatus.otpSent,
          errorMessage: null,
          fieldErrors: null,
          errorType: null,
        ),
      );
    });
  }

  /// Verify OTP code and authenticate.
  Future<void> verifyOtp(String phone, String code) async {
    await _withErrorHandling(() async {
      final deviceName = await getDeviceName();
      final result = await _authService.verifyOtp(
        phone: cleanPhoneNumber(phone),
        code: code,
        deviceName: deviceName,
      );

      await _authService.saveToken(result.token);
      if (isClosed) return;

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: result.user,
          lastAuthResult: result,
          errorMessage: null,
          fieldErrors: null,
          errorType: null,
        ),
      );
    });
  }

  /// Logout current session.
  Future<void> logout() => _performLogout(_authService.logout);

  /// Logout from all devices.
  Future<void> logoutAll() => _performLogout(_authService.logoutAll);

  /// Reset error state (e.g., when user dismisses error).
  void clearError() {
    emit(
      state.copyWith(
        status: AuthStatus.initial,
        errorMessage: null,
        fieldErrors: null,
        errorType: null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Shared error handling: sets loading state, checks connectivity,
  /// catches typed API exceptions.
  Future<void> _withErrorHandling(Future<void> Function() action) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
        fieldErrors: null,
        errorType: null,
      ),
    );

    if (!await _connectivity.checkConnectivity()) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMessages.noConnection,
          errorType: ErrorType.network,
        ),
      );
      return;
    }

    try {
      await action();
    } on RateLimitException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message,
          errorType: ErrorType.rateLimit,
        ),
      );
    } on ValidationException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
          errorType: ErrorType.validation,
        ),
      );
    } on NetworkException {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMessages.noConnection,
          errorType: ErrorType.network,
        ),
      );
    } on TimeoutException {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMessages.timeout,
          errorType: ErrorType.timeout,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message,
          errorType: ErrorType.unknown,
        ),
      );
    }
  }

  /// Shared logout logic: attempt server call, clear token regardless.
  Future<void> _performLogout(Future<void> Function() logoutFn) async {
    try {
      await logoutFn();
    } on Object catch (_) {
      // Ignore errors on logout — clear locally regardless
    }
    await _authService.clearToken();
    if (isClosed) return;
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
