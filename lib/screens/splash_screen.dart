import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: VistoneColors.bgGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: AnimatedBuilder(
              animation: _slideAnim,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _slideAnim.value),
                child: child,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated glowing orb
                  _GlowOrb(),
                  const SizedBox(height: 28),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        VistoneColors.brandGradient.createShader(bounds),
                    child: Text(
                      'Vistone',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 48,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Discover the colors that love you back.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: VistoneColors.textMuted,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatefulWidget {
  @override
  State<_GlowOrb> createState() => _GlowOrbState();
}

class _GlowOrbState extends State<_GlowOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: VistoneColors.brandGradient,
          boxShadow: [
            BoxShadow(
              color: VistoneColors.brand1.withValues(alpha: 0.5 * _pulse.value),
              blurRadius: 40 * _pulse.value,
              spreadRadius: 10 * _pulse.value,
            ),
          ],
        ),
        child: const Icon(Icons.palette_outlined,
            color: Colors.white, size: 36),
      ),
    );
  }
}
