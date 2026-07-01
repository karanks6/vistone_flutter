import 'color_swatch.dart';

class AnalysisResult {
  final int tone;
  final String undertone;
  final double toneConfidence;
  final double utConfidence;
  final List<ColorSwatch> bestColors;
  final List<ColorSwatch> avoidColors;
  final List<String> monkColors;

  const AnalysisResult({
    required this.tone,
    required this.undertone,
    required this.toneConfidence,
    required this.utConfidence,
    required this.bestColors,
    required this.avoidColors,
    required this.monkColors,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      tone: (json['tone'] as num?)?.toInt() ?? 5,
      undertone: json['undertone'] as String? ?? 'Neutral',
      toneConfidence: (json['tone_confidence'] as num?)?.toDouble() ?? 0.0,
      utConfidence: (json['ut_confidence'] as num?)?.toDouble() ?? 0.0,
      bestColors: (json['best_colors'] as List<dynamic>?)
              ?.map((e) => ColorSwatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      avoidColors: (json['avoid_colors'] as List<dynamic>?)
              ?.map((e) => ColorSwatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monkColors: (json['monk_colors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  String get undertoneEmoji {
    switch (undertone) {
      case 'Warm':
        return '🔥';
      case 'Cool':
        return '❄️';
      default:
        return '🌿';
    }
  }

  bool get isHighConfidence => toneConfidence >= 0.80;
  bool get isMediumConfidence => toneConfidence >= 0.45 && toneConfidence < 0.80;
}
