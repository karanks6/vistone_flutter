import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme getTheme(Color displayColor, Color bodyColor) {
    return GoogleFonts.plusJakartaSansTextTheme().apply(
      displayColor: displayColor,
      bodyColor: bodyColor,
    ).copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.4,
        color: displayColor,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.8,
        color: displayColor,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 24, // Screen Title
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: displayColor,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20, // Section Heading
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: displayColor,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 16, // Card Title
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: displayColor,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: bodyColor,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12, // Caption
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: bodyColor,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11, // Label / Eyebrow
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: bodyColor,
      ),
    );
  }
}
