import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/color_swatch.dart';

class ColorDatabase {
  Map<String, dynamic>? _db;

  Future<void> load() async {
    if (_db != null) return;
    try {
      final jsonString = await rootBundle.loadString('assets/monk_skin_tone_color_recommendations.json');
      _db = json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Failed to load color recommendations: $e');
      _db = {};
    }
  }

  Map<String, List<ColorSwatch>> getRecommendations(int tone, String undertone) {
    if (_db == null) {
      return {'best': [], 'avoid': []};
    }
    
    final block = _db!['tone_$tone'] as Map<String, dynamic>?;
    if (block == null) return {'best': [], 'avoid': []};

    final ut = undertone.toLowerCase();
    Map<String, dynamic>? data = block[ut] as Map<String, dynamic>?;
    data ??= block['neutral'] as Map<String, dynamic>?;
    data ??= block['default'] as Map<String, dynamic>?;

    if (data == null) return {'best': [], 'avoid': []};

    List<ColorSwatch> best = [];
    if (data['best'] != null) {
      for (var c in (data['best'] as List).take(3)) {
        best.add(ColorSwatch(name: c['name'], hex: c['hex']));
      }
    }

    List<ColorSwatch> avoid = [];
    if (data['avoid'] != null) {
      for (var c in (data['avoid'] as List).take(3)) {
        avoid.add(ColorSwatch(name: c['name'], hex: c['hex']));
      }
    }

    return {'best': best, 'avoid': avoid};
  }
}

// Singleton instance
final colorDatabase = ColorDatabase();
