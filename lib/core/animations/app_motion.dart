import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  static const Duration micro = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration reveal = Duration(milliseconds: 650);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOutCubic;
}
