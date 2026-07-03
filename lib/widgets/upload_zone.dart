import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'design_system.dart';

class UploadZone extends StatefulWidget {
  final void Function(File file) onImagePicked;

  const UploadZone({super.key, required this.onImagePicked});

  @override
  State<UploadZone> createState() => _UploadZoneState();
}

class _UploadZoneState extends State<UploadZone> {
  final _picker = ImagePicker();
  bool _isHovering = false;
  bool _isPressed = false;

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
      backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: AppShapes.bottomSheet),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.s32),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray700 : AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Upload Photo',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.s32),
              _SheetOption(
                icon: Symbols.camera,
                label: 'Take a Photo',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              _SheetOption(
                icon: Symbols.photo_library,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Subtle scaling for press effect
    final double scale = _isPressed ? 0.98 : (_isHovering ? 1.01 : 1.0);
    
    final borderColor = isDark ? AppColors.gray700 : AppColors.gray300;
    final hoverBorderColor = theme.colorScheme.primary;
    final bgColor = _isHovering 
        ? (isDark ? AppColors.gray800 : AppColors.gray100)
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _showSourceSheet(context);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(scale, scale),
          transformAlignment: Alignment.center,
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppShapes.card,
            border: Border.all(
              color: _isHovering ? hoverBorderColor : borderColor,
              width: _isHovering ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray800 : AppColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Symbols.add_photo_alternate,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'Upload your photo',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'JPG, PNG or WebP',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
              ),
            ],
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

    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
      tileColor: isDark ? AppColors.gray800 : AppColors.gray100,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s4),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
      ),
      trailing: Icon(Symbols.chevron_right, color: isDark ? AppColors.gray600 : AppColors.gray400),
    );
  }
}
