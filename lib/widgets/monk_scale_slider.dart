import 'package:flutter/material.dart';
import 'design_system.dart';

class MonkScaleSlider extends StatelessWidget {
  final List<String> monkColors;
  final int detectedTone;

  const MonkScaleSlider({
    super.key,
    required this.monkColors,
    required this.detectedTone,
  });

  Color _parseHex(String value) {
    final cleaned = value.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: dark ? AppColors.nightLine : AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MONK SKIN TONE SCALE', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(monkColors.length, (index) {
              final tone = index + 1;
              final selected = tone == detectedTone;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: AppMotion.normal,
                        curve: AppMotion.standard,
                        height: selected ? 48 : 31,
                        decoration: BoxDecoration(
                          color: _parseHex(monkColors[index]),
                          borderRadius: BorderRadius.circular(99),
                          border: selected ? Border.all(color: AppColors.clay, width: 2) : null,
                        ),
                      ),
                      const SizedBox(height: 7),
                      AnimatedOpacity(
                        duration: AppMotion.fast,
                        opacity: selected ? 1 : .45,
                        child: Text('$tone', style: Theme.of(context).textTheme.labelSmall),
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
