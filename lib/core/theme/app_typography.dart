import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme getTheme(Color displayColor, Color bodyColor) {
    final body = GoogleFonts.manropeTextTheme();
    return body.copyWith(
      displayLarge: GoogleFonts.dmSerifDisplay(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        height: 1.01,
        letterSpacing: -1.2,
        color: displayColor,
      ),
      displayMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 38,
        fontWeight: FontWeight.w400,
        height: 1.06,
        letterSpacing: -0.7,
        color: displayColor,
      ),
      displaySmall: GoogleFonts.dmSerifDisplay(
        fontSize: 31,
        fontWeight: FontWeight.w400,
        height: 1.1,
        color: displayColor,
      ),
      headlineMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 27,
        fontWeight: FontWeight.w400,
        height: 1.14,
        color: displayColor,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.35,
        color: displayColor,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.28,
        letterSpacing: -0.2,
        color: displayColor,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: displayColor,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.55,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: bodyColor,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.45,
        color: bodyColor,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.1,
        color: bodyColor,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        color: bodyColor,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.15,
        color: bodyColor,
      ),
    );
  }
}
