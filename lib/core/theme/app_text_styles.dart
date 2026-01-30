import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 64 / 57,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 52 / 45,
  );

  static TextStyle displaySmall = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
  );

  // Headline
  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  // Title
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 28 / 22,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );

  // Label
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
  );

  // Light theme text theme
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.onBackgroundLight),
    displayMedium: displayMedium.copyWith(color: AppColors.onBackgroundLight),
    displaySmall: displaySmall.copyWith(color: AppColors.onBackgroundLight),
    headlineLarge: headlineLarge.copyWith(color: AppColors.onBackgroundLight),
    headlineMedium: headlineMedium.copyWith(color: AppColors.onBackgroundLight),
    headlineSmall: headlineSmall.copyWith(color: AppColors.onBackgroundLight),
    titleLarge: titleLarge.copyWith(color: AppColors.onBackgroundLight),
    titleMedium: titleMedium.copyWith(color: AppColors.onBackgroundLight),
    titleSmall: titleSmall.copyWith(color: AppColors.onBackgroundLight),
    bodyLarge: bodyLarge.copyWith(color: AppColors.onBackgroundLight),
    bodyMedium: bodyMedium.copyWith(color: AppColors.onSurfaceVariantLight),
    bodySmall: bodySmall.copyWith(color: AppColors.onSurfaceVariantLight),
    labelLarge: labelLarge.copyWith(color: AppColors.onBackgroundLight),
    labelMedium: labelMedium.copyWith(color: AppColors.onSurfaceVariantLight),
    labelSmall: labelSmall.copyWith(color: AppColors.onSurfaceVariantLight),
  );

  // Dark theme text theme
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.onBackgroundDark),
    displayMedium: displayMedium.copyWith(color: AppColors.onBackgroundDark),
    displaySmall: displaySmall.copyWith(color: AppColors.onBackgroundDark),
    headlineLarge: headlineLarge.copyWith(color: AppColors.onBackgroundDark),
    headlineMedium: headlineMedium.copyWith(color: AppColors.onBackgroundDark),
    headlineSmall: headlineSmall.copyWith(color: AppColors.onBackgroundDark),
    titleLarge: titleLarge.copyWith(color: AppColors.onBackgroundDark),
    titleMedium: titleMedium.copyWith(color: AppColors.onBackgroundDark),
    titleSmall: titleSmall.copyWith(color: AppColors.onBackgroundDark),
    bodyLarge: bodyLarge.copyWith(color: AppColors.onBackgroundDark),
    bodyMedium: bodyMedium.copyWith(color: AppColors.onSurfaceVariantDark),
    bodySmall: bodySmall.copyWith(color: AppColors.onSurfaceVariantDark),
    labelLarge: labelLarge.copyWith(color: AppColors.onBackgroundDark),
    labelMedium: labelMedium.copyWith(color: AppColors.onSurfaceVariantDark),
    labelSmall: labelSmall.copyWith(color: AppColors.onSurfaceVariantDark),
  );
}
