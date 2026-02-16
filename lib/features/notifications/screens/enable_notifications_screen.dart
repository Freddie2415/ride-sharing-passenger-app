import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/widgets/app_button.dart';
import 'package:passenger/features/notifications/cubit/push_notification_cubit.dart';

class EnableNotificationsScreen extends StatefulWidget {
  const EnableNotificationsScreen({super.key});

  @override
  State<EnableNotificationsScreen> createState() =>
      _EnableNotificationsScreenState();
}

class _EnableNotificationsScreenState extends State<EnableNotificationsScreen> {
  Future<void> _onEnable() async {
    final pushCubit = context.read<PushNotificationCubit>();
    await pushCubit.enableAndRegister();
    if (!mounted) return;

    if (pushCubit.state.status == PushNotificationStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(pushCubit.state.errorMessage ?? 'Something went wrong'),
        ),
      );
      return;
    }

    context.go(AppRoutes.home);
  }

  void _onSkip() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = context.select(
      (PushNotificationCubit cubit) =>
          cubit.state.status == PushNotificationStatus.loading,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              const Spacer(),
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: theme.colorScheme.primary,
                      size: 64,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Enable Notifications',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Get notified about your trip updates, '
                'driver arrivals, and important messages.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.xxl),
              const _BenefitsList()
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms),
              const Spacer(),
              AppButton(
                onPressed: isLoading ? null : _onEnable,
                label: 'Enable Notifications',
                icon: Icons.notifications_rounded,
                isLoading: isLoading,
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                onPressed: isLoading ? null : _onSkip,
                label: 'Maybe Later',
                variant: AppButtonVariant.text,
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  const _BenefitsList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const benefits = [
      (icon: Icons.route_rounded, text: 'Real-time trip status updates'),
      (icon: Icons.local_taxi_rounded, text: 'Driver arrival notifications'),
      (icon: Icons.chat_rounded, text: 'Messages from your driver'),
    ];

    return Column(
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  benefit.icon,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  benefit.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
