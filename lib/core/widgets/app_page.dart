import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A restrained, reusable wash of colour that stops the app background from
/// feeling like a stack of isolated cards.
class AppPageBackdrop extends StatelessWidget {
  final Widget child;
  final bool dark;

  const AppPageBackdrop({super.key, required this.child, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final isDark = dark || Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: isDark ? AppColors.night : AppColors.canvas),
        Positioned(
          top: -120,
          right: -90,
          child: _BlurredDisc(
            color: isDark ? AppColors.forest : AppColors.sageSoft,
            size: 290,
          ),
        ),
        Positioned(
          top: 370,
          left: -150,
          child: _BlurredDisc(
            color: isDark ? AppColors.inkSoft : AppColors.claySoft,
            size: 260,
          ),
        ),
        child,
      ],
    );
  }
}

class _BlurredDisc extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurredDisc({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 7,
      child: Container(
        width: size,
        height: size * .72,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .46),
          borderRadius: BorderRadius.circular(size),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool inverted;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.semanticLabel,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = inverted
        ? AppColors.textInverse.withValues(alpha: .14)
        : (isDark ? AppColors.nightSurfaceRaised : AppColors.surface);
    final foreground = inverted
        ? AppColors.textInverse
        : (isDark ? AppColors.nightText : AppColors.ink);
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: fill,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(icon, size: 20, color: foreground),
          ),
        ),
      ),
    );
  }
}
