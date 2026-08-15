import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  bool _pressed = false;

  Color _color() {
    final hex = widget.swatch.hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final foreground = color.computeLuminance() > .43 ? AppColors.ink : AppColors.textInverse;
    final tag = 'swatch-${widget.swatch.hex}-${widget.isAvoid}';
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? .96 : 1,
        child: Hero(
          tag: tag,
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            child: Container(
              width: 158,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: foreground.withValues(alpha: .16)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: .94), color],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: foreground.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Text(
                          widget.isAvoid ? 'SKIP' : 'WEAR',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground),
                        ),
                      ),
                      Icon(widget.isAvoid ? LucideIcons.minus : LucideIcons.arrowUpRight, size: 16, color: foreground),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    widget.swatch.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: foreground),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.swatch.hex.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground.withValues(alpha: .78)),
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
