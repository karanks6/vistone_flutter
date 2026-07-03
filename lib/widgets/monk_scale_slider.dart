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

  Color _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppShapes.card,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.gray200,
          width: 1,
        ),
        boxShadow: AppElevations.level1(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONK SCALE',
            style: theme.textTheme.labelMedium?.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray500,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
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
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                        height: isSelected ? 64 : 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(100),
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 2)
                              : Border.all(
                                  color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.gray200,
                                  width: 1,
                                ),
                          boxShadow: isSelected ? AppElevations.level2(isDark) : null,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isSelected ? 1.0 : 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.s8),
                          child: Text(
                            '$toneNumber',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
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
