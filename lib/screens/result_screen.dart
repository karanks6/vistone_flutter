import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';
import '../widgets/color_swatch_card.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final selectedImage = ref.watch(selectedImageProvider);
    final theme = Theme.of(context);

    if (state is! AnalysisSuccess) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    final result = state.result;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconBtn(
                    icon: LucideIcons.chevronLeft,
                    onTap: () => context.go('/home'),
                  ),
                  _CircleIconBtn(
                    icon: LucideIcons.share,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadii.hero),
                              boxShadow: AppShadows.card,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadii.hero),
                                  child: selectedImage != null
                                      ? Image.file(
                                          selectedImage,
                                          fit: BoxFit.cover,
                                          height: 300,
                                          width: double.infinity,
                                        )
                                      : Container(height: 300, color: const Color(0xFFF1F5F9)),
                                ),
                                Positioned(
                                  bottom: AppSpacing.md,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(AppRadii.pill),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Analysis Completed',
                                          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn().slideY(begin: 0.1, duration: AppMotion.normal),
                        ),
                        
                        const SizedBox(width: AppSpacing.xl),
                        
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Skin Tone',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Monk ${result.tone}',
                                style: theme.textTheme.displayLarge,
                              ),
                              const SizedBox(height: 8),
                              
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.successSoft,
                                  borderRadius: BorderRadius.circular(AppRadii.pill),
                                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(LucideIcons.leaf, color: AppColors.success, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${result.undertone} Undertone',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: AppSpacing.xl),
                              
                              AppCard(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'MONK SCALE',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        letterSpacing: 1,
                                        color: AppColors.textDisabled,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('1 (Lightest)', style: theme.textTheme.bodySmall?.copyWith(fontSize: 8, color: AppColors.textDisabled)),
                                        Text('10 (Deepest)', style: theme.textTheme.bodySmall?.copyWith(fontSize: 8, color: AppColors.textDisabled)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(10, (index) {
                                        final isSelected = index + 1 == result.tone;
                                        return Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.center,
                                          children: [
                                            if (isSelected)
                                              Container(
                                                width: 24,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: AppColors.lavenderTint,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            Container(
                                              width: isSelected ? 16 : 12,
                                              height: isSelected ? 32 : 24,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(result.monkColors[index].replaceAll('#', '0xFF'))),
                                                borderRadius: BorderRadius.circular(10),
                                                border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                                              ),
                                            ),
                                            if (isSelected)
                                              Positioned(
                                                bottom: -16,
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: const BoxDecoration(
                                                    color: AppColors.primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    '${result.tone}',
                                                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: AppSpacing.xl),
                              
                              _ConfidenceBar(label: 'Tone Confidence', percent: result.toneConfidence, color: AppColors.primary),
                              const SizedBox(height: AppSpacing.md),
                              _ConfidenceBar(label: 'Undertone Confidence', percent: result.utConfidence, color: AppColors.success),
                              
                            ],
                          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, duration: AppMotion.normal),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.section),
                    
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      backgroundColor: const Color(0xFFF5F3FF),
                      child: Row(
                        children: [
                          const IconContainer(
                            icon: LucideIcons.sparkles,
                            backgroundColor: AppColors.primary,
                            iconColor: Colors.white,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Great News!',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'You have a balanced ${result.undertone.toLowerCase()} undertone. You can pull off a wide range of colors.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: AppSpacing.section),
                    
                    _SectionHeader(title: 'Your Best Colors', icon: LucideIcons.sparkles),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        itemCount: result.bestColors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.lg),
                        itemBuilder: (context, i) => ColorSwatchCard(
                          swatch: result.bestColors[i],
                          onTap: () => context.push(
                            '/color-preview',
                            extra: {
                              'swatch': result.bestColors[i],
                              'isAvoid': false,
                              'undertone': result.undertone,
                            },
                          ),
                        ).animate().scaleXY(begin: 0.9, duration: 400.ms, delay: (500 + i*50).ms).fadeIn(),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.section),
                    
                    _SectionHeader(title: 'Colors to Avoid', icon: LucideIcons.ban),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        itemCount: result.avoidColors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.lg),
                        itemBuilder: (context, i) => ColorSwatchCard(
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
                        ).animate().scaleXY(begin: 0.9, duration: 400.ms, delay: (700 + i*50).ms).fadeIn(),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.section),
                    
                    AppPrimaryButton(
                      label: 'Analyze Another Photo',
                      icon: LucideIcons.camera,
                      onPressed: () {
                        ref.read(analysisProvider.notifier).reset();
                        context.go('/home');
                      },
                    ),
                    
                    const SizedBox(height: AppSpacing.xxl),
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

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const _ConfidenceBar({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int pctString = (percent * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.sparkles, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '$pctString%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(3),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * percent,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ).animate().scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 900.ms, curve: Curves.easeOutCubic),
                ],
              );
            },
          ),
        ),
      ],
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        Text(
          'VIEW ALL',
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
