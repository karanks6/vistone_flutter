import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConfidenceBar extends StatefulWidget {
  final String label;
  final double value;

  const ConfidenceBar({super.key, required this.label, required this.value});

  @override
  State<ConfidenceBar> createState() => _ConfidenceBarState();
}

class _ConfidenceBarState extends State<ConfidenceBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _barColor(double v) {
    if (v >= 0.7) return VistoneColors.success;
    if (v >= 0.45) return VistoneColors.warning;
    return VistoneColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final pct = (_anim.value * 100).round();
        final color = _barColor(_anim.value);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label,
                    style: const TextStyle(
                        color: VistoneColors.textSecondary, fontSize: 13)),
                Text('$pct%',
                    style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: _anim.value,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ],
        );
      },
    );
  }
}
