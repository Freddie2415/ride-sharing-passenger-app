import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/widgets/empty_state.dart';
import 'package:passenger/core/widgets/error_state.dart';
import 'package:passenger/features/notifications/cubit/notifications_cubit.dart';
import 'package:passenger/features/notifications/models/app_notification.dart';
import 'package:passenger/features/notifications/widgets/notification_tile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<NotificationsCubit>();
    unawaited(_cubit.loadNotifications(refresh: true));
    _cubit.startRealtimeUpdates();
  }

  @override
  void dispose() {
    _cubit.stopRealtimeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocSelector<NotificationsCubit, NotificationsState, int>(
            selector: (state) => state.unreadCount,
            builder: (context, unreadCount) {
              if (unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationsCubit>().markAllAsRead(),
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return switch (state.status) {
            NotificationsStatus.initial ||
            NotificationsStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            NotificationsStatus.error => ErrorState(
                message: state.errorMessage,
                onRetry: () => context
                    .read<NotificationsCubit>()
                    .loadNotifications(refresh: true),
              ),
            NotificationsStatus.loaded => state.notifications.isEmpty
                ? const EmptyState(
                    icon: Icons.notifications_none,
                    title: 'No notifications yet',
                    subtitle: 'You will see your notifications here',
                  )
                : _NotificationsList(
                    notifications: state.notifications,
                    isLoadingMore: state.isLoadingMore,
                    hasMore: state.hasMore,
                  ),
          };
        },
      ),
    );
  }
}

class _NotificationsList extends StatefulWidget {
  const _NotificationsList({
    required this.notifications,
    required this.isLoadingMore,
    required this.hasMore,
  });

  final List<AppNotification> notifications;
  final bool isLoadingMore;
  final bool hasMore;

  @override
  State<_NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<_NotificationsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll - 200 && widget.hasMore) {
      context.read<NotificationsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context
          .read<NotificationsCubit>()
          .loadNotifications(refresh: true),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount:
            widget.notifications.length + (widget.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == widget.notifications.length) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final notification = widget.notifications[index];
          return NotificationTile(
            notification: notification,
            onTap: () {
              if (!notification.isRead) {
                context
                    .read<NotificationsCubit>()
                    .markAsRead(notification.id);
              }
            },
            onDismissed: () {
              context
                  .read<NotificationsCubit>()
                  .deleteNotification(notification.id);
            },
          );
        },
      ),
    );
  }
}

