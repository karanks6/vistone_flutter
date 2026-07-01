import 'package:flutter/material.dart';

// ── Brand Color Palette ─────────────────────────────────────────────────────
class VistoneColors {
  VistoneColors._();

  static const Color brand1 = Color(0xFF8B5CF6);
  static const Color brand2 = Color(0xFFEC4899);
  static const Color brand3 = Color(0xFF6366F1);

  static const Color bgDark = Color(0xFF0D0A1A);
  static const Color bgCard = Color(0xFF1A1428);
  static const Color surface = Color(0xFF231D36);
  static const Color surfaceLight = Color(0xFF2D2545);

  static const Color textPrimary = Color(0xFFF1EEF8);
  static const Color textSecondary = Color(0xFFB0A8C8);
  static const Color textMuted = Color(0xFF7B6FA0);

  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [brand1, brand2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0D0A1A), Color(0xFF1A0D2E), Color(0xFF0A0D1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration get glassMorphism => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      );
}

// ── App Theme ────────────────────────────────────────────────────────────────
class VistoneTheme {
  VistoneTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: VistoneColors.bgDark,
        colorScheme: const ColorScheme.dark(
          primary: VistoneColors.brand1,
          secondary: VistoneColors.brand2,
          surface: VistoneColors.bgCard,
          error: VistoneColors.error,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: VistoneColors.textPrimary,
            letterSpacing: -1.0,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: VistoneColors.textPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: VistoneColors.textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: VistoneColors.textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: VistoneColors.textSecondary,
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: VistoneColors.textSecondary,
            height: 1.5,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: VistoneColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: VistoneColors.textPrimary,
          ),
          iconTheme: IconThemeData(color: VistoneColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          color: VistoneColors.bgCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: VistoneColors.brand1,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
