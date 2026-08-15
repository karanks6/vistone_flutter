import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analysisProvider);
    final image = ref.watch(selectedImageProvider);
    final stage = state is AnalysisLoading ? state.stage : 'Preparing your analysis...';
    final stageIndex = _indexFor(stage);

    ref.listen<AnalysisState>(analysisProvider, (previous, next) {
      if (!mounted) return;
      if (next is AnalysisSuccess) {
        context.go('/result');
      } else if (next is AnalysisError) {
        _showError(next.message);
      }
    });

    return Scaffold(
      body: AppPageBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    AppIconButton(
                      icon: LucideIcons.arrowLeft,
                      semanticLabel: 'Cancel analysis',
                      onTap: () => context.go('/home'),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reading your palette', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Text('A moment of colour science.', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSage,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text('LIVE', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.forest)),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ScanView(controller: _scanController, image: image)
                            .animate()
                            .fadeIn(duration: 450.ms)
                            .scale(begin: const Offset(.97, .97), curve: Curves.easeOutCubic),
                        const SizedBox(height: 28),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          child: Column(
                            key: ValueKey(stage),
                            children: [
                              Text(stage, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 6),
                              Text(
                                'We’re mapping light, hue and skin-tone information.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        _AnalysisSteps(activeIndex: stageIndex),
                        const SizedBox(height: 18),
                        _PrivacyNote(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _indexFor(String stage) {
    const stages = [
      'Detecting face landmarks...',
      'Correcting lighting...',
      'Sampling skin pixels...',
      'Classifying skin tone...',
    ];
    return stages.indexOf(stage).clamp(0, stages.length - 1);
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Let’s try that again', style: Theme.of(dialogContext).textTheme.titleLarge),
        content: Text(message, style: Theme.of(dialogContext).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go('/home');
            },
            child: const Text('Choose another photo'),
          ),
        ],
      ),
    );
  }
}

class _ScanView extends StatelessWidget {
  final Animation<double> controller;
  final dynamic image;

  const _ScanView({required this.controller, required this.image});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .86,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.forestDeep,
          borderRadius: BorderRadius.circular(AppRadii.hero),
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.hero),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image.file(image as dynamic, fit: BoxFit.cover)
              else
                Container(
                  color: AppColors.surfaceSage,
                  child: const Icon(LucideIcons.user, size: 80, color: AppColors.sage),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.forestDeep.withValues(alpha: .10),
                      AppColors.forestDeep.withValues(alpha: .42),
                    ],
                  ),
                ),
              ),
              const Positioned.fill(child: _ScanCorners()),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) => Align(
                  alignment: Alignment(0, -1 + controller.value * 2),
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 26),
                    decoration: BoxDecoration(
                      color: AppColors.marigold,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: [BoxShadow(color: AppColors.marigold.withValues(alpha: .9), blurRadius: 16, spreadRadius: 2)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 18,
                left: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.ink.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(color: AppColors.textInverse.withValues(alpha: .16)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.marigold, shape: BoxShape.circle)),
                      const SizedBox(width: 7),
                      Text('ANALYSIS IN PROGRESS', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textInverse)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanCorners extends StatelessWidget {
  const _ScanCorners();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(22),
        child: Stack(
          children: const [
            Align(alignment: Alignment.topLeft, child: _Corner(rotation: 0)),
            Align(alignment: Alignment.topRight, child: _Corner(rotation: 1)),
            Align(alignment: Alignment.bottomRight, child: _Corner(rotation: 2)),
            Align(alignment: Alignment.bottomLeft, child: _Corner(rotation: 3)),
          ],
        ),
      );
}

class _Corner extends StatelessWidget {
  final int rotation;
  const _Corner({required this.rotation});
  @override
  Widget build(BuildContext context) => RotatedBox(
        quarterTurns: rotation,
        child: Container(
          height: 26,
          width: 26,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.textInverse, width: 2),
              left: BorderSide(color: AppColors.textInverse, width: 2),
            ),
          ),
        ),
      );
}

class _AnalysisSteps extends StatelessWidget {
  final int activeIndex;
  const _AnalysisSteps({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    const steps = ['Face map', 'Light balance', 'Skin sample', 'Palette match'];
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: dark ? AppColors.nightLine : AppColors.line),
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final done = index < activeIndex;
          final active = index == activeIndex;
          return Padding(
            padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: done || active ? AppColors.forest : (dark ? AppColors.nightSurface : AppColors.surfaceMuted),
                    shape: BoxShape.circle,
                  ),
                  child: done
                      ? const Icon(LucideIcons.check, size: 13, color: AppColors.textInverse)
                      : active
                          ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.8, color: AppColors.textInverse))
                          : Text('${index + 1}', style: Theme.of(context).textTheme.labelSmall),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(steps[index], style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: active || done ? null : AppColors.textTertiary))),
                if (done)
                  Text('Done', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success))
                else if (active)
                  Text('Working', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.forest)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(LucideIcons.shieldCheck, size: 17, color: AppColors.success),
          const SizedBox(width: 9),
          Expanded(child: Text('Your photo is analysed locally and is never saved or shared.', style: Theme.of(context).textTheme.bodySmall)),
        ],
      );
}
