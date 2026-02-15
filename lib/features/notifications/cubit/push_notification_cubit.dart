import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/network/connectivity_service.dart';
import 'package:passenger/core/services/device_token_service.dart';
import 'package:passenger/core/services/push_notification_service.dart';
import 'package:passenger/core/utils/device_utils.dart';
import 'package:passenger/features/notifications/cubit/push_notification_state.dart';

export 'package:passenger/features/notifications/cubit/push_notification_state.dart';

@injectable
class PushNotificationCubit extends Cubit<PushNotificationState> {
  PushNotificationCubit({
    required PushNotificationService pushNotificationService,
    required DeviceTokenService deviceTokenService,
    required ConnectivityService connectivity,
  })  : _pushService = pushNotificationService,
        _deviceTokenService = deviceTokenService,
        _connectivity = connectivity,
        super(const PushNotificationState());

  final PushNotificationService _pushService;
  final DeviceTokenService _deviceTokenService;
  final ConnectivityService _connectivity;

  StreamSubscription<String>? _tokenRefreshSub;

  /// Check current permission status without showing a dialog.
  /// Use this on app startup or after auth to silently detect
  /// whether notifications are already permitted.
  Future<void> initialize() async {
    debugPrint('[Push] initialize() — checking current permission status');
    final isGranted = await _pushService.checkPermissionStatus();
    debugPrint('[Push] current permission: $isGranted');
    if (isClosed) return;

    if (isGranted) {
      emit(state.copyWith(status: PushNotificationStatus.permissionGranted));
      _tokenRefreshSub ??=
          _pushService.onTokenRefresh.listen(_onTokenRefresh);
    }
    // If not granted, stay at initial — user hasn't been asked yet
  }

  /// Show the system permission dialog. Called explicitly from UI
  /// (e.g. EnableNotificationsScreen).
  Future<void> requestPermission() async {
    debugPrint('[Push] requestPermission() — showing system dialog');
    final granted = await _pushService.requestPermission();
    debugPrint('[Push] permission granted: $granted');
    if (isClosed) return;

    if (!granted) {
      emit(state.copyWith(status: PushNotificationStatus.permissionDenied));
      return;
    }

    emit(state.copyWith(status: PushNotificationStatus.permissionGranted));
    _tokenRefreshSub ??=
        _pushService.onTokenRefresh.listen(_onTokenRefresh);
  }

  /// Request permission and register the device token in one step.
  /// Emits [PushNotificationStatus.loading] while in progress.
  Future<void> enableAndRegister() async {
    emit(state.copyWith(status: PushNotificationStatus.loading));

    final granted = await _pushService.requestPermission();
    if (isClosed) return;

    if (!granted) {
      emit(state.copyWith(status: PushNotificationStatus.permissionDenied));
      return;
    }

    _tokenRefreshSub ??=
        _pushService.onTokenRefresh.listen(_onTokenRefresh);

    final token = await _pushService.getToken();
    if (isClosed) return;

    if (token == null) {
      debugPrint('[Push] Token is null — APNs configured?');
      emit(state.copyWith(status: PushNotificationStatus.permissionGranted));
      return;
    }

    await _registerTokenValue(token);
  }

  /// Register the current FCM token with the backend.
  Future<void> registerToken() async {
    final token = await _pushService.getToken();
    debugPrint('[Push] FCM token: $token');
    if (isClosed || token == null) {
      debugPrint('[Push] Token is null — cannot register. APNs configured?');
      return;
    }

    await _registerTokenValue(token);
  }

  /// Register a known token value with the backend.
  Future<void> _registerTokenValue(String token) async {
    emit(state.copyWith(fcmToken: token));

    if (!await _connectivity.checkConnectivity()) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: PushNotificationStatus.error,
          errorMessage: ErrorMessages.noConnection,
        ),
      );
      return;
    }

    try {
      final platform = Platform.isIOS ? 'ios' : 'android';
      final deviceName = await getDeviceName();

      final tokenId = await _deviceTokenService.registerToken(
        token: token,
        platform: platform,
        deviceName: deviceName,
      );
      if (isClosed) return;

      emit(
        state.copyWith(
          status: PushNotificationStatus.tokenRegistered,
          serverTokenId: tokenId,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: PushNotificationStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }

  /// Remove the device token from the backend (e.g. on logout).
  Future<void> removeToken() async {
    final tokenId = state.serverTokenId;
    if (tokenId == null) return;

    try {
      await _deviceTokenService.removeToken(tokenId);
    } on Object catch (_) {
      // Ignore errors on token removal — user is logging out regardless
    }
    if (isClosed) return;

    emit(const PushNotificationState());
  }

  /// Reset local push state without API call (e.g. during logout
  /// when the backend deactivates the token itself).
  void resetState() {
    if (isClosed) return;
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    emit(const PushNotificationState());
  }

  void _onTokenRefresh(String newToken) {
    if (isClosed) return;
    // Re-register the refreshed token if we already had a registered one
    if (state.serverTokenId != null) {
      unawaited(_registerTokenValue(newToken));
    } else {
      emit(state.copyWith(fcmToken: newToken));
    }
  }

  @override
  Future<void> close() async {
    await _tokenRefreshSub?.cancel();
    return super.close();
  }
}
