import 'package:flutter/material.dart';

/// Semantic color roles for the Vistone visual language.
///
/// The palette is deliberately quiet: botanical green communicates trust and
/// precision, while clay is reserved for moments that ask the user to act.
class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF1C2925);
  static const Color inkSoft = Color(0xFF34433E);
  static const Color forest = Color(0xFF24564D);
  static const Color forestDeep = Color(0xFF153D36);
  static const Color sage = Color(0xFFB8CBB6);
  static const Color sageSoft = Color(0xFFE4EEE0);
  static const Color clay = Color(0xFFD66B4D);
  static const Color claySoft = Color(0xFFF9DED4);
  static const Color marigold = Color(0xFFF2C56D);
  static const Color lilac = Color(0xFFD7D0EB);

  static const Color canvas = Color(0xFFF7F5F0);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color surfaceMuted = Color(0xFFF0EEE7);
  static const Color surfaceSage = Color(0xFFEAF1E7);
  static const Color surfaceClay = Color(0xFFFCF0EB);
  static const Color line = Color(0xFFE4E1D9);
  static const Color lineStrong = Color(0xFFCFCBC2);

  static const Color textPrimary = ink;
  static const Color textSecondary = Color(0xFF66736E);
  static const Color textTertiary = Color(0xFF89918D);
  static const Color textDisabled = Color(0xFFADB3B0);
  static const Color textInverse = Color(0xFFFFFEFA);

  static const Color success = Color(0xFF438266);
  static const Color successSoft = Color(0xFFE5F2E9);
  static const Color warning = Color(0xFFB67A25);
  static const Color warningSoft = Color(0xFFFFF1D6);
  static const Color error = Color(0xFFB54E4E);
  static const Color errorSoft = Color(0xFFFBE9E7);

  static const Color night = Color(0xFF101A17);
  static const Color nightSurface = Color(0xFF182522);
  static const Color nightSurfaceRaised = Color(0xFF23312D);
  static const Color nightLine = Color(0xFF34443E);
  static const Color nightText = Color(0xFFF2F1EA);
  static const Color nightMuted = Color(0xFFB4BDB6);

  // Compatibility aliases keep lower-level widgets concise.
  static const Color primary = forest;
  static const Color primaryAlt = forestDeep;
  static const Color primaryLight = sage;
  static const Color deepInk = ink;
  static const Color bgLight = canvas;
  static const Color surfaceWarm = surface;
  static const Color surfaceLight = surface;
  static const Color surfaceLavender = surfaceSage;
  static const Color lavenderTint = sageSoft;
  static const Color peach = claySoft;
  static const Color softRose = claySoft;
  static const Color mint = sage;
  static const Color softGreen = success;
  static const Color blue = lilac;
  static const Color softSky = Color(0xFFE5F0EE);
  static const Color info = forest;
  static const Color infoSoft = surfaceSage;
  static const Color borderDefault = line;
  static const Color borderHighlight = sage;
  static const Color borderActive = forest;
  static const Color bgDark = night;
  static const Color surfaceDark = nightSurface;
  static const Color cardDark = nightSurfaceRaised;
  static const Color textPrimaryDark = nightText;
  static const Color textSecondaryDark = nightMuted;
  static const Color primaryDark = sage;
  static const Color sageGreen = sage;
}
