import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/features/notifications/cubit/push_notification_cubit.dart';

import '../../../helpers/mocks.dart';

void main() {
  late PushNotificationCubit cubit;
  late MockPushNotificationService pushService;
  late MockDeviceTokenService deviceTokenService;
  late MockConnectivityService connectivity;
  late StreamController<String> tokenRefreshController;

  setUp(() {
    pushService = MockPushNotificationService();
    deviceTokenService = MockDeviceTokenService();
    connectivity = MockConnectivityService();
    tokenRefreshController = StreamController<String>.broadcast();

    when(() => pushService.onTokenRefresh)
        .thenAnswer((_) => tokenRefreshController.stream);

    cubit = PushNotificationCubit(
      pushNotificationService: pushService,
      deviceTokenService: deviceTokenService,
      connectivity: connectivity,
    );
  });

  tearDown(() async {
    await cubit.close();
    await tokenRefreshController.close();
  });

  group('PushNotificationCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, const PushNotificationState());
      expect(cubit.state.status, PushNotificationStatus.initial);
      expect(cubit.state.fcmToken, isNull);
      expect(cubit.state.serverTokenId, isNull);
      expect(cubit.state.errorMessage, isNull);
    });

    group('initialize', () {
      test(
        'emits permissionGranted when permission is already granted',
        () async {
          when(() => pushService.checkPermissionStatus())
              .thenAnswer((_) async => true);

          await cubit.initialize();

          expect(
            cubit.state.status,
            PushNotificationStatus.permissionGranted,
          );
        },
      );

      test('stays at initial when permission is not granted', () async {
        when(() => pushService.checkPermissionStatus())
            .thenAnswer((_) async => false);

        await cubit.initialize();

        expect(cubit.state.status, PushNotificationStatus.initial);
      });

      test(
        'subscribes to token refresh on permission granted',
        () async {
          when(() => pushService.checkPermissionStatus())
              .thenAnswer((_) async => true);

          await cubit.initialize();

          verify(() => pushService.onTokenRefresh).called(1);
        },
      );

      test(
        'does not subscribe to token refresh when permission not granted',
        () async {
          when(() => pushService.checkPermissionStatus())
              .thenAnswer((_) async => false);

          await cubit.initialize();

          verifyNever(() => pushService.onTokenRefresh);
        },
      );
    });

    group('requestPermission', () {
      test('emits permissionGranted when permission is granted', () async {
        when(() => pushService.requestPermission())
            .thenAnswer((_) async => true);

        await cubit.requestPermission();

        expect(
          cubit.state.status,
          PushNotificationStatus.permissionGranted,
        );
      });

      test('emits permissionDenied when permission is denied', () async {
        when(() => pushService.requestPermission())
            .thenAnswer((_) async => false);

        await cubit.requestPermission();

        expect(cubit.state.status, PushNotificationStatus.permissionDenied);
      });

      test(
        'subscribes to token refresh on permission granted',
        () async {
          when(() => pushService.requestPermission())
              .thenAnswer((_) async => true);

          await cubit.requestPermission();

          verify(() => pushService.onTokenRefresh).called(1);
        },
      );
    });

    group('enableAndRegister', () {
      test('emits loading then tokenRegistered on success', () async {
        when(() => pushService.requestPermission())
            .thenAnswer((_) async => true);
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-fcm-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenAnswer((_) async => 42);

        final states = <PushNotificationStatus>[];
        final sub = cubit.stream.listen((s) => states.add(s.status));

        await cubit.enableAndRegister();
        await sub.cancel();

        expect(states.first, PushNotificationStatus.loading);
        expect(cubit.state.status, PushNotificationStatus.tokenRegistered);
        expect(cubit.state.fcmToken, 'test-fcm-token');
        expect(cubit.state.serverTokenId, 42);
      });

      test('emits permissionDenied when permission denied', () async {
        when(() => pushService.requestPermission())
            .thenAnswer((_) async => false);

        final states = <PushNotificationStatus>[];
        final sub = cubit.stream.listen((s) => states.add(s.status));

        await cubit.enableAndRegister();
        await sub.cancel();

        expect(states.first, PushNotificationStatus.loading);
        expect(cubit.state.status, PushNotificationStatus.permissionDenied);
      });

      test('emits permissionGranted when token is null', () async {
        when(() => pushService.requestPermission())
            .thenAnswer((_) async => true);
        when(() => pushService.getToken()).thenAnswer((_) async => null);

        await cubit.enableAndRegister();

        expect(
          cubit.state.status,
          PushNotificationStatus.permissionGranted,
        );
      });

      test('emits error on API failure', () async {
        when(() => pushService.requestPermission())
            .thenAnswer((_) async => true);
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenThrow(const ApiException(message: 'Server error'));

        await cubit.enableAndRegister();

        expect(cubit.state.status, PushNotificationStatus.error);
        expect(cubit.state.errorMessage, 'Server error');
      });

      test('emits error when no connectivity', () async {
        when(() => pushService.requestPermission())
            .thenAnswer((_) async => true);
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => false);

        await cubit.enableAndRegister();

        expect(cubit.state.status, PushNotificationStatus.error);
        expect(cubit.state.errorMessage, ErrorMessages.noConnection);
      });
    });

    group('registerToken', () {
      test('registers token successfully', () async {
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-fcm-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenAnswer((_) async => 42);

        await cubit.registerToken();

        expect(cubit.state.status, PushNotificationStatus.tokenRegistered);
        expect(cubit.state.fcmToken, 'test-fcm-token');
        expect(cubit.state.serverTokenId, 42);
      });

      test('emits error when no connectivity', () async {
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-fcm-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => false);

        await cubit.registerToken();

        expect(cubit.state.status, PushNotificationStatus.error);
        expect(cubit.state.errorMessage, ErrorMessages.noConnection);
      });

      test('does nothing when getToken returns null', () async {
        when(() => pushService.getToken()).thenAnswer((_) async => null);

        await cubit.registerToken();

        expect(cubit.state.status, PushNotificationStatus.initial);
        verifyNever(() => connectivity.checkConnectivity());
      });

      test('emits error on ApiException', () async {
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-fcm-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenThrow(const ApiException(message: 'Server error'));

        await cubit.registerToken();

        expect(cubit.state.status, PushNotificationStatus.error);
        expect(cubit.state.errorMessage, 'Server error');
      });
    });

    group('removeToken', () {
      test('removes token and resets state', () async {
        // First register a token
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-fcm-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenAnswer((_) async => 42);
        when(() => deviceTokenService.removeToken(42))
            .thenAnswer((_) async {});

        await cubit.registerToken();
        expect(cubit.state.serverTokenId, 42);

        await cubit.removeToken();

        expect(cubit.state, const PushNotificationState());
        verify(() => deviceTokenService.removeToken(42)).called(1);
      });

      test('does nothing when serverTokenId is null', () async {
        await cubit.removeToken();

        verifyNever(() => deviceTokenService.removeToken(any()));
      });

      test('resets state even if removeToken throws', () async {
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'test-fcm-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenAnswer((_) async => 42);
        when(() => deviceTokenService.removeToken(42))
            .thenThrow(const ApiException(message: 'Network error'));

        await cubit.registerToken();
        await cubit.removeToken();

        expect(cubit.state, const PushNotificationState());
      });
    });

    group('resetState', () {
      test('resets state to initial', () async {
        when(() => pushService.checkPermissionStatus())
            .thenAnswer((_) async => true);

        await cubit.initialize();
        expect(
          cubit.state.status,
          PushNotificationStatus.permissionGranted,
        );

        cubit.resetState();

        expect(cubit.state, const PushNotificationState());
      });

      test('cancels token refresh subscription', () async {
        when(() => pushService.checkPermissionStatus())
            .thenAnswer((_) async => true);

        await cubit.initialize();
        cubit.resetState();

        // After reset, token refresh should not update state
        tokenRefreshController.add('should-be-ignored');
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.fcmToken, isNull);
      });
    });

    group('token refresh', () {
      test('updates fcmToken on token refresh', () async {
        when(() => pushService.checkPermissionStatus())
            .thenAnswer((_) async => true);

        await cubit.initialize();

        tokenRefreshController.add('new-token');
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.fcmToken, 'new-token');
      });

      test('re-registers token on refresh when already registered', () async {
        when(() => pushService.checkPermissionStatus())
            .thenAnswer((_) async => true);
        when(() => pushService.getToken())
            .thenAnswer((_) async => 'original-token');
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => true);
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenAnswer((_) async => 42);

        await cubit.initialize();
        await cubit.registerToken();
        expect(cubit.state.serverTokenId, 42);

        // Simulate token refresh
        when(
          () => deviceTokenService.registerToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceName: any(named: 'deviceName'),
          ),
        ).thenAnswer((_) async => 99);

        tokenRefreshController.add('refreshed-token');
        await Future<void>.delayed(Duration.zero);
        // Wait for _registerTokenValue to complete
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.fcmToken, 'refreshed-token');
      });
    });
  });
}
