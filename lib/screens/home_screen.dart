import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../providers/analysis_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/design_system.dart';
import '../widgets/upload_zone.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _tips = [
    (Symbols.light_mode, 'Natural Light', 'Step near a window for best accuracy.'),
    (Symbols.face, 'Face the Camera', 'Look directly at the lens.'),
    (Symbols.filter_b_and_w, 'No Filters', 'Remove beauty or color filters.'),
    (Symbols.water_drop, 'Clean Skin', 'Remove heavy makeup for best results.'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
              title: Text(
                'Vistone AI',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: Icon(isDark ? Symbols.light_mode : Symbols.dark_mode),
                  onPressed: () {
                    ref.read(themeProvider.notifier).setMode(isDark ? ThemeMode.light : ThemeMode.dark);
                  },
                  tooltip: 'Toggle Theme',
                ),
                IconButton(
                  icon: const Icon(Symbols.info),
                  onPressed: () => context.push('/about'),
                  tooltip: 'About Vistone AI',
                ),
                const SizedBox(width: AppSpacing.s8),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    'Discover your\ntrue colors.',
                    style: theme.textTheme.displayMedium,
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    'Upload a selfie to find the perfect color palette that complements your natural skin tone.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.gray400 : AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s40),
                  
                  // Main Upload Zone
                  UploadZone(
                    onImagePicked: (file) => _startAnalysis(context, ref, file),
                  ),
                  
                  const SizedBox(height: AppSpacing.s48),
                  
                  Text(
                    'TIPS FOR BEST RESULTS',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark ? AppColors.gray500 : AppColors.gray400,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  
                  SizedBox(
                    height: 144,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: _tips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s16),
                      itemBuilder: (_, i) => _TipCard(
                        icon: _tips[i].$1,
                        title: _tips[i].$2,
                        body: _tips[i].$3,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.s40),
                  const _HowItWorks(),
                  const SizedBox(height: AppSpacing.s40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startAnalysis(BuildContext context, WidgetRef ref, File file) async {
    ref.read(selectedImageProvider.notifier).state = file;
    ref.read(analysisProvider.notifier).reset();
    context.push('/analyzing');
    await ref.read(analysisProvider.notifier).analyze(file);
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: AppShapes.card,
        border: theme.cardTheme.shape is RoundedRectangleBorder
            ? Border.fromBorderSide((theme.cardTheme.shape as RoundedRectangleBorder).side)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.s12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          'How does it work?',
          style: theme.textTheme.titleMedium,
        ),
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: AppSpacing.s16),
        iconColor: theme.colorScheme.primary,
        collapsedIconColor: theme.textTheme.bodyMedium?.color,
        children: [
          Text(
            'Vistone AI uses on-device facial geometry mapping to sample precise skin areas from your cheeks, forehead, and nose, avoiding shadows and highlights. It calculates a color-calibrated baseline to map your unique skin tone and undertone to a curated Seasonal Color Analysis palette.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
