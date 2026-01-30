import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            // Notifications section
            _buildSectionHeader(context, 'Notifications'),
            _SettingsSwitch(
              title: 'Push Notifications',
              value: true,
              onChanged: (value) {
                // TODO: Toggle push notifications
              },
            ),
            _SettingsSwitch(
              title: 'Booking Status',
              value: true,
              onChanged: (value) {
                // TODO: Toggle booking status
              },
            ),
            _SettingsSwitch(
              title: 'Messages from Drivers',
              value: true,
              onChanged: (value) {
                // TODO: Toggle messages
              },
            ),
            _SettingsSwitch(
              title: 'Trip Reminders',
              value: true,
              onChanged: (value) {
                // TODO: Toggle reminders
              },
            ),
            _SettingsSwitch(
              title: 'Promotions',
              value: false,
              onChanged: (value) {
                // TODO: Toggle promotions
              },
            ),

            const SizedBox(height: AppSpacing.xl),
            // Appearance section
            _buildSectionHeader(context, 'Appearance'),
            _SettingsItem(
              title: 'Theme',
              trailing: const Text('System'),
              onTap: () {
                _showThemeSelector(context);
              },
            ),

            const SizedBox(height: AppSpacing.xl),
            // Language section
            _buildSectionHeader(context, 'Language'),
            _SettingsItem(
              title: 'Language',
              trailing: const Text('English'),
              onTap: () {
                // TODO: Language selector
              },
            ),

            const SizedBox(height: AppSpacing.xl),
            // About section
            _buildSectionHeader(context, 'About'),
            _SettingsItem(
              title: 'Version',
              trailing: Text(
                '1.0.0',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray500,
                    ),
              ),
              showArrow: false,
            ),
            _SettingsItem(
              title: 'Privacy Policy',
              onTap: () {
                // TODO: Privacy Policy
              },
            ),
            _SettingsItem(
              title: 'Terms of Service',
              onTap: () {
                // TODO: Terms of Service
              },
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // Logout buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showLogoutDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => _showLogoutAllDialog(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      ),
                      child: const Text('Sign Out from All Devices'),
                    ),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.gray500,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Theme',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              _ThemeOption(
                icon: Icons.light_mode_outlined,
                title: 'Light',
                isSelected: false,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _ThemeOption(
                icon: Icons.dark_mode_outlined,
                title: 'Dark',
                isSelected: false,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _ThemeOption(
                icon: Icons.settings_suggest_outlined,
                title: 'System',
                isSelected: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
              // Mock: POST /api/v1/auth/logout
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

  void _showLogoutAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out from All Devices'),
        content: const Text(
          'This will sign you out from all devices where you are currently logged in. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Mock: POST /api/v1/auth/logout-all
              context.go('/onboarding');
            },
            child: Text(
              'Sign Out All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatefulWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<_SettingsSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Switch(
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
              widget.onChanged(value);
            },
            activeTrackColor: AppColors.primary600,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showArrow;

  const _SettingsItem({
    required this.title,
    this.trailing,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              children: [
                if (trailing != null) trailing!,
                if (showArrow && onTap != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.gray400,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary600 : AppColors.gray600,
      ),
      title: Text(title),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: AppColors.primary600,
            )
          : null,
      onTap: onTap,
    );
  }
}
