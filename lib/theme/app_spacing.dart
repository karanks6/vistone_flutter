import 'package:flutter/material.dart';

/// The core spacing and shape system for Vistone.
/// Uses an 8dp grid system.
class AppSpacing {
  AppSpacing._();

  // ── Spacing Scale (8dp Grid) ──────────────────────────────────────────────
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s56 = 56.0;
  static const double s64 = 64.0;
  static const double s80 = 80.0;
  static const double s96 = 96.0;
  static const double s120 = 120.0;

  // ── Standard Paddings ─────────────────────────────────────────────────────
  static const EdgeInsets pagePadding = EdgeInsets.all(s24);
  static const EdgeInsets pagePaddingDesktop = EdgeInsets.all(s40);
  static const EdgeInsets cardPadding = EdgeInsets.all(s24);
  static const EdgeInsets dialogPadding = EdgeInsets.all(s24);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: s20, vertical: 14.0);

  // ── Breakpoints ───────────────────────────────────────────────────────────
  static const double phoneMax = 599.0;
  static const double tabletMax = 1023.0;
  static const double desktopMin = 1024.0;
  static const double largeDesktopMin = 1440.0;
  static const double maxContentWidth = 1280.0;
}

class AppShapes {
  AppShapes._();

  // ── Border Radii ──────────────────────────────────────────────────────────
  static const double radiusButton = 16.0;
  static const double radiusTextField = 16.0;
  static const double radiusCard = 24.0;
  static const double radiusDialog = 28.0;
  static const double radiusSearchBar = 18.0;
  static const double radiusBottomSheet = 32.0;
  static const double radiusImage = 20.0;
  static const double radiusColorPalette = 18.0;
  static const double radiusChip = 50.0;

  static BorderRadius get button => BorderRadius.circular(radiusButton);
  static BorderRadius get textField => BorderRadius.circular(radiusTextField);
  static BorderRadius get card => BorderRadius.circular(radiusCard);
  static BorderRadius get dialog => BorderRadius.circular(radiusDialog);
  static BorderRadius get searchBar => BorderRadius.circular(radiusSearchBar);
  static BorderRadius get image => BorderRadius.circular(radiusImage);
  static BorderRadius get colorPalette => BorderRadius.circular(radiusColorPalette);
  static BorderRadius get chip => BorderRadius.circular(radiusChip);
  
  static BorderRadius get bottomSheet => const BorderRadius.vertical(
        top: Radius.circular(radiusBottomSheet),
      );
}

class AppElevations {
  AppElevations._();

  // ── Shadows ───────────────────────────────────────────────────────────────
  static List<BoxShadow> level1(bool isDark) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> level2(bool isDark) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.50 : 0.10),
          blurRadius: 48,
          offset: const Offset(0, 16),
        ),
      ];

  static List<BoxShadow> level3(bool isDark) => level2(isDark); // Map level 3 to level 2 for consistency
}
