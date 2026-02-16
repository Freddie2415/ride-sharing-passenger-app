import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/app/di/injection.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/theme/app_theme.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';
import 'package:passenger/features/notifications/cubit/notifications_cubit.dart';
import 'package:passenger/features/notifications/cubit/push_notification_cubit.dart';
import 'package:passenger/features/profile/cubit/profile_cubit.dart';

class PassengerApp extends StatelessWidget {
  const PassengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<PushNotificationCubit>()),
        BlocProvider(create: (_) => getIt<NotificationsCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: _onAuthStateChanged,
          ),
          BlocListener<NotificationsCubit, NotificationsState>(
            listenWhen: (previous, current) =>
                !previous.hasPendingNavigation && current.hasPendingNavigation,
            listener: (context, state) {
              context.read<NotificationsCubit>().clearPendingNavigation();
              AppRouter.router.push(AppRoutes.notifications);
            },
          ),
        ],
        child: MaterialApp.router(
          title: 'Intercity Rideshare',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      final pushCubit = context.read<PushNotificationCubit>();
      // Session restore (no lastAuthResult) or returning user login
      final isReturning = state.lastAuthResult?.isNewUser != true;
      unawaited(_initializePush(pushCubit, requestIfNeeded: isReturning));

      final notifCubit = context.read<NotificationsCubit>();
      unawaited(notifCubit.refreshUnreadCount());
      notifCubit.subscribeToPushUpdates();
    }

    if (state.status == AuthStatus.unauthenticated) {
      context.read<PushNotificationCubit>().resetState();
      context.read<NotificationsCubit>().cancelPushSubscriptions();
    }
  }

  /// Check push permission and register token.
  /// When [requestIfNeeded] is true (returning users), shows the system
  /// permission dialog if permission hasn't been granted yet.
  Future<void> _initializePush(
    PushNotificationCubit cubit, {
    bool requestIfNeeded = false,
  }) async {
    try {
      await cubit.initialize();
      if (cubit.state.status == PushNotificationStatus.permissionGranted) {
        await cubit.registerToken();
      } else if (requestIfNeeded) {
        await cubit.requestPermission();
        if (cubit.state.status == PushNotificationStatus.permissionGranted) {
          await cubit.registerToken();
        }
      }
    } on Exception catch (e) {
      debugPrint('[Push] initialization error: $e');
    }
  }
}
