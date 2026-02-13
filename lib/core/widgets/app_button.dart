import 'package:flutter/material.dart';

import 'package:passenger/core/constants/app_spacing.dart';

enum AppButtonVariant { primary, secondary, text }

enum AppButtonSize { small, medium, large }

enum IconPosition { left, right }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.label,
    super.key,
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

    final child = isLoading
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
        : _AppButtonContent(
            label: label,
            icon: icon,
            iconPosition: iconPosition,
          );

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
            style: TextButton.styleFrom(padding: _padding),
            child: child,
          ),
        );
    }
  }
}

class _AppButtonContent extends StatelessWidget {
  const _AppButtonContent({
    required this.label,
    this.icon,
    this.iconPosition = IconPosition.left,
  });

  final String label;
  final IconData? icon;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final iconData = icon;
    if (iconData == null) return Text(label);

    final iconWidget = Icon(iconData, size: 20);
    final textWidget = Text(label);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == IconPosition.left
          ? [iconWidget, const SizedBox(width: AppSpacing.sm), textWidget]
          : [textWidget, const SizedBox(width: AppSpacing.sm), iconWidget],
    );
  }
}
