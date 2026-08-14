import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dotted_border/dotted_border.dart';
import 'design_system.dart';

class UploadZone extends StatefulWidget {
  final void Function(File file) onImagePicked;

  const UploadZone({super.key, required this.onImagePicked});

  @override
  State<UploadZone> createState() => _UploadZoneState();
}

class _UploadZoneState extends State<UploadZone> with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  bool _isHovering = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 1200,
    );
    if (picked != null) {
      widget.onImagePicked(File(picked.path));
    }
  }

  void _showSourceSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s32),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Upload Photo',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),
                _SheetOption(
                  icon: Symbols.camera,
                  label: 'Take a Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ).animate().slideX(begin: -0.1, duration: 400.ms, curve: Curves.easeOutQuad).fadeIn(),
                const SizedBox(height: AppSpacing.s12),
                _SheetOption(
                  icon: Symbols.photo_library,
                  label: 'Choose from Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ).animate().slideX(begin: -0.1, duration: 400.ms, delay: 100.ms, curve: Curves.easeOutQuad).fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderPurple;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          _showSourceSheet(context);
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Spring scale effect
            final scale = 1.0 - (_controller.value * 0.02);
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(24),
                color: borderColor,
                strokeWidth: 1.5,
                dashPattern: const [8, 8],
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cloud Icon Button
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.7),
                            theme.colorScheme.primary,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(
                        Symbols.cloud_upload,
                        color: Colors.white,
                        size: 32,
                      ),
                    ).animate(target: _isHovering ? 1 : 0).scaleXY(end: 1.05, duration: 200.ms),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Upload your photo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'JPG, PNG or WebP',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Max 10MB',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Choose Photo Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9070D9), // Dark Purple
                            Color(0xFFB19CD9), // Light Purple
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9070D9).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Symbols.photo_camera, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Choose Photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray800 : AppColors.gray50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.gray700 : AppColors.gray200,
            )
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Symbols.chevron_right, color: isDark ? AppColors.gray600 : AppColors.gray400),
            ],
          ),
        ),
      ),
    );
  }
}
