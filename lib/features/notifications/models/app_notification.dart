import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String type,
    required String title,
    required String message,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    @JsonKey(name: 'read_at') DateTime? readAt,
  }) = _AppNotification;

  const AppNotification._();

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  bool get isRead => readAt != null;
}
