import 'package:flutter/material.dart';

/// The core color system for Vistone.
/// Follows a premium, modern design language.
class AppColors {
  AppColors._();

  // ── Brand Colors & Palette ────────────────────────────────────────────────
  static const Color primary = Color(0xFF1F2A1F); // Dark Green (Primary Text/Brand)
  static const Color secondary = Color(0xFF5E655E); // Warm Grey
  static const Color accent = Color(0xFFE76F51); // Terracotta
  
  static const Color sageGreen = Color(0xFF7A946F);
  static const Color oliveGreen = Color(0xFFA7C555);
  static const Color goldenYellow = Color(0xFFEBC46A);

  // ── Semantic Colors ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF4F7A5A); // Sage Green Semantic
  static const Color error = Color(0xFFD65A44); // Soft Red
  static const Color warning = Color(0xFFE0A23C); // Amber
  static const Color info = Color(0xFF5B7B8C); // Muted Blue

  // ── Neutral Palette (Border/Dividers) ────────────────────────────────────
  static const Color border = Color(0xFFE2D6C6); // Sandstone
  
  // Note: Keeping generic grays for compatibility but shifting them slightly warm
  static const Color gray25 = Color(0xFFFCFCF9);
  static const Color gray50 = Color(0xFFFAFAF5);
  static const Color gray100 = Color(0xFFF7F7F0);
  static const Color gray150 = Color(0xFFF2F2E8);
  static const Color gray200 = Color(0xFFEBEBE0);
  static const Color gray300 = Color(0xFFDDDDD0);
  static const Color gray400 = Color(0xFFC4C4B5);
  static const Color gray500 = Color(0xFF9A9A8B);
  static const Color gray600 = Color(0xFF757566);
  static const Color gray700 = Color(0xFF4A4A3C);
  static const Color gray800 = Color(0xFF2C2C22);
  static const Color gray900 = Color(0xFF11110B);

  // ── Light Theme Backgrounds ───────────────────────────────────────────────
  static const Color bgLight = Color(0xFFF3ECE3); // Warm Sand
  static const Color surfaceLight = Color(0xFFFAF6F0); // Cream White
  static const Color cardLight = Color(0xFFFAF6F0); // Cream White
  static const Color dialogLight = Color(0xFFFAF6F0); // Cream White
  static const Color searchBarLight = Color(0xFFFAF6F0); // Using Cream White for elevated
  
  // ── Elevation Colors ──────────────────────────────────────────────────────
  static const Color elevation1 = Color(0xFFFAF6F0);
  static const Color elevation2 = Color(0xFFEFE6DB); // Light Oat
  static const Color elevation3 = Color(0xFFE2D6C6); // Sandstone

  // ── Dark Theme Colors ─────────────────────────────────────────────────────
  static const Color bgDark = Color(0xFF0E1116);
  static const Color surfaceDark = Color(0xFF181C24);
  static const Color cardDark = Color(0xFF202632);
  static const Color dialogDark = Color(0xFF202632);
  
  static const Color primaryDark = Color(0xFF7CA9FF);
  static const Color accentDark = Color(0xFFFF9A7A);

  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFC4C8CE);
}
