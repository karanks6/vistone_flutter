import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/design_system.dart';
import '../widgets/botanical_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BotanicalBackground(
        opacity: isDark ? 0.15 : 0.4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo with Spring Animation
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.gray800 : AppColors.surfaceLight,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset(
                    'assets/icon/vistone_logo.png',
                    fit: BoxFit.contain,
                    color: AppColors.primary,
                  ),
                ),
              )
              .animate()
              .scale(
                duration: 800.ms, 
                curve: Curves.elasticOut,
                begin: const Offset(0.5, 0.5),
              )
              .fadeIn(duration: 400.ms),

              const SizedBox(height: AppSpacing.s32),

              // App Title
              Text(
                'Vistone AI',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                ),
              )
              .animate()
              .slideY(
                begin: 0.5, 
                end: 0, 
                duration: 600.ms, 
                curve: Curves.easeOutBack,
                delay: 200.ms
              )
              .fadeIn(duration: 600.ms, delay: 200.ms),

              const SizedBox(height: AppSpacing.s12),

              // Subtitle
              Text(
                'Discover your true colors.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.gray400 : AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .slideY(
                begin: 0.5, 
                end: 0, 
                duration: 600.ms, 
                curve: Curves.easeOutBack,
                delay: 300.ms
              )
              .fadeIn(duration: 600.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
