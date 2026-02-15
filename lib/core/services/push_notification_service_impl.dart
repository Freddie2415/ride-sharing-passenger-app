import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/models/push_notification_data.dart';
import 'package:passenger/core/services/push_notification_service.dart';

const _tag = '[Push]';

@LazySingleton(as: PushNotificationService, dispose: disposePushNotificationService)
class PushNotificationServiceImpl implements PushNotificationService {
  PushNotificationServiceImpl()
      : _messaging = FirebaseMessaging.instance,
        _localNotifications = FlutterLocalNotificationsPlugin() {
    _initFuture = _initLocalNotifications();
  }

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  StreamSubscription<RemoteMessage>? _foregroundSub;

  /// Tracks init completion so [dispose] can wait for it.
  late final Future<void> _initFuture;

  /// Single broadcast controller for foreground messages, fed by the
  /// one and only `FirebaseMessaging.onMessage` subscription.
  final _foregroundMessageController =
      StreamController<PushNotificationData>.broadcast();

  bool _disposed = false;

  static const _androidChannel = AndroidNotificationChannel(
    'passenger_default',
    'Passenger Notifications',
    description: 'Default notification channel for passenger app',
    importance: Importance.high,
  );

  Future<void> _initLocalNotifications() async {
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings();
      const settings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );
      await _localNotifications.initialize(settings);
      debugPrint('$_tag Local notifications plugin initialized');

      // Create the Android notification channel
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(_androidChannel);
        debugPrint('$_tag Android channel created: ${_androidChannel.id}');
      }

      // If dispose was called while we were initializing, don't subscribe.
      if (_disposed) return;

      // Single subscription: show local notification + forward to stream
      _foregroundSub = FirebaseMessaging.onMessage.listen((message) {
        debugPrint('$_tag Foreground message received: '
            '${message.notification?.title}');
        _showLocalNotification(message);
        _foregroundMessageController.add(_remoteMessageToData(message));
      });
      debugPrint('$_tag Foreground listener subscribed');
    } on Object catch (e, st) {
      debugPrint('$_tag ERROR initializing local notifications: $e\n$st');
    }
  }

  @override
  Future<bool> checkPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<PushNotificationData> get onForegroundMessage =>
      _foregroundMessageController.stream;

  @override
  Stream<PushNotificationData> get onMessageOpenedApp {
    return FirebaseMessaging.onMessageOpenedApp.map(_remoteMessageToData);
  }

  @override
  Future<PushNotificationData?> getInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message == null) return null;
    return _remoteMessageToData(message);
  }

  PushNotificationData _remoteMessageToData(RemoteMessage message) {
    return PushNotificationData(
      title: message.notification?.title,
      body: message.notification?.body,
      type: message.data['type'] as String?,
      data: message.data.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      debugPrint('$_tag No notification payload — skipping local notification');
      return;
    }

    debugPrint('$_tag Showing local notification: '
        '${notification.title} / ${notification.body}');
    try {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: _androidChannel.importance,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
      debugPrint('$_tag Local notification shown successfully');
    } on Object catch (e, st) {
      debugPrint('$_tag ERROR showing local notification: $e\n$st');
    }
  }

  /// Wait for initialization to finish, then clean up subscriptions.
  Future<void> dispose() async {
    _disposed = true;
    await _initFuture;
    _foregroundSub?.cancel();
    _foregroundSub = null;
    _foregroundMessageController.close();
  }
}

/// Dispose callback for injectable.
Future<void> disposePushNotificationService(
  PushNotificationService service,
) async {
  if (service is PushNotificationServiceImpl) {
    await service.dispose();
  }
}
