import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/models/user.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';
import 'package:passenger/features/profile/cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final profileCubit = context.read<ProfileCubit>();
    if (!profileCubit.state.isLoaded) {
      profileCubit.loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (prev, curr) => curr.status == AuthStatus.unauthenticated,
          listener: (context, state) => context.go(AppRoutes.splash),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile'), centerTitle: true),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.hasError) {
              return _ProfileError(errorMessage: state.errorMessage);
            }

            final user = state.user;
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  _ProfileHeader(user: user),
                  const SizedBox(height: AppSpacing.xxxl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      children: [
                        _ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Personal Info',
                          onTap: () => context.push(AppRoutes.editProfile),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.star_outline,
                          title: 'My Reviews',
                          onTap: () => _showComingSoon(context),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Saved Routes',
                          onTap: () => _showComingSoon(context),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.history,
                          title: 'Trip History',
                          onTap: () => _showComingSoon(context),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(),
                        const SizedBox(height: AppSpacing.lg),
                        _ProfileMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          onTap: () => context.push(AppRoutes.settings),
                        ),
                        _ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & FAQ',
                          onTap: () => _showComingSoon(context),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(),
                        const SizedBox(height: AppSpacing.lg),
                        _ProfileMenuItem(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          textColor: AppColors.error,
                          iconColor: AppColors.error,
                          showArrow: false,
                          onTap: () => _showSignOutDialog(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.gray400),
            const SizedBox(height: AppSpacing.lg),
            Text(
              errorMessage ?? 'Failed to load profile',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(
              onPressed: () => context.read<ProfileCubit>().loadProfile(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final displayName =
        user.name ??
        [user.firstName, user.lastName].where((s) => s != null).join(' ');

    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gray200, width: 2),
          ),
          child: switch (user.avatar) {
            final avatarUrl? => ClipOval(
                child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.gray400,
                  ),
                  errorWidget: (_, _, _) => const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.gray400,
                  ),
                ),
              ),
            null => const Icon(Icons.person, size: 50, color: AppColors.gray400),
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          displayName.isNotEmpty ? displayName : 'User',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          user.phone,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.gray600),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showArrow = true,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary600).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary600,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.gray400,
              ),
          ],
        ),
      ),
    );
  }
}
