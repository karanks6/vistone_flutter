import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/color_swatch_card.dart';
import '../widgets/design_system.dart';
import '../widgets/monk_scale_slider.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final image = ref.watch(selectedImageProvider);
    if (state is! AnalysisSuccess) {
      return const _ResultLoading();
    }
    final result = state.result;

    return Scaffold(
      body: AppPageBackdrop(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    _Header(
                      onBack: () => context.go('/home'),
                      onShare: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your palette is ready to share.')),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _ResultHero(image: image, tone: result.tone, undertone: result.undertone)
                        .animate()
                        .fadeIn(duration: 520.ms)
                        .slideY(begin: .08, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 18),
                    _ConfidencePanel(
                      toneConfidence: result.toneConfidence,
                      undertoneConfidence: result.utConfidence,
                    ).animate().fadeIn(delay: 180.ms).slideY(begin: .06),
                    const SizedBox(height: 18),
                    MonkScaleSlider(monkColors: result.monkColors, detectedTone: result.tone)
                        .animate()
                        .fadeIn(delay: 240.ms)
                        .slideY(begin: .06),
                    const SizedBox(height: AppSpacing.section),
                    _ResultNote(undertone: result.undertone).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: AppSpacing.section),
                    _PaletteSection(
                      title: 'Your palette, at a glance.',
                      label: 'SHADES TO REACH FOR',
                      icon: LucideIcons.sparkles,
                      swatches: result.bestColors,
                      undertone: result.undertone,
                    ),
                    const SizedBox(height: AppSpacing.section),
                    _PaletteSection(
                      title: 'A little less often.',
                      label: 'SHADES TO PAUSE ON',
                      icon: LucideIcons.minusCircle,
                      swatches: result.avoidColors,
                      undertone: result.undertone,
                      isAvoid: true,
                    ),
                    const SizedBox(height: AppSpacing.section),
                    SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        label: 'Analyse another photo',
                        icon: LucideIcons.refreshCw,
                        onPressed: () {
                          ref.read(analysisProvider.notifier).reset();
                          context.go('/home');
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Your colouring is yours alone — use this as a creative starting point.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }
}

class _ResultLoading extends StatelessWidget {
  const _ResultLoading();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: AppPageBackdrop(
          child: const Center(child: CircularProgressIndicator(color: AppColors.forest)),
        ),
      );
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onShare;
  const _Header({required this.onBack, required this.onShare});
  @override
  Widget build(BuildContext context) => Row(
        children: [
          AppIconButton(icon: LucideIcons.arrowLeft, semanticLabel: 'Return home', onTap: onBack),
          const Spacer(),
          Text('YOUR COLOUR STORY', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
          const Spacer(),
          AppIconButton(icon: LucideIcons.share2, semanticLabel: 'Share palette', onTap: onShare),
        ],
      );
}

class _ResultHero extends StatelessWidget {
  final File? image;
  final int tone;
  final String undertone;
  const _ResultHero({required this.image, required this.tone, required this.undertone});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.forestDeep,
        borderRadius: BorderRadius.circular(AppRadii.hero),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          SizedBox(
            height: (screenHeight * 0.28).clamp(200.0, 300.0),
            width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (image != null)
                    Image.file(image!, fit: BoxFit.cover)
                  else
                    const ColoredBox(color: AppColors.sage),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.forestDeep.withValues(alpha: .94)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.textInverse.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(color: AppColors.textInverse.withValues(alpha: .18)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.badgeCheck, size: 14, color: AppColors.marigold),
                          const SizedBox(width: 6),
                          Text('ANALYSIS COMPLETE', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textInverse)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 20,
                    child: Text('Your natural palette', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.textInverse)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _ToneBadge(tone: tone),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$undertone undertone', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textInverse)),
                        const SizedBox(height: 3),
                        Text('Balanced to your individual light and hue.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.nightMuted)),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.sparkles, color: AppColors.marigold),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

class _ToneBadge extends StatelessWidget {
  final int tone;
  const _ToneBadge({required this.tone});
  @override
  Widget build(BuildContext context) => Container(
        width: 58,
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.marigold,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MONK', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.forestDeep, fontSize: 8)),
            Text('$tone', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.forestDeep)),
          ],
        ),
      );
}

class _ConfidencePanel extends StatelessWidget {
  final double toneConfidence;
  final double undertoneConfidence;
  const _ConfidencePanel({required this.toneConfidence, required this.undertoneConfidence});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: dark ? AppColors.nightLine : AppColors.line),
      ),
      child: Row(
        children: [
          _Metric(label: 'TONE MATCH', value: toneConfidence),
          Container(width: 1, height: 38, color: dark ? AppColors.nightLine : AppColors.line),
          _Metric(label: 'UNDERTONE', value: undertoneConfidence),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final double value;
  const _Metric({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${(value.clamp(0, 1) * 100).round()}%', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.forest)),
            const SizedBox(height: 3),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
          ],
        ),
      );
}

class _ResultNote extends StatelessWidget {
  final String undertone;
  const _ResultNote({required this.undertone});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceSage,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IconContainer(icon: LucideIcons.leaf, backgroundColor: AppColors.forest, iconColor: AppColors.textInverse),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What this means for you', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text(
                    'Your $undertone undertone gives us a useful starting point for choosing colour contrast and warmth — never a set of rules.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.inkSoft),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PaletteSection extends StatelessWidget {
  final String title;
  final String label;
  final IconData icon;
  final List swatches;
  final String undertone;
  final bool isAvoid;
  const _PaletteSection({
    required this.title,
    required this.label,
    required this.icon,
    required this.swatches,
    required this.undertone,
    this.isAvoid = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: isAvoid ? AppColors.clay : AppColors.forest),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isAvoid ? AppColors.clay : AppColors.forest)),
            ],
          ),
          const SizedBox(height: 11),
          Text(title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          SizedBox(
            height: 194,
            child: ListView.separated(
              padding: const EdgeInsets.only(right: 4),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: swatches.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final swatch = swatches[index];
                return ColorSwatchCard(
                  swatch: swatch,
                  isAvoid: isAvoid,
                  onTap: () => context.push(
                    '/color-preview',
                    extra: {'swatch': swatch, 'isAvoid': isAvoid, 'undertone': undertone},
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 60 * index)).slideX(begin: .08);
              },
            ),
          ),
        ],
      );
}
