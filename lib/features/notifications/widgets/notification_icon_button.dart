import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/features/notifications/cubit/notifications_cubit.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NotificationsCubit, NotificationsState, int>(
      selector: (state) => state.unreadCount,
      builder: (context, unreadCount) {
        return IconButton(
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text(
              unreadCount > 99 ? '99+' : unreadCount.toString(),
            ),
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () => context.push(AppRoutes.notifications),
        );
      },
    );
  }
}
