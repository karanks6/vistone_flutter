import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/color_swatch.dart' as models;
import 'design_system.dart';

class ColorSwatchCard extends StatefulWidget {
  final models.ColorSwatch swatch;
  final bool isAvoid;
  final VoidCallback? onTap;

  const ColorSwatchCard({
    super.key,
    required this.swatch,
    this.isAvoid = false,
    this.onTap,
  });

  @override
  State<ColorSwatchCard> createState() => _ColorSwatchCardState();
}

class _ColorSwatchCardState extends State<ColorSwatchCard> {
  bool _isHovering = false;
  bool _isPressed = false;

  Color _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final color = _parseHex(widget.swatch.hex);
    final luminance = color.computeLuminance();
    final textColor = luminance > 0.4 ? Colors.black87 : Colors.white;

    final double scale = _isPressed ? 0.98 : (_isHovering ? 1.02 : 1.0);
    final elevation = _isHovering && !widget.isAvoid ? AppElevations.level2(isDark) : AppElevations.level1(isDark);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (widget.onTap != null) widget.onTap!();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(scale, scale),
          transformAlignment: Alignment.center,
          width: 160,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppShapes.card,
            boxShadow: elevation,
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.gray200,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              if (widget.isAvoid)
                Positioned(
                  top: AppSpacing.s12,
                  right: AppSpacing.s12,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Symbols.close, color: textColor, size: 16),
                  ),
                ),

              if (!widget.isAvoid)
                Positioned(
                  top: AppSpacing.s12,
                  right: AppSpacing.s12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: AppShapes.chip,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Symbols.check, color: textColor, size: 12),
                        const SizedBox(width: AppSpacing.s4),
                        Text(
                          'Best',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppShapes.radiusCard),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.swatch.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.swatch.hex.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
