import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/app/di/injection.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/theme/app_theme.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';
import 'package:passenger/features/notifications/cubit/push_notification_cubit.dart';
import 'package:passenger/features/profile/cubit/profile_cubit.dart';

class PassengerApp extends StatelessWidget {
  const PassengerApp({super.key});

  /// Check push permission and register token.
  /// When [requestIfNeeded] is true (returning users), shows the system
  /// permission dialog if permission hasn't been granted yet.
  static Future<void> _initializePush(
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
    } on Object catch (e) {
      debugPrint('[Push] initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<PushNotificationCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            previous.status != current.status,
        listener: (context, state) {
          final pushCubit = context.read<PushNotificationCubit>();
          if (state.status == AuthStatus.authenticated) {
            final isReturning = state.lastAuthResult?.isNewUser == false;
            unawaited(
              _initializePush(pushCubit, requestIfNeeded: isReturning),
            );
          } else if (state.status == AuthStatus.unauthenticated) {
            pushCubit.resetState();
          }
        },
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
}
