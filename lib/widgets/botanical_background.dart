import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dart:math' as math;

/// A custom widget that draws elegant, organic botanical branches 
/// (similar to the provided design inspiration) as a background decoration.
class BotanicalBackground extends StatelessWidget {
  final Widget child;
  final bool showTopRight;
  final bool showBottomLeft;
  final double opacity;

  const BotanicalBackground({
    super.key,
    required this.child,
    this.showTopRight = true,
    this.showBottomLeft = true,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color / content can go behind if needed, but here we just draw on top of nothing
        Positioned.fill(
          child: CustomPaint(
            painter: _BotanicalPainter(
              color: AppColors.sageGreen.withValues(alpha: opacity),
              showTopRight: showTopRight,
              showBottomLeft: showBottomLeft,
            ),
          ),
        ),
        // Foreground content determines the size
        child,
      ],
    );
  }
}

class _BotanicalPainter extends CustomPainter {
  final Color color;
  final bool showTopRight;
  final bool showBottomLeft;

  _BotanicalPainter({
    required this.color,
    required this.showTopRight,
    required this.showBottomLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Use a base scale relative to a standard screen width of 400
    final double baseScale = size.width / 400.0;

    if (showBottomLeft) {
      canvas.save();
      // Move to bottom left
      canvas.translate(0, size.height);
      canvas.scale(baseScale, baseScale);
      // The default path draws up-right (+x, -y). We just tilt it slightly.
      _drawBranch(canvas, paint, angle: 0.2);
      canvas.restore();
    }

    if (showTopRight) {
      canvas.save();
      // Move to top right
      canvas.translate(size.width, 0);
      canvas.scale(baseScale, baseScale);
      // The default path draws up-right. To make it draw down-left (-x, +y) from the top right, rotate by ~180 deg (pi).
      _drawBranch(canvas, paint, angle: math.pi - 0.2);
      canvas.restore();
    }
  }

  void _drawBranch(Canvas canvas, Paint paint, {required double angle}) {
    canvas.rotate(angle);

    // Draw the main stem
    final stemPath = Path();
    stemPath.moveTo(0, 0);
    // Control point 1, End point 1
    stemPath.quadraticBezierTo(50, -100, 150, -300);
    stemPath.lineTo(145, -300);
    // Curve back down to make it thick
    stemPath.quadraticBezierTo(45, -100, -5, 0);
    canvas.drawPath(stemPath, paint);

    // Draw leaves
    // Left leaf
    _drawLeaf(canvas, paint, dx: 30, dy: -80, angle: -0.5, size: 1.0);
    // Right leaf
    _drawLeaf(canvas, paint, dx: 70, dy: -140, angle: 0.7, size: 1.2);
    // Left leaf
    _drawLeaf(canvas, paint, dx: 100, dy: -210, angle: -0.3, size: 0.9);
    // Top leaf
    _drawLeaf(canvas, paint, dx: 145, dy: -290, angle: 0.1, size: 1.1);
  }

  void _drawLeaf(Canvas canvas, Paint paint, {required double dx, required double dy, required double angle, required double size}) {
    canvas.save();
    canvas.translate(dx, dy);
    canvas.rotate(angle);
    canvas.scale(size);

    final path = Path();
    path.moveTo(0, 0);
    // Curve up to the tip
    path.quadraticBezierTo(-40, -40, 0, -100);
    // Curve back down to the base
    path.quadraticBezierTo(40, -40, 0, 0);
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
