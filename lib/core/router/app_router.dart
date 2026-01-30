import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/phone_input_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/registration/profile_setup_screen.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/phone-input',
        name: 'phone-input',
        builder: (context, state) => const PhoneInputScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final data = state.extra as Map<String, String>? ?? {};
          return OtpScreen(
            apiPhone: data['apiPhone'] ?? '+15551234567',
            displayPhone: data['displayPhone'] ?? '+1 (555) 123-4567',
          );
        },
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
    ],
  );
}
