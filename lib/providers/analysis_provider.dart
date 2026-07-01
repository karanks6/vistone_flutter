import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analysis_result.dart';
import '../services/analysis_service.dart';

// ── Analysis State ───────────────────────────────────────────────────────────
sealed class AnalysisState {
  const AnalysisState();
}

class AnalysisIdle extends AnalysisState {
  const AnalysisIdle();
}

class AnalysisLoading extends AnalysisState {
  final String stage;
  const AnalysisLoading({this.stage = 'Preparing...'});
}

class AnalysisSuccess extends AnalysisState {
  final AnalysisResult result;
  const AnalysisSuccess(this.result);
}

class AnalysisError extends AnalysisState {
  final String message;
  const AnalysisError(this.message);
}

// ── Notifier ─────────────────────────────────────────────────────────────────
class AnalysisNotifier extends StateNotifier<AnalysisState> {
  AnalysisNotifier() : super(const AnalysisIdle());

  Future<void> analyze(File imageFile) async {
    state = const AnalysisLoading(stage: 'Detecting face landmarks...');

    await Future.delayed(const Duration(milliseconds: 600));
    state = const AnalysisLoading(stage: 'Correcting lighting...');

    await Future.delayed(const Duration(milliseconds: 600));
    state = const AnalysisLoading(stage: 'Sampling skin pixels...');

    await Future.delayed(const Duration(milliseconds: 600));
    state = const AnalysisLoading(stage: 'Classifying skin tone...');

    try {
      final result = await AnalysisService.analyze(imageFile);
      state = AnalysisSuccess(result);
    } on NoFaceDetectedException catch (e) {
      state = AnalysisError(e.message);
    } on ImageProcessingException catch (e) {
      state = AnalysisError(e.message);
    } catch (e) {
      state = AnalysisError('Unexpected error: $e');
    }
  }

  void reset() {
    state = const AnalysisIdle();
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final analysisProvider =
    StateNotifierProvider<AnalysisNotifier, AnalysisState>(
  (ref) => AnalysisNotifier(),
);

// ── Selected Image Provider ───────────────────────────────────────────────────
final selectedImageProvider = StateProvider<File?>((ref) => null);
