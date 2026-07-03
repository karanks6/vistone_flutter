import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final analysisState = ref.watch(analysisProvider);
    final selectedImage = ref.watch(selectedImageProvider);

    ref.listen(analysisProvider, (_, next) {
      if (next is AnalysisSuccess) {
        context.go('/result');
      } else if (next is AnalysisError) {
        _showError(context, next.message);
      }
    });

    String stage = 'Preparing...';
    if (analysisState is AnalysisLoading) {
      stage = analysisState.stage;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s20),
              Text(
                'Analyzing...',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.s32),
              
              Expanded(
                child: ClipRRect(
                  borderRadius: AppShapes.card,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (selectedImage != null)
                        Image.file(selectedImage, fit: BoxFit.cover)
                      else
                        Container(color: isDark ? AppColors.surfaceDark : AppColors.gray100),

                      // Elegant Shimmer Overlay
                      AnimatedBuilder(
                        animation: _shimmerAnim,
                        builder: (_, __) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.0, 0.5, 1.0],
                                colors: [
                                  Colors.white.withValues(alpha: 0.0),
                                  Colors.white.withValues(alpha: isDark ? 0.1 : 0.3),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                                transform: GradientRotation(_shimmerAnim.value * 3.14159),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s40),
              _StageIndicator(currentStage: stage),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Analysis Failed'),
        content: Text(message),
        actions: [
          AppButton.text(
            label: 'Try Again',
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
          ),
        ],
      ),
    );
  }
}

class _StageIndicator extends StatelessWidget {
  final String currentStage;

  static const _stages = [
    'Detecting face landmarks...',
    'Correcting lighting...',
    'Sampling skin pixels...',
    'Classifying skin tone...',
  ];

  const _StageIndicator({required this.currentStage});

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
        children: _stages.map((stage) {
          final isDone = _stages.indexOf(stage) < _stages.indexOf(currentStage);
          final isCurrent = stage == currentStage;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isDone
                        ? const Icon(Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                            key: ValueKey('done'))
                        : isCurrent
                            ? const CircularProgressIndicator(
                                strokeWidth: 2.5,
                              )
                            : Icon(Icons.circle_outlined,
                                color: isDark ? AppColors.gray600 : AppColors.gray300,
                                size: 20,
                                key: const ValueKey('pending')),
                  ),
                ),
                const SizedBox(width: AppSpacing.s16),
                Text(
                  stage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isCurrent
                        ? theme.textTheme.bodyLarge?.color
                        : isDone
                            ? AppColors.success
                            : (isDark ? AppColors.gray600 : AppColors.gray400),
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
