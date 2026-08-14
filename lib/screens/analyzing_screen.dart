import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
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

    String currentStage = 'Detecting face landmarks...';
    if (analysisState is AnalysisLoading) {
      currentStage = analysisState.stage;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceAltDark : AppColors.surfaceLight,
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
                      child: Icon(Symbols.chevron_left, size: 20, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Analyzing Your Photo',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'This may take a few seconds...',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.gray400 : AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                child: Column(
                  children: [
                    // Image Container
                    SizedBox(
                      height: 320,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: isDark ? AppColors.surfaceDark : AppColors.gray100,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                )
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (selectedImage != null)
                                    Image.file(selectedImage, fit: BoxFit.cover),
                                  
                                  // Shimmer
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
                                              Colors.white.withValues(alpha: 0.2),
                                              Colors.white.withValues(alpha: 0.0),
                                            ],
                                            transform: GradientRotation(_shimmerAnim.value * 3.14159),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  // Corner Brackets
                                  const _ScanningBrackets(),
                                ],
                              ),
                            ),
                          ),
                          
                          // Floating Badge
                          Positioned(
                            bottom: -20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceAltDark : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Symbols.auto_awesome, color: theme.colorScheme.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI is analyzing your skin tone',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.s40),
                    
                    // Progress List
                    _StageIndicator(currentStage: currentStage),
                    
                    const SizedBox(height: AppSpacing.s32),
                    
                    // Privacy Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceAltDark : const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Symbols.shield, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: AppSpacing.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your privacy is our priority',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your photo is processed securely on your device and never stored or shared.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.gray400 : AppColors.textPrimaryLight,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s16),
                          Icon(Symbols.admin_panel_settings, color: theme.colorScheme.primary.withValues(alpha: 0.5), size: 40),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.s16),
                    
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
    final isDark = theme.brightness == Brightness.dark;
    
    // Find current stage index based on exact string match from provider
    int currentIndex = _stagesData.indexWhere((s) => s.$1 == currentStage);
    if (currentIndex == -1) currentIndex = 0; // Default fallback

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: List.generate(_stagesData.length, (index) {
          final isDone = index < currentIndex;
          final isCurrent = index == currentIndex;
          final stage = _stagesData[index];
          
          return Padding(
            padding: EdgeInsets.only(bottom: index == _stagesData.length - 1 ? 0 : AppSpacing.s20),
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
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Symbols.check, color: Colors.white, size: 16),
                          )
                        : isCurrent
                            ? SizedBox(
                                key: const ValueKey('current'),
                                width: 24, 
                                height: 24, 
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: theme.colorScheme.primary,
                                )
                              )
                            : Container(
                                key: const ValueKey('pending'),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isDark ? AppColors.gray600 : AppColors.gray300, width: 2),
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.$2,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isCurrent || isDone
                              ? (isDark ? Colors.white : AppColors.textPrimaryLight)
                              : (isDark ? AppColors.gray500 : AppColors.gray400),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stage.$3,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.gray500 : AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDone 
                        ? const Color(0xFFDCFCE7) // Light Green
                        : isCurrent
                            ? const Color(0xFFF3E8FF) // Light Purple
                            : isDark ? AppColors.gray800 : AppColors.gray100, // Light Gray
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isDone ? 'Completed' : isCurrent ? 'In Progress' : 'Pending',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDone
                          ? const Color(0xFF16A34A) // Dark Green
                          : isCurrent
                              ? theme.colorScheme.primary // Purple
                              : isDark ? AppColors.gray400 : AppColors.gray500, // Gray
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
