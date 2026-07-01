import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/analysis_provider.dart';
import '../theme/app_theme.dart';

class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanCtrl;
  late final Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanAnim = CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        decoration: const BoxDecoration(gradient: VistoneColors.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (b) =>
                      VistoneColors.brandGradient.createShader(b),
                  child: const Text(
                    'Analyzing...',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (selectedImage != null)
                          Image.file(selectedImage, fit: BoxFit.cover)
                        else
                          Container(color: VistoneColors.surface),

                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                VistoneColors.bgDark.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),

                        // Animated scan line
                        AnimatedBuilder(
                          animation: _scanAnim,
                          builder: (_, __) {
                            return Positioned(
                              top: MediaQuery.of(context).size.height *
                                  0.4 *
                                  _scanAnim.value,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.transparent,
                                    VistoneColors.brand1.withValues(alpha: 0.8),
                                    VistoneColors.brand2.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: VistoneColors.brand1
                                          .withValues(alpha: 0.5),
                                      blurRadius: 12,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                _StageIndicator(currentStage: stage),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: VistoneColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Analysis Failed',
            style: TextStyle(color: VistoneColors.textPrimary)),
        content: Text(message,
            style: const TextStyle(color: VistoneColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text('Try Again',
                style: TextStyle(color: VistoneColors.brand1)),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: VistoneColors.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: _stages.map((stage) {
          final isDone = _stages.indexOf(stage) <
              _stages.indexOf(currentStage);
          final isCurrent = stage == currentStage;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isDone
                      ? const Icon(Icons.check_circle,
                          color: VistoneColors.success,
                          size: 18,
                          key: ValueKey('done'))
                      : isCurrent
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: VistoneColors.brand1,
                              ),
                            )
                          : const Icon(Icons.circle_outlined,
                              color: VistoneColors.textMuted,
                              size: 18,
                              key: ValueKey('pending')),
                ),
                const SizedBox(width: 12),
                Text(
                  stage,
                  style: TextStyle(
                    color: isCurrent
                        ? VistoneColors.textPrimary
                        : isDone
                            ? VistoneColors.success
                            : VistoneColors.textMuted,
                    fontSize: 14,
                    fontWeight:
                        isCurrent ? FontWeight.w600 : FontWeight.w400,
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
