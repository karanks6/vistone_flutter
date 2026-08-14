import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography System for Vistone AI.
/// Uses Poppins for a clean, rounded, premium aesthetic.
class AppTypography {
  AppTypography._();

  static TextTheme getTheme(Color displayColor, Color bodyColor) {
    return GoogleFonts.poppinsTextTheme().apply(
      displayColor: displayColor,
      bodyColor: bodyColor,
    ).copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: 48, 
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -1.5,
        color: displayColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -1.0,
        color: displayColor,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -1.0,
        color: displayColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.5,
        color: displayColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.2,
        color: displayColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0,
        color: displayColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.1,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.1,
        color: bodyColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.2,
        color: bodyColor,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 16, // Button
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: bodyColor,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: bodyColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: bodyColor,
      ),
    );
  }
}
