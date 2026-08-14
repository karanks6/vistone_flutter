import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/analysis_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/design_system.dart';
import '../widgets/upload_zone.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  static const _tips = [
    (Symbols.light_mode, 'Natural Light', 'Step near a window for best accuracy.'),
    (Symbols.face, 'Face the Camera', 'Look directly at the lens.'),
    (Symbols.auto_fix_high, 'No Filters', 'Remove makeup & color filters.'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: isDark ? AppColors.gray500 : AppColors.gray400,
          showUnselectedLabels: true,
          selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: theme.textTheme.labelSmall,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Symbols.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Symbols.schedule), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Symbols.palette), label: 'Palette'),
            BottomNavigationBarItem(icon: Icon(Symbols.person), label: 'Profile'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: isDark ? 0.15 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.s12),
                  
                  // Top Bar
                  Row(
                    children: [
                      Text(
                        'Vistone',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        ' AI',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      // Sparkles
                      Transform.translate(
                        offset: const Offset(2, -8),
                        child: Icon(Symbols.auto_awesome, size: 20, color: theme.colorScheme.primary.withValues(alpha: 0.6)),
                      ),
                      const Spacer(),
                      _CircleButton(
                        icon: isDark ? Symbols.light_mode : Symbols.dark_mode,
                        onTap: () => ref.read(themeProvider.notifier).setMode(isDark ? ThemeMode.light : ThemeMode.dark),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      _CircleButton(
                        icon: Symbols.help_outline,
                        onTap: () {},
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.s40),
                  
                  // Hero Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text Side
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                                children: [
                                  const TextSpan(text: 'Discover your\ntrue '),
                                  TextSpan(
                                    text: 'colors.',
                                    style: TextStyle(color: theme.colorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            Text(
                              'Upload a selfie to find the perfect color palette that complements your natural skin tone.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.gray400 : AppColors.gray500,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      // Graphic Side
                      const Expanded(
                        flex: 5,
                        child: _HeroGraphic(),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.s40),
                  
                  // Upload Zone
                  UploadZone(
                    onImagePicked: (file) => _startAnalysis(context, ref, file),
                  ),
                  
                  const SizedBox(height: AppSpacing.s48),
                  
                  // Tips Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Symbols.auto_awesome, size: 20, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Text(
                        'Tips for best results',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? AppColors.gray400 : AppColors.gray600,
                          textStyle: theme.textTheme.bodyMedium,
                        ),
                        child: const Row(
                          children: [
                            Text('See all'),
                            SizedBox(width: 4),
                            Icon(Symbols.chevron_right, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.s16),
                  
                  // Tip Cards List
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: _tips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s16),
                      itemBuilder: (_, i) => _TipCard(
                        icon: _tips[i].$1,
                        title: _tips[i].$2,
                        body: _tips[i].$3,
                        index: i + 1,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.s32),
                  
                  // How it works
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: isDark ? [
                          Color(0xFF3B2A50),
                          Color(0xFF4A344A),
                        ] : [
                          Color(0xFFEBE3FE), // Very Soft Purple
                          Color(0xFFFEE4D6), // Very Soft Peach
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        // Play Icon Container
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: const Icon(Symbols.play_arrow_rounded, color: Colors.white, size: 28),
                            ),
                            const Icon(Symbols.auto_awesome, size: 16, color: Colors.white),
                          ],
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How does it work?',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Learn how Vistone AI analyzes your skin tone and finds your perfect palette.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.gray400 : AppColors.gray600,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Circular Chevron
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Symbols.arrow_forward_rounded, color: Colors.black, size: 20),
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
    );
  }

  Future<void> _startAnalysis(BuildContext context, WidgetRef ref, File file) async {
    ref.read(selectedImageProvider.notifier).state = file;
    ref.read(analysisProvider.notifier).reset();
    context.push('/analyzing');
    await ref.read(analysisProvider.notifier).analyze(file);
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
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
        child: Icon(icon, size: 20, color: isDark ? Colors.white : AppColors.textPrimaryLight),
      ),
    );
  }
}

class _HeroGraphic extends StatelessWidget {
  const _HeroGraphic();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Outer thin ring
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6), width: 1.5),
            ),
          ),
          // Inner Solid Gradient Circle
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFE9D5FF), // Light Purple
                    Color(0xFFFFEDD5), // Light Peach
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Symbols.face_3,
                  size: 80,
                  color: const Color(0xFF4C4556).withValues(alpha: 0.9), // Dark Silhouette color
                ),
              ),
            ),
          ),
          
          // Decorative Stars
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Symbols.auto_awesome, size: 16, color: AppColors.primary.withValues(alpha: 0.5)),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Icon(Symbols.auto_awesome, size: 18, color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          Positioned(
            bottom: 20,
            left: -10,
            child: Icon(Symbols.auto_awesome, size: 20, color: AppColors.secondary.withValues(alpha: 0.6)),
          ),
          
          // Color Palette Dots
          Positioned(
            bottom: -5,
            right: -20,
            child: Row(
              children: [
                _ColorDot(color: Color(0xFFF9D5C4)), // Light Peach
                _ColorDot(color: Color(0xFFF3B4A4)), // Dark Peach
                _ColorDot(color: Color(0xFFE5A0C8)), // Pink
                _ColorDot(color: Color(0xFF9070D9)), // Dark Purple
                _ColorDot(color: Color(0xFFB19CD9)), // Light Purple
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;

  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.bgLight, width: 3),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final int index;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final indexStr = index.toString().padLeft(2, '0');
    
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.s20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray800 : const Color(0xFFF5F3FF), // Very soft purple background
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 24, color: theme.colorScheme.primary),
          ),
          const Spacer(),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 15, 
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray500,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.s12),
          // Divider and Number
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray700 : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                indexStr,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.gray600 : AppColors.gray300,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
