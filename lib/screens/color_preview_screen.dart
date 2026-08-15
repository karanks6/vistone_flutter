import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/color_swatch.dart' as models;
import '../widgets/design_system.dart';

class ColorPreviewScreen extends StatefulWidget {
  final models.ColorSwatch swatch;
  final bool isAvoid;
  final String undertone;

  const ColorPreviewScreen({
    super.key,
    required this.swatch,
    required this.isAvoid,
    required this.undertone,
  });

  @override
  State<ColorPreviewScreen> createState() => _ColorPreviewScreenState();
}

class _ColorPreviewScreenState extends State<ColorPreviewScreen> {
  bool _copied = false;

  Color get _color {
    final hex = widget.swatch.hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }

  Future<void> _copy() async {
    await FlutterClipboard.copy(widget.swatch.hex.toUpperCase());
    if (!mounted) return;
    HapticFeedback.selectionClick();
    setState(() => _copied = true);
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final lightColor = color.computeLuminance() > .44;
    final foreground = lightColor ? AppColors.ink : AppColors.textInverse;
    final muted = foreground.withValues(alpha: .72);
    final tag = 'swatch-${widget.swatch.hex}-${widget.isAvoid}';
    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppIconButton(
                    icon: LucideIcons.arrowLeft,
                    semanticLabel: 'Return to palette',
                    onTap: () => context.pop(),
                    inverted: true,
                  ),
                  const Spacer(),
                  Text(
                    widget.isAvoid ? 'PAUSE ON THIS' : 'A SHADE FOR YOU',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: muted),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              Hero(
                tag: tag,
                child: Material(
                  color: Colors.transparent,
                  child: _ColorForm(color: color, foreground: foreground),
                ),
              ),
              const SizedBox(height: 34),
              Text(widget.swatch.name, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: foreground))
                  .animate()
                  .fadeIn(duration: 420.ms)
                  .slideY(begin: .10),
              const SizedBox(height: 14),
              Text(
                widget.isAvoid
                    ? 'This shade can compete with the natural ${widget.undertone.toLowerCase()} balance in your colouring. Try it away from your face instead.'
                    : 'This shade sits beautifully with your natural ${widget.undertone.toLowerCase()} balance and can make your complexion feel more luminous.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: muted),
              ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
              const SizedBox(height: 24),
              Material(
                color: foreground.withValues(alpha: .13),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: InkWell(
                  onTap: _copy,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            _copied ? LucideIcons.check : LucideIcons.copy,
                            key: ValueKey(_copied),
                            size: 18,
                            color: foreground,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _copied ? 'COPIED' : widget.swatch.hex.toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: foreground, letterSpacing: 1.1),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _copied ? '' : 'TAP TO COPY',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 220.ms).slideY(begin: .08),
              const Spacer(),
              Row(
                children: [
                  Container(width: 38, height: 1, color: muted),
                  const SizedBox(width: 10),
                  Text('VISTONE COLOUR NOTE', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: muted)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorForm extends StatelessWidget {
  final Color color;
  final Color foreground;
  const _ColorForm({required this.color, required this.foreground});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 176,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 176,
              height: 176,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: foreground.withValues(alpha: .28)),
              ),
            ),
            Container(
              width: 126,
              height: 126,
              decoration: BoxDecoration(
                color: foreground.withValues(alpha: .16),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(72),
                  topRight: Radius.circular(72),
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(72),
                ),
              ),
            ),
            Container(width: 44, height: 44, decoration: BoxDecoration(color: foreground, shape: BoxShape.circle)),
          ],
        ),
      );
}
