import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF5A4E8A).withValues(alpha: 0.06),
          blurRadius: 18,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get raisedAction => [
        BoxShadow(
          color: const Color(0xFF6D4AFF).withValues(alpha: 0.18),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}
