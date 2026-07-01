import 'package:flutter/material.dart';
import '../models/color_swatch.dart' as models;

class ColorSwatchCard extends StatelessWidget {
  final models.ColorSwatch swatch;
  final bool isAvoid;
  final VoidCallback? onTap;

  const ColorSwatchCard({
    super.key,
    required this.swatch,
    this.isAvoid = false,
    this.onTap,
  });

  Color _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseHex(swatch.hex);
    final luminance = color.computeLuminance();
    final textColor = luminance > 0.35 ? Colors.black87 : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isAvoid)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: textColor, size: 14),
                ),
              ),

            if (!isAvoid)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Best ✓',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ),
              ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      swatch.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      swatch.hex.toUpperCase(),
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.75),
                        fontSize: 11,
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
    );
  }
}
