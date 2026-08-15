import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../widgets/design_system.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _navigationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPageBackdrop(
        dark: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const VistoneMark(inverted: true),
                    const SizedBox(width: 12),
                    Text(
                      'VISTONE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.textInverse,
                            letterSpacing: 2.2,
                          ),
                    ),
                  ],
                ).animate().fadeIn(duration: 420.ms).slideX(begin: -.08),
                const Spacer(),
                Center(
                  child: _PaletteHalo()
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(
                        begin: const Offset(.94, .94),
                        end: const Offset(1.04, 1.04),
                        duration: 2200.ms,
                        curve: Curves.easeInOutSine,
                      )
                      .fadeIn(duration: 800.ms, curve: Curves.easeOut),
                ),
                const SizedBox(height: AppSpacing.hero),
                Text(
                  'Find the shades\nthat feel like you.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.textInverse,
                        fontSize: 46,
                      ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 700.ms)
                    .slideY(begin: .12, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Personal colour, thoughtfully made personal.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.nightMuted,
                      ),
                ).animate().fadeIn(delay: 560.ms, duration: 550.ms),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 82,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppColors.sage,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    )
                        .animate()
                        .scaleX(
                          begin: 0,
                          end: 1,
                          alignment: Alignment.centerLeft,
                          delay: 400.ms,
                          duration: 1500.ms,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(width: 12),
                    Text(
                      'YOUR COLOUR STUDIO',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.nightMuted,
                          ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaletteHalo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textInverse.withValues(alpha: .12)),
            ),
          ),
          Container(
            width: 164,
            height: 164,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.clay, AppColors.marigold, AppColors.sage],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.clay.withValues(alpha: .25),
                  blurRadius: 42,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.forestDeep.withValues(alpha: .84),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textInverse.withValues(alpha: .25)),
            ),
            child: const VistoneMark(size: 48, inverted: true),
          ),
        ],
      ),
    );
  }
}
