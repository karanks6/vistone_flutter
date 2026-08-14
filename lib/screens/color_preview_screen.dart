import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/color_swatch.dart' as models;
import '../widgets/design_system.dart';

class ColorPreviewScreen extends StatelessWidget {
  final models.ColorSwatch swatch;
  final bool isAvoid;
  final String undertone;

  const ColorPreviewScreen({
    super.key,
    required this.swatch,
    required this.isAvoid,
    required this.undertone,
  });

  Color _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseHex(swatch.hex);
    final luminance = color.computeLuminance();
    final onColor = luminance > 0.4 ? Colors.black87 : Colors.white;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: color,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(LucideIcons.arrowLeft, color: onColor, size: 24),
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                  child: Column(
                    children: [
                      Text(
                        swatch.name,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: onColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GestureDetector(
                        onTap: () async {
                          await FlutterClipboard.copy(swatch.hex);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${swatch.hex} copied to clipboard'),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                swatch.hex.toUpperCase(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: onColor.withValues(alpha: 0.9),
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Icon(LucideIcons.copy, color: onColor.withValues(alpha: 0.7), size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      Text(
                        isAvoid
                            ? 'This color may clash with ${undertone.toLowerCase()} undertones and wash out your complexion.'
                            : 'This color harmonizes beautifully with ${undertone.toLowerCase()} undertones, bringing out a natural glow.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: onColor.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
