import 'package:mocktail/mocktail.dart';
import 'package:passenger/core/network/connectivity_service.dart';
import 'package:passenger/core/services/auth_service.dart';
import 'package:passenger/core/services/device_token_service.dart';
import 'package:passenger/core/services/passenger_service.dart';
import 'package:passenger/core/services/push_notification_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockPassengerService extends Mock implements PassengerService {}

class MockPushNotificationService extends Mock
    implements PushNotificationService {}

class MockDeviceTokenService extends Mock implements DeviceTokenService {}

class MockConnectivityService extends Mock implements ConnectivityService {}
