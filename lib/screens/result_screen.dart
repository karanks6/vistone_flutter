import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';
import '../widgets/monk_scale_slider.dart';
import '../widgets/color_swatch_card.dart';
import '../widgets/confidence_bar.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final selectedImage = ref.watch(selectedImageProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state is! AnalysisSuccess) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    final result = state.result;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image Header
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Symbols.arrow_back, color: isDark ? Colors.white : Colors.black),
                  onPressed: () => context.go('/home'),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (selectedImage != null)
                    Image.file(selectedImage, fit: BoxFit.cover),
                  
                  // Gradient fade to background
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.6, 1.0],
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor.withValues(alpha: 0.4),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.s16),
                
                // Badges
                Row(
                  children: [
                    _Badge(text: 'Monk ${result.tone}'),
                    const SizedBox(width: AppSpacing.s12),
                    _Badge(text: '${result.undertoneEmoji} ${result.undertone}'),
                  ],
                ),
                const SizedBox(height: AppSpacing.s32),

                // Monk Scale
                MonkScaleSlider(
                  monkColors: result.monkColors,
                  detectedTone: result.tone,
                ),
                const SizedBox(height: AppSpacing.s32),

                // Confidence Scores
                ConfidenceBar(
                  label: 'Tone confidence',
                  value: result.toneConfidence,
                ),
                const SizedBox(height: AppSpacing.s16),
                ConfidenceBar(
                  label: 'Undertone confidence',
                  value: result.utConfidence,
                ),
                
                if (!result.isHighConfidence)
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.s24),
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: AppShapes.card,
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Symbols.warning, color: AppColors.warning, size: 24),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Text(
                            'Try a clearer photo in natural daylight for better accuracy.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: AppSpacing.s48),
                _SectionHeader(title: 'Your Best Colors', icon: Symbols.auto_awesome),
                const SizedBox(height: AppSpacing.s24),
              ]),
            ),
          ),

          // Best Colors Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: AppSpacing.s16,
                mainAxisSpacing: AppSpacing.s16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => ColorSwatchCard(
                  swatch: result.bestColors[i],
                  onTap: () => context.push(
                    '/color-preview',
                    extra: {
                      'swatch': result.bestColors[i],
                      'isAvoid': false,
                      'undertone': result.undertone,
                    },
                  ),
                ),
                childCount: result.bestColors.length,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.s48),
                _SectionHeader(title: 'Colors to Avoid', icon: Symbols.block),
                const SizedBox(height: AppSpacing.s24),
              ]),
            ),
          ),

          // Avoid Colors Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: AppSpacing.s16,
                mainAxisSpacing: AppSpacing.s16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => ColorSwatchCard(
                  swatch: result.avoidColors[i],
                  isAvoid: true,
                  onTap: () => context.push(
                    '/color-preview',
                    extra: {
                      'swatch': result.avoidColors[i],
                      'isAvoid': true,
                      'undertone': result.undertone,
                    },
                  ),
                ),
                childCount: result.avoidColors.length,
              ),
            ),
          ),

          // Bottom Action
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.s32),
                AppButton(
                  icon: Symbols.add_a_photo,
                  label: 'Analyze Another Photo',
                  isExpanded: true,
                  onPressed: () {
                    ref.read(analysisProvider.notifier).reset();
                    context.go('/home');
                  },
                ),
                const SizedBox(height: AppSpacing.s64),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: AppShapes.chip,
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray200,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isDark ? AppColors.gray100 : AppColors.gray900,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.s12),
        Text(
          title,
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
