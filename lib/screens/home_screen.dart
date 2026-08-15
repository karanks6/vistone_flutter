import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../widgets/design_system.dart';
import 'upload_bottom_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UploadBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: AppPageBackdrop(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 36),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    _TopBar(
                      dark: dark,
                      onThemeTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                      onGuideTap: () => context.push('/about'),
                    ),
                    const SizedBox(height: AppSpacing.hero),
                    _Hero(theme: theme),
                    const SizedBox(height: AppSpacing.xxxl),
                    _UploadPanel(onTap: () => _showUploadOptions(context))
                        .animate()
                        .fadeIn(delay: 250.ms, duration: 520.ms)
                        .slideY(begin: .10, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: AppSpacing.section),
                    _SectionTitle(
                      eyebrow: 'PREPARE YOUR PHOTO',
                      title: 'A good selfie makes a\nbetter palette.',
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _PreparationList(),
                    const SizedBox(height: AppSpacing.section),
                    _GuideCard(onTap: () => context.push('/about')),
                    const SizedBox(height: AppSpacing.xxxl),
                    Center(
                      child: Text(
                        'VISTONE · PRIVATE BY DESIGN',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: dark ? AppColors.nightMuted : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool dark;
  final VoidCallback onThemeTap;
  final VoidCallback onGuideTap;

  const _TopBar({required this.dark, required this.onThemeTap, required this.onGuideTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset('assets/icon/vistone_logo.png', width: 62, height: 62, fit: BoxFit.cover),
        ),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('VISTONE AI', style: Theme.of(context).textTheme.labelMedium?.copyWith(letterSpacing: 1.8)),
            const SizedBox(height: 2),
            Text('Colour studio', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const Spacer(),
        AppIconButton(
          icon: dark ? LucideIcons.sun : LucideIcons.moon,
          semanticLabel: dark ? 'Use light theme' : 'Use dark theme',
          onTap: onThemeTap,
        ),
        const SizedBox(width: 8),
        AppIconButton(
          icon: LucideIcons.helpCircle,
          semanticLabel: 'Learn about Vistone',
          onTap: onGuideTap,
        ),
      ],
    ).animate().fadeIn(duration: 350.ms).slideY(begin: -.08, end: 0);
  }
}

class _Hero extends StatelessWidget {
  final ThemeData theme;

  const _Hero({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dress in your\nbest light.',
          style: theme.textTheme.displayLarge,
        ).animate().fadeIn(delay: 120.ms, duration: 550.ms).slideY(begin: .12),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'A thoughtful read of your natural colouring, with shades made to bring you forward.',
          style: theme.textTheme.bodyLarge,
        ).animate().fadeIn(delay: 250.ms, duration: 420.ms),
      ],
    );
  }
}

class _ColorComposition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.28,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.forestDeep,
          borderRadius: BorderRadius.circular(AppRadii.hero),
          boxShadow: AppShadows.card,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -44,
              top: -35,
              child: _Orb(size: 210, color: AppColors.marigold.withValues(alpha: .9)),
            ),
            Positioned(
              left: -48,
              bottom: -78,
              child: _Orb(size: 210, color: AppColors.clay.withValues(alpha: .86)),
            ),
            Positioned(
              right: 78,
              bottom: -36,
              child: _Orb(size: 122, color: AppColors.sage.withValues(alpha: .93)),
            ),
            Positioned(
              left: 26,
              top: 24,
              child: Text(
                'YOUR\nNATURAL\nPALETTE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textInverse.withValues(alpha: .82),
                      height: 1.65,
                      letterSpacing: 1.65,
                    ),
              ),
            ),
            Positioned(
              left: 26,
              bottom: 22,
              child: Row(
                children: const [
                  _MiniSwatch(color: AppColors.clay),
                  SizedBox(width: 7),
                  _MiniSwatch(color: AppColors.marigold),
                  SizedBox(width: 7),
                  _MiniSwatch(color: AppColors.sage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

class _MiniSwatch extends StatelessWidget {
  final Color color;
  const _MiniSwatch({required this.color});
  @override
  Widget build(BuildContext context) => Container(
        height: 26,
        width: 26,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textInverse.withValues(alpha: .35)),
        ),
      );
}

class _UploadPanel extends StatelessWidget {
  final VoidCallback onTap;
  const _UploadPanel({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.hero),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.hero),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.hero),
            border: Border.all(color: dark ? AppColors.nightLine : AppColors.line),
          ),
          child: Column(
            children: [
              Container(
                height: 62,
                width: 62,
                decoration: const BoxDecoration(color: AppColors.surfaceClay, shape: BoxShape.circle),
                child: const Icon(LucideIcons.scanFace, color: AppColors.clay, size: 28),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Start with a simple selfie', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                'No filters, just natural light and your lovely face.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: 'Choose a photo',
                  icon: LucideIcons.camera,
                  onPressed: onTap,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                'YOUR PHOTO STAYS ON THIS DEVICE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  const _SectionTitle({required this.eyebrow, required this.title});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.forest)),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.displaySmall),
        ],
      );
}

class _PreparationList extends StatelessWidget {
  const _PreparationList();

  @override
  Widget build(BuildContext context) {
    const tips = [
      (LucideIcons.sunMedium, 'Find gentle daylight', 'Face a window and avoid harsh overhead light.'),
      (LucideIcons.focus, 'Keep your face clear', 'Look at the camera with your full face in view.'),
      (LucideIcons.sparkle, 'Skip the filters', 'Use a recent, unedited photo for the truest read.'),
    ];
    return Column(
      children: List.generate(tips.length, (index) {
        final tip = tips[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == tips.length - 1 ? 0 : 12),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconContainer(icon: tip.$1, backgroundColor: AppColors.surfaceSage, iconColor: AppColors.forest),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip.$2, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 3),
                      Text(tip.$3, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text('0${index + 1}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 380 + (index * 90))).slideX(begin: .05);
      }),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final VoidCallback onTap;
  const _GuideCard({required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.forestDeep,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.textInverse.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(LucideIcons.bookOpen, color: AppColors.marigold, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How Vistone sees colour', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textInverse)),
                      const SizedBox(height: 4),
                      Text('A simple guide to your analysis.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.nightMuted)),
                    ],
                  ),
                ),
                const Icon(LucideIcons.arrowUpRight, color: AppColors.textInverse),
              ],
            ),
          ),
        ),
      );
}
