import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, WidgetRef;
import '../providers/analysis_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/upload_zone.dart';
import 'dart:io';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _tips = [
    ('☀️', 'Natural Light', 'Step near a window for best accuracy.'),
    ('👤', 'Face the Camera', 'Look directly at the lens.'),
    ('🚫', 'No Filters', 'Remove beauty or color filters.'),
    ('💧', 'Clean Skin', 'Remove heavy makeup for best results.'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: VistoneColors.bgGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                backgroundColor: Colors.transparent,
                title: ShaderMask(
                  shaderCallback: (b) =>
                      VistoneColors.brandGradient.createShader(b),
                  child: const Text(
                    'Vistone',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.info_outline,
                        color: VistoneColors.textMuted),
                    onPressed: () => context.push('/about'),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 12),
                    Text(
                      'Find Your\nPerfect Palette',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload a selfie to discover the colors\nthat complement your skin tone.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    UploadZone(
                      onImagePicked: (file) =>
                          _startAnalysis(context, ref, file),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'TIPS FOR BEST RESULTS',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tips.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) => _TipCard(
                          emoji: _tips[i].$1,
                          title: _tips[i].$2,
                          body: _tips[i].$3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const _HowItWorks(),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startAnalysis(
      BuildContext context, WidgetRef ref, File file) async {
    ref.read(selectedImageProvider.notifier).state = file;
    ref.read(analysisProvider.notifier).reset();
    context.push('/analyzing');
    await ref.read(analysisProvider.notifier).analyze(file);
  }
}

class _TipCard extends StatelessWidget {
  final String emoji, title, body;
  const _TipCard(
      {required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(14),
      decoration: VistoneColors.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(
                  color: VistoneColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(body,
              style: const TextStyle(
                  color: VistoneColors.textMuted, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatefulWidget {
  const _HowItWorks();

  @override
  State<_HowItWorks> createState() => _HowItWorksState();
}

class _HowItWorksState extends State<_HowItWorks> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: VistoneColors.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('How does it work?',
                style: TextStyle(
                    color: VistoneColors.textPrimary,
                    fontWeight: FontWeight.w600)),
            trailing: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: VistoneColors.textMuted,
            ),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'Vistone uses AI-powered facial landmark detection to sample pure skin pixels from your cheeks, forehead, and nose. It corrects for lighting conditions, then classifies your skin using the Google Monk Skin Tone Scale and identifies your undertone (Cool, Warm, or Neutral). Finally, it maps your combination to a professional Seasonal Color Analysis palette.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}
