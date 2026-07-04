import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../widgets/design_system.dart';
import '../widgets/botanical_background.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
              leading: IconButton(
                icon: const Icon(Symbols.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: const Text('About'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Hero
                  ClipRRect(
                    borderRadius: AppShapes.card,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.gray800 : const Color(0xFFE9EDDF), // Pale sage green card
                      ),
                      child: BotanicalBackground(
                        opacity: isDark ? 0.05 : 0.4,
                        showBottomLeft: false,
                        showTopRight: true,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vistone AI',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s12),
                              Text(
                                'See the colors that\nbring out your best.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isDark ? AppColors.gray400 : AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s32),

                  _InfoCard(
                    icon: Symbols.target,
                    title: 'What is Vistone AI?',
                    body:
                        'Vistone AI is an AI-powered personal color analysis tool. It uses advanced computer vision to analyze your skin tone from a selfie and recommend clothing colors that scientifically complement your complexion — the same analysis used by professional stylists.',
                  ),

                  const SizedBox(height: AppSpacing.s16),

                  _InfoCard(
                    icon: Symbols.science,
                    title: 'The Google Monk Scale',
                    body:
                        'Vistone AI classifies skin tones using the Google Monk Skin Tone Scale — a 10-shade scale developed by Ellis et al. (2022) to provide broader, more inclusive skin tone representation than older scales like Fitzpatrick.',
                  ),

                  const SizedBox(height: AppSpacing.s16),

                  _InfoCard(
                    icon: Symbols.robot_2,
                    title: 'How the AI Works',
                    body:
                        'MediaPipe Face Mesh detects 468 facial landmarks. The algorithm samples skin pixels from your upper cheeks, forehead, and nose — explicitly excluding eyes, eyebrows, and facial hair. Two color correction steps normalize the lighting before classification.',
                  ),

                  const SizedBox(height: AppSpacing.s16),

                  _InfoCard(
                    icon: Symbols.palette,
                    title: 'Seasonal Color Analysis',
                    body:
                        'Color recommendations are based on Seasonal Color Analysis (SCA), a professional framework used by image consultants. Your Monk tone and undertone (Cool/Warm/Neutral) are mapped to one of 12 seasonal archetypes to generate your palette.',
                  ),

                  const SizedBox(height: AppSpacing.s48),

                  AppButton(
                    label: 'Try It Now',
                    icon: Symbols.camera,
                    isExpanded: true,
                    onPressed: () => context.go('/home'),
                  ),

                  const SizedBox(height: AppSpacing.s64),
                ]),
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
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppShapes.card,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
