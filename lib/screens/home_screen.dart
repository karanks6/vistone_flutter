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
    (Symbols.filter_b_and_w, 'No Filters', 'Remove makeup & color filters.'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
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
            BottomNavigationBarItem(icon: Icon(Symbols.home), label: 'Home'),
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
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: isDark ? 0.15 : 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 100,
            child: Container(
              width: 250,
              height: 250,
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
                  const SizedBox(height: AppSpacing.s16),
                  
                  // Top Bar
                  Row(
                    children: [
                      Text(
                        'Vistone',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.textTheme.displayLarge?.color,
                        ),
                      ),
                      Text(
                        ' AI',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      _CircleButton(
                        icon: isDark ? Symbols.light_mode : Symbols.dark_mode,
                        onTap: () => ref.read(themeProvider.notifier).setMode(isDark ? ThemeMode.light : ThemeMode.dark),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      _CircleButton(
                        icon: Symbols.help,
                        onTap: () {},
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.s32),
                  
                  // Hero Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text Side
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: theme.textTheme.displayMedium,
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
                                color: isDark ? AppColors.gray400 : AppColors.gray600,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      // Graphic Side
                      const Expanded(
                        flex: 4,
                        child: _HeroGraphic(),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.s40),
                  
                  // Upload Zone
                  UploadZone(
                    onImagePicked: (file) => _startAnalysis(context, ref, file),
                  ),
                  
                  const SizedBox(height: AppSpacing.s40),
                  
                  // Tips Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Symbols.auto_awesome, size: 20, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Text(
                        'Tips for best results',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: _tips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s16),
                      itemBuilder: (_, i) => _TipCard(
                        icon: _tips[i].$1,
                        title: _tips[i].$2,
                        body: _tips[i].$3,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.s32),
                  
                  // How it works
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAltLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.gray800 : AppColors.surfaceLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Symbols.help_outline, color: theme.colorScheme.primary, size: 24),
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How does it work?',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Learn how Vistone AI finds your perfect palette.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: theme.textTheme.bodyLarge?.color),
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
        children: [
          // Circular Background
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFE4E1), // Soft Peach/Pink
                  Color(0xFFE6E6FA), // Soft Lavender
                ],
              ),
            ),
          ),
          // Silhouette placeholder
          Center(
            child: Icon(
              Symbols.face_retouching_natural,
              size: 80,
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),
          // Decorative Stars
          Positioned(
            top: 20,
            right: 20,
            child: Icon(Symbols.auto_awesome, size: 16, color: AppColors.primary.withValues(alpha: 0.5)),
          ),
          Positioned(
            bottom: 40,
            left: 10,
            child: Icon(Symbols.auto_awesome, size: 20, color: AppColors.secondary.withValues(alpha: 0.5)),
          ),
          // Color Palette Dots
          Positioned(
            bottom: 10,
            right: 0,
            child: Row(
              children: [
                _ColorDot(color: Color(0xFFE8B4B8)),
                _ColorDot(color: Color(0xFFEED6D3)),
                _ColorDot(color: Color(0xFFA49393)),
                _ColorDot(color: Color(0xFF67595E)),
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
      width: 16,
      height: 16,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray800 : AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.gray700 : AppColors.borderLight),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const Spacer(),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.gray400 : AppColors.gray500,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
