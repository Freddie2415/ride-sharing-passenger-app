import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Brief delay for splash animation
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final hasToken = await context.read<AuthCubit>().hasStoredToken();
    if (!mounted) return;

    if (hasToken) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Icon
            Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    size: 64,
                    color: AppColors.primary600,
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            const SizedBox(height: AppSpacing.xl),
            // App Name
            Text(
              'Intercity',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.primary600,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
            Text(
              'Rideshare',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: AppSpacing.md),
            // Tagline
            Text(
              'Travel Together',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.gray500),
            ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
            const SizedBox(height: AppSpacing.xxxl),
            // Loading indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary600),
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
