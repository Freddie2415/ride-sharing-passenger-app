import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/mocks/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            // Avatar and user info
            _buildProfileHeader(context, user),
            const SizedBox(height: AppSpacing.xxxl),
            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Info',
                    onTap: () => context.push('/home/profile/edit'),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.star_outline,
                    title: 'My Reviews',
                    onTap: () {
                      // TODO: My Reviews
                      _showComingSoon(context);
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Saved Routes',
                    onTap: () {
                      // TODO: Saved Routes
                      _showComingSoon(context);
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.history,
                    title: 'Trip History',
                    onTap: () {
                      // TODO: Trip History
                      _showComingSoon(context);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.lg),
                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () => context.push('/home/profile/settings'),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & FAQ',
                    onTap: () {
                      // TODO: Help
                      _showComingSoon(context);
                    },
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
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Map<String, dynamic> user) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gray200,
              width: 2,
            ),
          ),
          child: user['avatar'] != null
              ? ClipOval(
                  child: Image.network(
                    user['avatar'] as String,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.gray400,
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Name
        Text(
          user['name'] as String? ?? 'User',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Phone
        Text(
          user['phone'] as String? ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
        ),
      ],
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Mock: Navigate to onboarding
              // In real app: clear tokens and navigate
              context.go('/onboarding');
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showArrow;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary600).withValues(alpha: 0.1),
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
              Icon(
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
