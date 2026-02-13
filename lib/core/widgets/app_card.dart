import 'package:flutter/material.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.shadowColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      child: child,
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSpacing.radiusMd,
          ),
          child: cardContent,
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardTheme.color,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusMd,
        ),
        border: isDark || borderColor != null
            ? Border.all(color: borderColor ?? AppColors.outlineDark)
            : null,
        boxShadow: !isDark && elevation != 0
            ? [
                BoxShadow(
                  color: shadowColor ?? Colors.black.withValues(alpha: 0.08),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: shadowColor ?? Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusMd,
        ),
        child: cardContent,
      ),
    );
  }
}
