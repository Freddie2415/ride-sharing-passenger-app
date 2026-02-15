import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';
import 'package:passenger/features/notifications/cubit/push_notification_cubit.dart';

/// Perform full logout:
/// 1. Navigate to login immediately
/// 2. Auth logout with FCM token (backend deactivates device token)
/// 3. Reset push notification state locally
void performFullLogout(BuildContext context) {
  final pushCubit = context.read<PushNotificationCubit>();
  final authCubit = context.read<AuthCubit>();
  final fcmToken = pushCubit.state.fcmToken;

  context.go(AppRoutes.phoneInput);
  unawaited(authCubit.logout(deviceToken: fcmToken));
  pushCubit.resetState();
}

/// Perform logout from all devices:
/// 1. Navigate to login immediately
/// 2. Auth logoutAll (backend deactivates all device tokens)
/// 3. Reset push notification state locally
void performFullLogoutAll(BuildContext context) {
  final pushCubit = context.read<PushNotificationCubit>();
  final authCubit = context.read<AuthCubit>();

  context.go(AppRoutes.phoneInput);
  unawaited(authCubit.logoutAll());
  pushCubit.resetState();
}
