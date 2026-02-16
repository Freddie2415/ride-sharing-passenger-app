import 'package:flutter/material.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/core/utils/time_format_utils.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
    super.key,
  });

  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.xs,
        ),
        tileColor: isUnread
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : null,
        leading: _NotificationIcon(type: notification.type),
        trailing: isUnread
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                ),
              )
            : null,
        title: Text(
          notification.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              formatTimeAgo(notification.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (type) {
      'trip_booked' || 'trip_confirmed' => (
        Icons.directions_car_rounded,
        AppColors.success,
      ),
      'trip_cancelled' => (Icons.cancel_rounded, AppColors.error),
      'chat_message' => (Icons.chat_bubble_rounded, AppColors.info),
      'payment' => (Icons.payment_rounded, AppColors.warning),
      _ => (Icons.notifications_rounded, AppColors.primary500),
    };

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.15),
      child: Icon(icon, color: color, size: AppSpacing.iconSizeSmall),
    );
  }
}
