import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/design_system.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderDefault, width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(LucideIcons.chevronLeft, size: 20, color: AppColors.textPrimary),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'About Vistone AI',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xxxl),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9070D9), // Dark Purple
                            Color(0xFFB19CD9), // Light Purple
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadii.hero),
                        boxShadow: AppShadows.card,
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
                            child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 32),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          Text(
                            'Vistone AI',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'See the colors that bring out your best.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: AppMotion.normal).slideY(begin: 0.1),

                    const SizedBox(height: AppSpacing.section),

                    _InfoCard(
                      icon: LucideIcons.target,
                      title: 'What is Vistone AI?',
                      body: 'Vistone AI is an AI-powered personal color analysis tool. It uses advanced computer vision to analyze your skin tone from a selfie and recommend clothing colors that scientifically complement your complexion.',
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.lg),

                    _InfoCard(
                      icon: LucideIcons.microscope,
                      title: 'The Google Monk Scale',
                      body: 'Vistone AI classifies skin tones using the Google Monk Skin Tone Scale — a 10-shade scale developed to provide broader, more inclusive skin tone representation.',
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.lg),

                    _InfoCard(
                      icon: LucideIcons.cpu,
                      title: 'How the AI Works',
                      body: 'MediaPipe Face Mesh detects facial landmarks. The algorithm samples skin pixels from your upper cheeks, forehead, and nose. Two color correction steps normalize the lighting before classification.',
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.lg),

                    _InfoCard(
                      icon: LucideIcons.palette,
                      title: 'Seasonal Color Analysis',
                      body: 'Your Monk tone and undertone (Cool/Warm/Neutral) are mapped to one of 12 seasonal archetypes to generate your personal palette.',
                    ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

                    const SizedBox(height: AppSpacing.section),

                    AppPrimaryButton(
                      label: 'Try It Now',
                      icon: LucideIcons.camera,
                      onPressed: () => context.go('/home'),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

                    const SizedBox(height: 64),
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

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconContainer(
                icon: icon,
                backgroundColor: AppColors.lavenderTint,
                iconColor: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
