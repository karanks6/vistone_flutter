import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: VistoneColors.bgGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: VistoneColors.textPrimary),
                  onPressed: () => context.pop(),
                ),
                title: const Text('About'),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Hero
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: VistoneColors.glassMorphism.copyWith(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (b) =>
                                VistoneColors.brandGradient.createShader(b),
                            child: const Text(
                              'Vistone',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Discover the colors that love you back.',
                            style: TextStyle(
                                color: VistoneColors.textMuted,
                                fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _InfoCard(
                      emoji: '🎯',
                      title: 'What is Vistone?',
                      body:
                          'Vistone is an AI-powered personal color analysis tool. It uses advanced computer vision to analyze your skin tone from a selfie and recommend clothing colors that scientifically complement your complexion — the same analysis used by professional stylists.',
                    ),

                    const SizedBox(height: 16),

                    _InfoCard(
                      emoji: '🧬',
                      title: 'The Google Monk Scale',
                      body:
                          'Vistone classifies skin tones using the Google Monk Skin Tone Scale — a 10-shade scale developed by Ellis et al. (2022) to provide broader, more inclusive skin tone representation than older scales like Fitzpatrick.',
                    ),

                    const SizedBox(height: 16),

                    _InfoCard(
                      emoji: '🤖',
                      title: 'How the AI Works',
                      body:
                          'MediaPipe Face Mesh detects 468 facial landmarks. The algorithm samples skin pixels from your upper cheeks, forehead, and nose — explicitly excluding eyes, eyebrows, and facial hair. Two color correction steps normalize the lighting before classification.',
                    ),

                    const SizedBox(height: 16),

                    _InfoCard(
                      emoji: '🌈',
                      title: 'Seasonal Color Analysis',
                      body:
                          'Color recommendations are based on Seasonal Color Analysis (SCA), a professional framework used by image consultants. Your Monk tone and undertone (Cool/Warm/Neutral) are mapped to one of 12 seasonal archetypes to generate your palette.',
                    ),

                    const SizedBox(height: 32),

                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Try It Now'),
                        onPressed: () => context.go('/home'),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String emoji, title, body;
  const _InfoCard(
      {required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: VistoneColors.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      color: VistoneColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Text(body,
              style: const TextStyle(
                  color: VistoneColors.textSecondary,
                  fontSize: 14,
                  height: 1.6)),
        ],
      ),
    );
  }
}
