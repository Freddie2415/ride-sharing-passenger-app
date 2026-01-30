import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.isLoading = false,
    this.isFullWidth = true,
    this.isDisabled = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool isLoading;
  final bool isFullWidth;
  final bool isDisabled;

  double get _height {
    switch (size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return AppSpacing.buttonHeight;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isDisabled || isLoading ? null : onPressed;

    Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : _buildContent(context);

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: _height,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              padding: _padding,
              minimumSize: Size(isFullWidth ? double.infinity : 0, _height),
            ),
            child: child,
          ),
        );

      case AppButtonVariant.secondary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: _height,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            style: OutlinedButton.styleFrom(
              padding: _padding,
              minimumSize: Size(isFullWidth ? double.infinity : 0, _height),
            ),
            child: child,
          ),
        );

      case AppButtonVariant.text:
        return SizedBox(
          height: _height,
          child: TextButton(
            onPressed: effectiveOnPressed,
            style: TextButton.styleFrom(
              padding: _padding,
            ),
            child: child,
          ),
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    if (icon == null) {
      return Text(label);
    }

    final iconWidget = Icon(icon, size: 20);
    final textWidget = Text(label);

    if (iconPosition == IconPosition.left) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: AppSpacing.sm),
          textWidget,
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textWidget,
          const SizedBox(width: AppSpacing.sm),
          iconWidget,
        ],
      );
    }
  }
}

enum IconPosition { left, right }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 48,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
    this.isDisabled = false,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: isDisabled
                  ? AppColors.gray400
                  : iconColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
