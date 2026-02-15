import 'package:passenger/core/models/push_notification_data.dart';

/// Service for interacting with Firebase Cloud Messaging.
abstract class PushNotificationService {
  /// Check current notification permission status without showing a dialog.
  /// Returns `true` if permission was already granted.
  Future<bool> checkPermissionStatus();

  /// Request notification permissions from the user (shows system dialog).
  /// Returns `true` if permission was granted.
  Future<bool> requestPermission();

  /// Get the current FCM registration token.
  Future<String?> getToken();

  /// Stream of FCM token updates (when token is refreshed).
  Stream<String> get onTokenRefresh;

  /// Stream of push notifications received while the app is in foreground.
  Stream<PushNotificationData> get onForegroundMessage;

  /// Stream of push notifications tapped while the app was in background.
  Stream<PushNotificationData> get onMessageOpenedApp;

  /// Returns the notification that launched the app from terminated state.
  Future<PushNotificationData?> getInitialMessage();
}
