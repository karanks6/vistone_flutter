import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

class UploadBottomSheet extends ConsumerWidget {
  const UploadBottomSheet({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null && context.mounted) {
      context.pop(); // Close bottom sheet
      
      final file = File(pickedFile.path);
      ref.read(selectedImageProvider.notifier).state = file;
      ref.read(analysisProvider.notifier).reset();
      
      context.push('/analyzing');
      // Intentionally don't await so the UI can transition immediately
      ref.read(analysisProvider.notifier).analyze(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadii.sheet),
          topRight: Radius.circular(AppRadii.sheet),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, AppSpacing.hero),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.textDisabled.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            'Upload a Photo',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          _UploadOptionCard(
            icon: LucideIcons.camera,
            title: 'Take a Photo',
            subtitle: 'Use your camera for a new selfie',
            onTap: () => _pickImage(context, ref, ImageSource.camera),
          ),
          const SizedBox(height: AppSpacing.lg),
          _UploadOptionCard(
            icon: LucideIcons.image,
            title: 'Choose from Gallery',
            subtitle: 'Pick an existing photo',
            onTap: () => _pickImage(context, ref, ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

class _UploadOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UploadOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.surfaceLavender,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }
}
