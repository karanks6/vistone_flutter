import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
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
    final isDark = theme.brightness == Brightness.dark;

    if (state is! AnalysisSuccess) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    final result = state.result;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconBtn(
                    icon: Symbols.chevron_left,
                    onTap: () => context.go('/home'),
                  ),
                  _CircleIconBtn(
                    icon: Symbols.share,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Split Header Layout
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Image
                        Expanded(
                          flex: 4,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: selectedImage != null
                                    ? Image.file(
                                        selectedImage,
                                        fit: BoxFit.cover,
                                        height: 300,
                                        width: double.infinity,
                                      )
                                    : Container(height: 300, color: AppColors.gray200),
                              ),
                              Positioned(
                                bottom: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Symbols.check_circle, color: Colors.white, size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        'Analysis Completed',
                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn().slideY(begin: 0.1, duration: 500.ms, curve: Curves.easeOutQuad),
                        ),
                        
                        const SizedBox(width: AppSpacing.s16),
                        
                        // Right: Skin Tone Details
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Skin Tone',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Monk ${result.tone}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Undertone Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7).withValues(alpha: isDark ? 0.2 : 0.5), // Soft green
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Symbols.eco, color: Color(0xFF16A34A), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${result.undertone} Undertone',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: const Color(0xFF16A34A),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: AppSpacing.s16),
                              
                              // Monk Scale Mini Card
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.s12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceAltDark : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
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
                                    Text(
                                      'MONK SCALE',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('1 (Lightest)', style: TextStyle(fontSize: 8, color: isDark ? AppColors.gray500 : AppColors.gray400)),
                                        Text('10 (Deepest)', style: TextStyle(fontSize: 8, color: isDark ? AppColors.gray500 : AppColors.gray400)),
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
                                            Container(
                                              width: isSelected ? 16 : 12,
                                              height: isSelected ? 32 : 24,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(result.monkColors[index].replaceAll('#', '0xFF'))),
                                                borderRadius: BorderRadius.circular(10),
                                                border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
                                              ),
                                            ),
                                            if (isSelected)
                                              Positioned(
                                                bottom: -16,
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: theme.colorScheme.primary,
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
                              
                              const SizedBox(height: AppSpacing.s16),
                              
                              // Confidence Scores
                              _ConfidenceBar(label: 'Tone Confidence', percent: result.toneConfidence, color: theme.colorScheme.primary),
                              const SizedBox(height: AppSpacing.s12),
                              _ConfidenceBar(label: 'Undertone Confidence', percent: result.utConfidence, color: const Color(0xFF16A34A)),
                              
                            ],
                          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, duration: 500.ms, curve: Curves.easeOutQuad),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.s24),
                    
                    // Great News Banner
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceAltDark : const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Symbols.auto_awesome, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: AppSpacing.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Great News!',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'You have a balanced ${result.undertone.toLowerCase()} undertone. You can pull off a wide range of colors.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.gray400 : AppColors.textPrimaryLight,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, duration: 500.ms),
                    
                    const SizedBox(height: AppSpacing.s40),
                    
                    // Best Colors
                    _SectionHeader(title: 'Your Best Colors', icon: Symbols.auto_awesome),
                    const SizedBox(height: AppSpacing.s16),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: result.bestColors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s16),
                        itemBuilder: (context, i) => SizedBox(
                          width: 140,
                          child: ColorSwatchCard(
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
                        ).animate().scaleXY(begin: 0.9, duration: 400.ms, delay: (500 + i*50).ms).fadeIn(),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.s40),
                    
                    // Colors to Avoid
                    _SectionHeader(title: 'Colors to Avoid', icon: Symbols.block),
                    const SizedBox(height: AppSpacing.s16),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: result.avoidColors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s16),
                        itemBuilder: (context, i) => SizedBox(
                          width: 140,
                          child: ColorSwatchCard(
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
                        ).animate().scaleXY(begin: 0.9, duration: 400.ms, delay: (700 + i*50).ms).fadeIn(),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.s40),
                    
                    // Analyze Another Photo Button
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
                        onTap: () {
                          ref.read(analysisProvider.notifier).reset();
                          context.go('/home');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Symbols.photo_camera, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Analyze Another Photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.s24),
                    
                    // Tip Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceAltDark : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Symbols.lightbulb, color: theme.colorScheme.primary, size: 24),
                          ),
                          const SizedBox(width: AppSpacing.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tip',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Natural light gives the most accurate results. Try near a window for best analysis.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.gray400 : AppColors.gray600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          Icon(Symbols.chevron_right, color: isDark ? AppColors.gray500 : AppColors.gray400),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.s40),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceAltDark : Colors.white,
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
        child: Icon(icon, size: 20, color: isDark ? Colors.white : AppColors.textPrimaryLight),
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
    final isDark = theme.brightness == Brightness.dark;
    final int pctString = (percent * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Symbols.auto_awesome, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.gray400 : AppColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$pctString%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray800 : AppColors.gray200,
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
                  ).animate().scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 800.ms, curve: Curves.easeOutCubic),
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
    final isDark = theme.brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        Text(
          'VIEW ALL',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
