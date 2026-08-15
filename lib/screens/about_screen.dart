import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/design_system.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPageBackdrop(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    Row(
                      children: [
                        AppIconButton(icon: LucideIcons.arrowLeft, semanticLabel: 'Return home', onTap: () => context.pop()),
                        const SizedBox(width: 14),
                        Text('THE VISTONE METHOD', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textTertiary)),
                      ],
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 38),
                    _GuideHero().animate().fadeIn(duration: 460.ms).slideY(begin: .08),
                    const SizedBox(height: AppSpacing.section),
                    Text('Personal colour,\nwithout the rules.', style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 14),
                    Text(
                      'Vistone offers a useful place to start: a view of the colours that may harmonise with your natural skin tone. Your taste is always the final word.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.section),
                    const _MethodList(),
                    const SizedBox(height: AppSpacing.section),
                    _TechnologyNote(),
                    const SizedBox(height: AppSpacing.section),
                    SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        label: 'Find my palette',
                        icon: LucideIcons.camera,
                        onPressed: () => context.go('/home'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Made to celebrate the nuance in every complexion.',
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
    );
  }
}

class _GuideHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 270,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.forestDeep,
          borderRadius: BorderRadius.circular(AppRadii.hero),
          boxShadow: AppShadows.card,
        ),
        child: Stack(
          children: [
            Positioned(right: -54, top: -76, child: _HeroDisc(size: 210, color: AppColors.marigold)),
            Positioned(left: -62, bottom: -72, child: _HeroDisc(size: 200, color: AppColors.clay)),
            Positioned(right: 54, bottom: 22, child: _HeroDisc(size: 86, color: AppColors.sage)),
            Positioned(
              left: 24,
              top: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.textInverse.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Text('A QUIETLY SMART GUIDE', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textInverse)),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 26,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const VistoneMark(size: 54, inverted: true),
                  const SizedBox(width: 13),
                  Expanded(child: Text('Colour,\nconsidered.', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.textInverse))),
                ],
              ),
            ),
          ],
        ),
      );
}

class _HeroDisc extends StatelessWidget {
  final double size;
  final Color color;
  const _HeroDisc({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class _MethodList extends StatelessWidget {
  const _MethodList();

  @override
  Widget build(BuildContext context) {
    const entries = [
      (LucideIcons.scanFace, 'We read the light', 'A clear, filter-free selfie lets us look at colour with less interference.'),
      (LucideIcons.layers, 'We find your tone', 'Skin-tone information is matched against the inclusive Monk Skin Tone Scale.'),
      (LucideIcons.palette, 'We shape your palette', 'Your lightness and undertone guide the colours we suggest you explore.'),
    ];
    return Column(
      children: List.generate(entries.length, (index) {
        final item = entries[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == entries.length - 1 ? 0 : 12),
          child: AppCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconContainer(icon: item.$1, backgroundColor: AppColors.surfaceClay, iconColor: AppColors.clay),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$2, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 5),
                      Text(item.$3, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text('0${index + 1}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 160 + index * 90)).slideX(begin: .05);
      }),
    );
  }
}

class _TechnologyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceSage,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.shieldCheck, color: AppColors.success, size: 20),
                const SizedBox(width: 9),
                Text('Respectfully private', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Face landmarks and colour sampling happen on your device. Vistone does not store or share your photo.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.inkSoft),
            ),
          ],
        ),
      );
}
