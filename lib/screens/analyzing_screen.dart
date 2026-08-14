import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

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
    )..repeat();
    _scanAnim = Tween<double>(begin: -0.1, end: 1.1).animate(
      CurvedAnimation(parent: _scanCtrl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
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

    String currentStage = 'Detecting face landmarks...';
    if (analysisState is AnalysisLoading) {
      currentStage = analysisState.stage;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderDefault, width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(LucideIcons.chevronLeft, size: 20, color: AppColors.textPrimary),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Analyzing Your Photo',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'This may take a few seconds...',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
                child: Column(
                  children: [
                    SizedBox(
                      height: 320,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadii.hero),
                              color: AppColors.lavenderTint,
                              border: Border.all(color: AppColors.primaryLight, width: 1.5),
                              boxShadow: AppShadows.card,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadii.hero - 1.5),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (selectedImage != null)
                                    Image.file(selectedImage, fit: BoxFit.cover),
                                  
                                  // Scan Line
                                  AnimatedBuilder(
                                    animation: _scanAnim,
                                    builder: (context, child) {
                                      return Positioned(
                                        top: _scanAnim.value * 320,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.65),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary.withValues(alpha: 0.5),
                                                blurRadius: 12,
                                                spreadRadius: 2,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  const _ScanningBrackets(),
                                ],
                              ),
                            ),
                          ),
                          
                          Positioned(
                            bottom: -20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppRadii.xl),
                                boxShadow: AppShadows.card,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(LucideIcons.sparkles, color: AppColors.primary, size: 20),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'AI is analyzing your skin tone',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.2),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.section),
                    
                    _StageIndicator(currentStage: currentStage),
                    
                    const SizedBox(height: AppSpacing.xxxl),
                    
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      backgroundColor: const Color(0xFFF5F3FF),
                      child: Row(
                        children: [
                          const IconContainer(
                            icon: LucideIcons.shieldCheck,
                            backgroundColor: AppColors.primary,
                            iconColor: Colors.white,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your privacy is our priority',
                                  style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Your photo is processed securely on your device and never stored or shared.',
                                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      backgroundColor: const Color(0xFFF8FAFC),
                      child: Row(
                        children: [
                          IconContainer(
                            icon: LucideIcons.lightbulb,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            iconColor: AppColors.primary,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tip',
                                  style: theme.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Natural light gives the most accurate results. Try near a window for best analysis.',
                                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.section),
                  ],
                ),
              ),
            ),
          ],
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
          AppPrimaryButton(
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

class _ScanningBrackets extends StatelessWidget {
  const _ScanningBrackets();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 24, left: 24, child: _Bracket(angle: 0)),
        Positioned(top: 24, right: 24, child: _Bracket(angle: 1.5708)),
        Positioned(bottom: 24, right: 24, child: _Bracket(angle: 3.14159)),
        Positioned(bottom: 24, left: 24, child: _Bracket(angle: 4.71239)),
      ],
    );
  }
}

class _Bracket extends StatelessWidget {
  final double angle;
  const _Bracket({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        size: const Size(30, 30),
        painter: _BracketPainter(),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 10)
      ..arcToPoint(const Offset(10, 0), radius: const Radius.circular(10))
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StageIndicator extends StatelessWidget {
  final String currentStage;

  static const _stagesData = [
    ('Detecting face landmarks...', 'Detecting face landmarks', '468 landmarks detected'),
    ('Correcting lighting...', 'Correcting lighting & color', 'Optimizing for natural accuracy'),
    ('Sampling skin pixels...', 'Sampling skin pixels', 'Analyzing skin tone regions...'),
    ('Classifying skin tone...', 'Classifying skin tone', 'Matching with Monk Scale...'),
  ];

  const _StageIndicator({required this.currentStage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    int currentIndex = _stagesData.indexWhere((s) => s.$1 == currentStage);
    if (currentIndex == -1) currentIndex = 0;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: List.generate(_stagesData.length, (index) {
          final isDone = index < currentIndex;
          final isCurrent = index == currentIndex;
          final stage = _stagesData[index];
          
          return Padding(
            padding: EdgeInsets.only(bottom: index == _stagesData.length - 1 ? 0 : AppSpacing.xl),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isDone
                        ? Container(
                            key: const ValueKey('done'),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.check, color: Colors.white, size: 16),
                          ).animate().scale(begin: const Offset(0.75, 0.75), end: const Offset(1, 1))
                        : isCurrent
                            ? const SizedBox(
                                key: ValueKey('current'),
                                width: 24, 
                                height: 24, 
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primary,
                                )
                              )
                            : Container(
                                key: const ValueKey('pending'),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.$2,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isCurrent || isDone ? AppColors.textPrimary : AppColors.textDisabled,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stage.$3,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDone 
                        ? AppColors.successSoft 
                        : isCurrent
                            ? AppColors.lavenderTint 
                            : const Color(0xFFF1F5F9), // Gray 100
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Text(
                    isDone ? 'Completed' : isCurrent ? 'In Progress' : 'Pending',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDone
                          ? AppColors.success
                          : isCurrent
                              ? AppColors.primary
                              : AppColors.textDisabled,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
