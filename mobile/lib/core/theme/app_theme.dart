import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surfaceContainerLowest,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 40 / 32,
          color: AppColors.textPrimary,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 32 / 24,
          color: AppColors.textPrimary,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 28 / 20,
          color: AppColors.textPrimary,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 24 / 18,
          color: AppColors.textPrimary,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 16 / 12,
          color: AppColors.textMuted,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 20 / 14,
          color: AppColors.textPrimary,
        ),
        labelMedium: baseTextTheme.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 16 / 12,
          color: AppColors.textSecondary,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 12 / 10,
          color: AppColors.textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
      ),
      // Level 1 Elevation Card resting on subtle ambient shadow
      cardTheme: CardTheme(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // rounded-lg
          side: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      // Primary Action Button: 48px height, #0F52BA, 12px radius (rounded-md)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Secondary / Outlined Button: 1.5px border #E2E8F0, text #0F52BA
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.divider, width: 1.5),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Input field: 48px, background #F8FAFC, 1px border #E2E8F0, 8px radius
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // rounded
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      ),
      // Bottom Navigation Bar: height 64px, pure white surface #FFFFFF, 1px top border
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent, // Clean design per DESIGN.md (no oversized M3 bubble)
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              size: 24,
              color: AppColors.primary,
            );
          }
          return const IconThemeData(
            size: 24,
            color: AppColors.textMuted,
          );
        }),
      ),
    );
  }
}
