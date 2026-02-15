import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/features/auth/screens/otp_screen.dart'
    show OtpRouteData, OtpScreen;
import 'package:passenger/features/auth/screens/phone_input_screen.dart';
import 'package:passenger/features/chats/screens/chats_screen.dart';
import 'package:passenger/features/home/main_shell.dart';
import 'package:passenger/features/notifications/screens/enable_notifications_screen.dart';
import 'package:passenger/features/onboarding/screens/onboarding_screen.dart';
import 'package:passenger/features/profile/screens/edit_profile_screen.dart';
import 'package:passenger/features/profile/screens/profile_screen.dart';
import 'package:passenger/features/profile/screens/settings_screen.dart';
import 'package:passenger/features/registration/screens/profile_setup_screen.dart';
import 'package:passenger/features/search/screens/search_screen.dart';
import 'package:passenger/features/splash/screens/splash_screen.dart';
import 'package:passenger/features/trips/screens/trips_screen.dart';

/// Route path constants used across the app.
abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const phoneInput = '/phone-input';
  static const otp = '/otp';
  static const profileSetup = '/profile-setup';
  static const enableNotifications = '/enable-notifications';
  static const home = '/home';
  static const trips = '/home/trips';
  static const chats = '/home/chats';
  static const profile = '/home/profile';
  static const editProfile = '/home/profile/edit';
  static const settings = '/home/profile/settings';
}

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneInput,
        name: 'phone-input',
        builder: (context, state) => const PhoneInputScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: 'otp',
        builder: (context, state) {
          final data = state.extra;
          if (data is! OtpRouteData) {
            return const Scaffold(
              body: Center(child: Text('Invalid route data')),
            );
          }
          return OtpScreen(routeData: data);
        },
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.enableNotifications,
        name: 'enable-notifications',
        builder: (context, state) => const EnableNotificationsScreen(),
      ),

      // Main app with bottom navigation (preserves tab state)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.trips,
                name: 'trips',
                builder: (context, state) => const TripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chats,
                name: 'chats',
                builder: (context, state) => const ChatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
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
      ),
    ],
  );
}
