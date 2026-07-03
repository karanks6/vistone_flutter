import 'package:flutter/material.dart';

/// The core color system for Vistone.
/// Follows a premium, modern design language.
class AppColors {
  AppColors._();

  // ── Brand Colors ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF172B4D); // Deep Navy
  static const Color secondary = Color(0xFF526D82); // Slate Blue
  static const Color accent = Color(0xFFFF7A59); // Warm Coral

  // ── Semantic Colors ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ── Neutral Palette ───────────────────────────────────────────────────────
  static const Color gray25 = Color(0xFFFCFCFC);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF7F7F7);
  static const Color gray150 = Color(0xFFF2F2F2);
  static const Color gray200 = Color(0xFFEBEBEB);
  static const Color gray300 = Color(0xFFDDDDDD);
  static const Color gray400 = Color(0xFFC4C4C4);
  static const Color gray500 = Color(0xFF9A9A9A);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF4A4A4A);
  static const Color gray800 = Color(0xFF2C2C2C);
  static const Color gray900 = Color(0xFF111111);

  // ── Light Theme Backgrounds ───────────────────────────────────────────────
  static const Color bgLight = gray25;
  static const Color surfaceLight = gray25; 
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color searchBarLight = gray100;

  // ── Elevation Colors ──────────────────────────────────────────────────────
  static const Color elevation1 = Color(0xFFFFFFFF);
  static const Color elevation2 = Color(0xFFFCFCFC);
  static const Color elevation3 = Color(0xFFF7F7F7);

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
