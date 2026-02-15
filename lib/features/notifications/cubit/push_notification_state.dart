import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_state.freezed.dart';

enum PushNotificationStatus {
  initial,
  loading,
  permissionGranted,
  permissionDenied,
  tokenRegistered,
  error,
}

@Freezed(fromJson: false, toJson: false)
abstract class PushNotificationState with _$PushNotificationState {
  const factory PushNotificationState({
    @Default(PushNotificationStatus.initial) PushNotificationStatus status,
    String? fcmToken,
    int? serverTokenId,
    String? errorMessage,
  }) = _PushNotificationState;
}
