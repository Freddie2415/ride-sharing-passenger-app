import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/phone_input_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/registration/profile_setup_screen.dart';
import '../../features/main/main_shell.dart';
import '../../features/search/search_screen.dart';
import '../../features/trips/trips_screen.dart';
import '../../features/chats/chats_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/settings_screen.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Auth flow routes
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

      // Main app with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // Determine which tab is active based on the current route
          int index = 0;
          final location = state.uri.path;
          if (location.startsWith('/home/trips')) {
            index = 1;
          } else if (location.startsWith('/home/chats')) {
            index = 2;
          } else if (location.startsWith('/home/profile')) {
            index = 3;
          }

          return MainShell(
            initialIndex: index,
            child: child,
          );
        },
        routes: [
          // Search tab (default)
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const SearchScreen(),
          ),
          // Trips tab
          GoRoute(
            path: '/home/trips',
            name: 'trips',
            builder: (context, state) => const TripsScreen(),
          ),
          // Chats tab
          GoRoute(
            path: '/home/chats',
            name: 'chats',
            builder: (context, state) => const ChatsScreen(),
          ),
          // Profile tab and its sub-routes
          GoRoute(
            path: '/home/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-profile',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'settings',
                name: 'settings',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
