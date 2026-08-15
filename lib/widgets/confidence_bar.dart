import 'package:flutter/material.dart';
import 'design_system.dart';

class ConfidenceBar extends StatelessWidget {
  final String label;
  final double value;

  const ConfidenceBar({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final percentage = (value.clamp(0, 1) * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text('$percentage%', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.forest)),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value.clamp(0, 1)),
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeOutCubic,
          builder: (context, progress, _) => ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress,
              backgroundColor: AppColors.sageSoft,
              color: AppColors.forest,
            ),
          ),
        ),
      ],
    );
  }
}
