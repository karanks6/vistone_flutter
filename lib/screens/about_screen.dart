import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/design_system.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceAltDark : AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Symbols.chevron_left, size: 20, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'About Vistone AI',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                child: Column(
                  children: [
                    // Hero
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.s32),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9070D9), // Dark Purple
                            Color(0xFFB19CD9), // Light Purple
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9070D9).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Symbols.auto_awesome, color: Colors.white, size: 32),
                          ),
                          const SizedBox(height: AppSpacing.s24),
                          Text(
                            'Vistone AI',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            'See the colors that bring out your best.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, duration: 600.ms, curve: Curves.easeOutCubic),

                    const SizedBox(height: AppSpacing.s32),

                    _InfoCard(
                      icon: Symbols.target,
                      title: 'What is Vistone AI?',
                      body:
                          'Vistone AI is an AI-powered personal color analysis tool. It uses advanced computer vision to analyze your skin tone from a selfie and recommend clothing colors that scientifically complement your complexion.',
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.s16),

                    _InfoCard(
                      icon: Symbols.science,
                      title: 'The Google Monk Scale',
                      body:
                          'Vistone AI classifies skin tones using the Google Monk Skin Tone Scale — a 10-shade scale developed to provide broader, more inclusive skin tone representation.',
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.s16),

                    _InfoCard(
                      icon: Symbols.robot_2,
                      title: 'How the AI Works',
                      body:
                          'MediaPipe Face Mesh detects facial landmarks. The algorithm samples skin pixels from your upper cheeks, forehead, and nose. Two color correction steps normalize the lighting before classification.',
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.s16),

                    _InfoCard(
                      icon: Symbols.palette,
                      title: 'Seasonal Color Analysis',
                      body:
                          'Your Monk tone and undertone (Cool/Warm/Neutral) are mapped to one of 12 seasonal archetypes to generate your personal palette.',
                    ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.s40),

                    // Try It Now Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9070D9), // Dark Purple
                            Color(0xFFB19CD9), // Light Purple
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9070D9).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () => context.go('/home'),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Symbols.camera, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Try It Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

                    const SizedBox(height: AppSpacing.s64),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceAltDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
