import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// The central theme definition for Vistone.
/// Material 3 enabled, minimalist, and premium.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.bgLight,
      error: AppColors.error,
    );

    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBg: AppColors.bgLight,
      cardBg: AppColors.cardLight,
      dialogBg: AppColors.dialogLight,
      textColor: AppColors.gray900,
      textColorSecondary: AppColors.gray700,
    );
  }

  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    );

    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBg: AppColors.bgDark,
      cardBg: AppColors.cardDark,
      dialogBg: AppColors.dialogDark,
      textColor: AppColors.textPrimaryDark,
      textColorSecondary: AppColors.textSecondaryDark,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBg,
    required Color cardBg,
    required Color dialogBg,
    required Color textColor,
    required Color textColorSecondary,
  }) {
    final textTheme = AppTypography.getTheme(textColor, textColorSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: colorScheme,
      textTheme: textTheme,
      
      // ── Page Transitions ────────────────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // ── AppBar ──────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
        ),
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: textTheme.titleLarge,
      ),

      // ── Card ────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.card,
          side: BorderSide(
            color: brightness == Brightness.light ? AppColors.border : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),

      // ── Dialog ──────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.dialog),
        elevation: 0, // Using manual shadows for dialogs usually, but keeping this 0 for standard
      ),

      // ── Input Decoration ────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light ? AppColors.gray50 : AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
        border: OutlineInputBorder(
          borderRadius: AppShapes.textField,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.textField,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.textField,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.textField,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: textColorSecondary),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.gray400),
      ),

      // ── Divider ─────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: brightness == Brightness.light ? AppColors.border : Colors.white.withValues(alpha: 0.1),
        space: 1,
        thickness: 1,
      ),

      // ── Buttons (Base Styling) ──────────────────────────────────────────────
      // Note: We use custom AppButton for advanced states, but define base styles here
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent, // Terracotta for CTAs
          foregroundColor: Colors.white, // Always white on Terracotta
          shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
          padding: AppSpacing.buttonPadding,
          elevation: 0, // Elevations are managed explicitly
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
          padding: AppSpacing.buttonPadding,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: brightness == Brightness.light ? AppColors.gray300 : AppColors.gray700),
          shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
          padding: AppSpacing.buttonPadding,
          textStyle: textTheme.labelLarge,
        ),
      ),
      
      // ── SnackBar ────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.light ? AppColors.gray900 : AppColors.gray100,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: brightness == Brightness.light ? Colors.white : AppColors.gray900,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.s8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
