import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

class UploadBottomSheet extends ConsumerWidget {
  const UploadBottomSheet({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 94);
    if (pickedFile == null || !context.mounted) return;

    context.pop();
    final image = File(pickedFile.path);
    ref.read(selectedImageProvider.notifier).state = image;
    ref.read(analysisProvider.notifier).reset();
    context.push('/analyzing');
    ref.read(analysisProvider.notifier).analyze(image);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.nightSurfaceRaised : AppColors.surface;
    return Container(
      margin: const EdgeInsets.only(top: 80),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: dark ? AppColors.nightMuted.withValues(alpha: .45) : AppColors.lineStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text('Let’s see your\nnatural colouring.', style: Theme.of(context).textTheme.displaySmall)
                  .animate()
                  .fadeIn(duration: 340.ms)
                  .slideY(begin: .08),
              const SizedBox(height: 9),
              Text(
                'Choose a clear, filter-free photo. We only use it to create this analysis.',
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 26),
              _SourceOption(
                icon: LucideIcons.camera,
                title: 'Take a photo',
                detail: 'Use your camera in natural light',
                onTap: () => _pickImage(context, ref, ImageSource.camera),
              ).animate().fadeIn(delay: 160.ms).slideX(begin: .05),
              const SizedBox(height: 12),
              _SourceOption(
                icon: LucideIcons.image,
                title: 'Choose from library',
                detail: 'Use a recent, unedited photo',
                onTap: () => _pickImage(context, ref, ImageSource.gallery),
              ).animate().fadeIn(delay: 220.ms).slideX(begin: .05),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Icon(LucideIcons.lock, size: 14, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Private by design · Your image is processed on this device.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? AppColors.nightSurface : AppColors.canvas,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconContainer(icon: icon, backgroundColor: AppColors.surfaceClay, iconColor: AppColors.clay),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(detail, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(LucideIcons.arrowUpRight, size: 20, color: AppColors.forest),
            ],
          ),
        ),
      ),
    );
  }
}
