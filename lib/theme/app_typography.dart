import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 13-tier Typography System for Vistone AI.
/// Uses Playfair Display for headings and Inter for body text.
class AppTypography {
  AppTypography._();

  static TextTheme getTheme(Color displayColor, Color bodyColor) {
    // We use GoogleFonts.inter() to generate the base text theme,
    // and .apply() ensures all fallback styles receive the correct light/dark colors.
    return GoogleFonts.interTextTheme().apply(
      displayColor: displayColor,
      bodyColor: bodyColor,
    ).copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 56, // Display XL
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: displayColor,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 48, // Display Large
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: displayColor,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 34, // Headline
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: displayColor,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 24, // Title
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
        color: displayColor,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 18, // Subtitle
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
        color: displayColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, // Body
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.2,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, // Secondary Body
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.2,
        color: bodyColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, // Caption
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.2,
        color: bodyColor,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14, // Button / Standard Label
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.2,
        color: bodyColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12, // Small Label / Chip
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.2,
        color: bodyColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, // Tiny Label
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.2,
        color: bodyColor,
      ),
    );
  }
}
