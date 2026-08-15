import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radii.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final text = AppTypography.getTheme(
      isDark ? AppColors.nightText : AppColors.ink,
      isDark ? AppColors.nightMuted : AppColors.textSecondary,
    );
    final surface = isDark ? AppColors.nightSurface : AppColors.surface;
    final outline = isDark ? AppColors.nightLine : AppColors.line;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? AppColors.night : AppColors.canvas,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: isDark ? AppColors.sage : AppColors.forest,
        onPrimary: isDark ? AppColors.ink : AppColors.textInverse,
        secondary: AppColors.clay,
        onSecondary: AppColors.textInverse,
        error: AppColors.error,
        onError: AppColors.textInverse,
        surface: surface,
        onSurface: isDark ? AppColors.nightText : AppColors.ink,
      ),
      textTheme: text,
      dividerColor: outline,
      splashFactory: InkSparkle.splashFactory,
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: BorderSide(color: outline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.nightSurfaceRaised : AppColors.ink,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.textInverse),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.sheet)),
      ),
    );
  }
}
