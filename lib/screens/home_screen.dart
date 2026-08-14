import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../widgets/design_system.dart';
import 'upload_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  static const _tips = [
    (LucideIcons.sun, 'Natural Light', 'Step near a window for best accuracy.'),
    (LucideIcons.camera, 'Face the Camera', 'Look directly at the lens.'),
    (LucideIcons.sparkles, 'No Filters', 'Remove makeup & color filters.'),
  ];

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const UploadBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: _buildBottomNav(theme, isDark),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(theme, isDark),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xxxl),
                    _buildHero(theme, isDark),
                    const SizedBox(height: AppSpacing.section),
                    _buildUploadCard(theme, isDark),
                    const SizedBox(height: AppSpacing.section),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildTipsSection(theme, isDark),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.section),
                    _buildHowItWorksCard(theme, isDark),
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

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, 0),
      child: Row(
        children: [
          Text(
            'Vistone',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primary, Color(0xFFC65DE8)],
            ).createShader(bounds),
            child: Text(
              ' AI',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: isDark ? LucideIcons.sun : LucideIcons.moon,
            onTap: () => ref.read(themeProvider.notifier).setMode(isDark ? ThemeMode.light : ThemeMode.dark),
          ),
          const SizedBox(width: AppSpacing.sm),
          _HeaderIconButton(
            icon: LucideIcons.helpCircle,
            onTap: () => context.push('/about'),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(ThemeData theme, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Discover your\ntrue '),
                    TextSpan(
                      text: 'colors.',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
                style: theme.textTheme.displayLarge,
              ).animate().fadeIn(duration: AppMotion.normal).slideY(begin: 0.1, curve: AppMotion.standard),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Upload a selfie to find the perfect color palette that complements your natural skin tone.',
                style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 100.ms, duration: AppMotion.normal),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          flex: 4,
          child: AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.hero),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.surfaceLavender, AppColors.peach],
                ),
              ),
              child: const Icon(LucideIcons.sparkles, size: 48, color: Colors.white),
            ),
          ).animate().fadeIn(delay: 200.ms).scale(curve: AppMotion.emphasized),
        ),
      ],
    );
  }

  Widget _buildUploadCard(ThemeData theme, bool isDark) {
    return AppCard(
      padding: EdgeInsets.zero,
      radius: AppRadii.hero,
      child: InkWell(
        onTap: _showUploadOptions,
        borderRadius: BorderRadius.circular(AppRadii.hero),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: DottedBorder(
            color: const Color(0xFFBBA7FF),
            strokeWidth: 2,
            dashPattern: const [8, 6],
            borderType: BorderType.RRect,
            radius: const Radius.circular(AppRadii.xl),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEE8FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.uploadCloud, size: 32, color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Upload your photo',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'JPG, PNG or WebP\nMax 10MB',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppPrimaryButton(
                    label: 'Choose Photo',
                    onPressed: _showUploadOptions,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: AppMotion.normal).slideY(begin: 0.1);
  }

  Widget _buildTipsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tips for best results',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _tips.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.lg),
            itemBuilder: (context, index) {
              final tip = _tips[index];
              return SizedBox(
                width: 200,
                child: AppCard(
                  radius: AppRadii.lg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconContainer(
                        icon: tip.$1,
                        backgroundColor: AppColors.surfaceLavender,
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(tip.$2, style: theme.textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(tip.$3, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 400 + (index * 60))).slideX(begin: 0.1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksCard(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        gradient: const LinearGradient(
          colors: [Color(0xFFBFA8FF), Color(0xFFFFC5B7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/about'),
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.play, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How does it work?',
                        style: theme.textTheme.titleSmall?.copyWith(color: AppColors.deepInk),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Learn how Vistone AI analyzes your skin tone.',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.deepInk.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: AppColors.deepInk),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildBottomNav(ThemeData theme, bool isDark) {
    return SafeArea(
      child: Container(
        height: 72,
        margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, LucideIcons.home, 'Home', theme),
              _buildNavItem(1, LucideIcons.clock, 'History', theme),
              _buildNavItem(2, LucideIcons.palette, 'Palette', theme),
              _buildNavItem(3, LucideIcons.user, 'Profile', theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, ThemeData theme) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceLavender : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            if (isSelected) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFECE8F4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Icon(icon, size: 22, color: AppColors.deepInk),
        ),
      ),
    );
  }
}
