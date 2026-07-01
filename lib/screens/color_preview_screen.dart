import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/color_swatch.dart' as models;
import '../theme/app_theme.dart';

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
    final color = _parseHex(swatch.hex);
    final luminance = color.computeLuminance();
    final onColor = luminance > 0.35 ? Colors.black87 : Colors.white;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen color background
          Container(
            color: color,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: onColor, size: 20),
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        swatch.name,
                        style: TextStyle(
                          color: onColor,
                          fontSize: 32,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          await FlutterClipboard.copy(swatch.hex);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${swatch.hex} copied to clipboard'),
                                backgroundColor: VistoneColors.bgCard,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                swatch.hex.toUpperCase(),
                                style: TextStyle(
                                  color: onColor.withValues(alpha: 0.9),
                                  fontSize: 16,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.copy,
                                  color: onColor.withValues(alpha: 0.7),
                                  size: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isAvoid
                            ? 'This color may clash with ${undertone.toLowerCase()} undertones and wash out your complexion.'
                            : 'This color harmonizes beautifully with ${undertone.toLowerCase()} undertones, bringing out a natural glow.',
                        style: TextStyle(
                          color: onColor.withValues(alpha: 0.8),
                          fontSize: 16,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
