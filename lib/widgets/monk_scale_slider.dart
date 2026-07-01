import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MonkScaleSlider extends StatelessWidget {
  final List<String> monkColors;
  final int detectedTone;

  const MonkScaleSlider({
    super.key,
    required this.monkColors,
    required this.detectedTone,
  });

  Color _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: VistoneColors.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONK SCALE',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(monkColors.length, (i) {
              final toneNumber = i + 1;
              final isSelected = toneNumber == detectedTone;
              final color = _parseHex(monkColors[i]);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.elasticOut,
                        height: isSelected ? 64 : 48,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: VistoneColors.success
                                        .withValues(alpha: 0.6),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                          border: isSelected
                              ? Border.all(
                                  color: VistoneColors.success, width: 2.5)
                              : Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isSelected ? 1.0 : 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '$toneNumber',
                            style: const TextStyle(
                              color: VistoneColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
