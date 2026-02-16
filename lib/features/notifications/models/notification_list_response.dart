import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';

part 'notification_list_response.freezed.dart';
part 'notification_list_response.g.dart';

@freezed
abstract class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required List<AppNotification> notifications,
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}
