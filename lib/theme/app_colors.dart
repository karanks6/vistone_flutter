import 'package:flutter/material.dart';

/// The core color system for Vistone.
/// Image-Based UI Redesign (Soft Pastel)
class AppColors {
  AppColors._();

  // ── Primary Brand Colors ───────────────────────────────────────────────────
  static const Color primary = Color(0xFF8B5CF6); // Soft Purple (Violet 500)
  static const Color secondary = Color(0xFFFDBA74); // Soft Peach/Orange
  static const Color accent = Color(0xFFF472B6); // Soft Pink
  
  // ── Light Mode (Clean & Bright) ────────────────────────────────────────────
  static const Color bgLight = Color(0xFFFAF9FF); // Off-white with faint purple tint
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White panels
  static const Color surfaceAltLight = Color(0xFFF3E8FF); // Very light purple for cards
  
  static const Color textPrimaryLight = Color(0xFF151034); // Very Dark Navy (for "Vistone")
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate Gray
  
  static const Color borderLight = Color(0xFFE2E8F0); // Light gray border
  static const Color borderPurple = Color(0xFFC4B5FD); // Dashed border purple
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ── Dark Mode ──────────────────────────────────────────────────────────────
  static const Color primaryDark = Color(0xFFA78BFA); // Violet 400
  static const Color secondaryDark = Color(0xFFFDBA74);
  static const Color accentDark = Color(0xFFF472B6);
  
  static const Color bgDark = Color(0xFF0F172A); // Navy Black
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceAltDark = Color(0xFF334155);
  
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  static const Color borderDark = Color(0xFF334155);
  
  // Legacy mappings for safe compilation
  static const Color cardLight = surfaceLight;
  static const Color dialogLight = surfaceLight;
  static const Color cardDark = surfaceDark;
  static const Color dialogDark = surfaceDark;
  static const Color border = borderLight;
  
  // Neutral Palette mapping for compatibility
  static const Color gray50 = surfaceLight;
  static const Color gray100 = Color(0xFFF8FAFC); // Lighter gray for How It Works container
  static const Color gray200 = borderLight;
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = textSecondaryLight;
  static const Color gray500 = Color(0xFF475569);
  static const Color gray600 = Color(0xFF334155);
  static const Color gray700 = borderDark;
  static const Color gray800 = surfaceDark;
  static const Color gray900 = bgDark;
  
  static const Color sageGreen = success; // Map legacy sageGreen to success
}
