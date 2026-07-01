import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/analysis_provider.dart';
import '../models/analysis_result.dart';
import '../theme/app_theme.dart';
import '../widgets/monk_scale_slider.dart';
import '../widgets/color_swatch_card.dart';
import '../widgets/confidence_bar.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final selectedImage = ref.watch(selectedImageProvider);

    if (state is! AnalysisSuccess) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: VistoneColors.bgGradient),
          child: const Center(
            child: CircularProgressIndicator(color: VistoneColors.brand1),
          ),
        ),
      );
    }

    final result = state.result;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: VistoneColors.bgGradient),
        child: Stack(
          children: [
            // Hero photo
            if (selectedImage != null)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.52,
                width: double.infinity,
                child: Image.file(selectedImage, fit: BoxFit.cover),
              ),

            // Photo gradient fade
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.58,
              width: double.infinity,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.55, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      VistoneColors.bgDark,
                    ],
                  ),
                ),
              ),
            ),

            // Back button
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 20),
                ),
                onPressed: () => context.go('/home'),
              ),
            ),

            // Draggable Result Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.45,
              maxChildSize: 0.95,
              builder: (_, scrollCtrl) => Container(
                decoration: const BoxDecoration(
                  color: VistoneColors.bgDark,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: CustomScrollView(
                  controller: scrollCtrl,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: VistoneColors.textMuted
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _GradientBadge('Monk ${result.tone}'),
                                    const SizedBox(width: 10),
                                    _UndertoneChip(result: result),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                MonkScaleSlider(
                                  monkColors: result.monkColors,
                                  detectedTone: result.tone,
                                ),
                                const SizedBox(height: 20),

                                ConfidenceBar(
                                    label: 'Tone confidence',
                                    value: result.toneConfidence),
                                const SizedBox(height: 12),
                                ConfidenceBar(
                                    label: 'Undertone confidence',
                                    value: result.utConfidence),

                                if (!result.isHighConfidence)
                                  Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: VistoneColors.warning
                                          .withValues(alpha: 0.12),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border: Border.all(
                                          color: VistoneColors.warning
                                              .withValues(alpha: 0.3)),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.warning_amber_outlined,
                                            color: VistoneColors.warning,
                                            size: 18),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Try a clearer photo in natural daylight for best accuracy.',
                                            style: TextStyle(
                                                color: VistoneColors.warning,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                const SizedBox(height: 28),

                                _SectionHeader(
                                    title: 'Your Best Colors', emoji: '✨'),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: result.bestColors.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (ctx, i) => ColorSwatchCard(
                                      swatch: result.bestColors[i],
                                      onTap: () => context.push(
                                        '/color-preview',
                                        extra: {
                                          'swatch': result.bestColors[i],
                                          'isAvoid': false,
                                          'undertone': result.undertone,
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                _SectionHeader(
                                    title: 'Colors to Avoid', emoji: '🚫'),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: result.avoidColors.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (ctx, i) => ColorSwatchCard(
                                      swatch: result.avoidColors[i],
                                      isAvoid: true,
                                      onTap: () => context.push(
                                        '/color-preview',
                                        extra: {
                                          'swatch': result.avoidColors[i],
                                          'isAvoid': true,
                                          'undertone': result.undertone,
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 28),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                        Icons.add_a_photo_outlined),
                                    label: const Text(
                                        'Analyze Another Photo'),
                                    onPressed: () {
                                      ref
                                          .read(analysisProvider.notifier)
                                          .reset();
                                      context.go('/home');
                                    },
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientBadge extends StatelessWidget {
  final String text;
  const _GradientBadge(this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: VistoneColors.brandGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: VistoneColors.brand1.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700)),
      );
}

class _UndertoneChip extends StatelessWidget {
  final AnalysisResult result;
  const _UndertoneChip({required this.result});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: VistoneColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.12), width: 1),
        ),
        child: Text(
          '${result.undertoneEmoji} ${result.undertone}',
          style: const TextStyle(
              color: VistoneColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title, emoji;
  const _SectionHeader({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 18)),
        ],
      );
}
