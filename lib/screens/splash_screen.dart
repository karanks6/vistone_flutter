import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/design_system.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Title
            Text(
              'Vistone AI',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                letterSpacing: -1.0,
              ),
            )
            .animate()
            .slideY(
              begin: 0.2, 
              end: 0, 
              duration: 800.ms, 
              curve: Curves.easeOutBack,
            )
            .fadeIn(duration: 800.ms),

            const SizedBox(height: AppSpacing.md),

            // Subtitle
            Text(
              'Personalized color analysis powered by AI.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .slideY(
              begin: 0.2, 
              end: 0, 
              duration: 800.ms, 
              curve: Curves.easeOutBack,
              delay: 200.ms
            )
            .fadeIn(duration: 800.ms, delay: 200.ms),

            const SizedBox(height: AppSpacing.xxxl),

            // 5 Color Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(const Color(0xFFFFB5E8), 0),
                const SizedBox(width: 8),
                _buildDot(const Color(0xFFB28DFF), 1),
                const SizedBox(width: 8),
                _buildDot(const Color(0xFF7B52AB), 2),
                const SizedBox(width: 8),
                _buildDot(isDark ? Colors.white : AppColors.textPrimary, 3),
                const SizedBox(width: 8),
                _buildDot(isDark ? AppColors.surfaceDark : Colors.white, 4, true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color, int index, [bool hasBorder = false]) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: hasBorder ? Border.all(color: AppColors.borderDefault, width: 2) : null,
      ),
    )
    .animate()
    .scale(
      begin: const Offset(0, 0),
      duration: 500.ms,
      curve: Curves.easeOutBack,
      delay: (400 + index * 100).ms,
    )
    .fadeIn(duration: 500.ms, delay: (400 + index * 100).ms);
  }
}
