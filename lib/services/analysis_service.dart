import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image/image.dart' as img;

import '../models/analysis_result.dart';
import '../engine/face_regions.dart';
import '../engine/skin_classifier.dart';
import 'color_database.dart';

// ── Custom Exceptions ────────────────────────────────────────────────────────
class NoFaceDetectedException implements Exception {
  final String message;
  const NoFaceDetectedException([this.message = 'No face detected.']);
  @override
  String toString() => message;
}

class ImageProcessingException implements Exception {
  final String message;
  const ImageProcessingException([this.message = 'Error processing image.']);
  @override
  String toString() => message;
}

// ── Isolate Payload ──────────────────────────────────────────────────────────
class _IsolateData {
  final String imagePath;
  final List<IntPoint> meshPoints;
  final int faceTop;

  _IsolateData(
    this.imagePath,
    this.meshPoints,
    this.faceTop,
  );
}

// ── Analysis Service (Local ML) ──────────────────────────────────────────────
class AnalysisService {
  AnalysisService._();

  static final FaceMeshDetector _meshDetector = FaceMeshDetector(
    option: FaceMeshDetectorOptions.faceMesh,
  );

  static Future<AnalysisResult> analyze(File imageFile) async {
    await colorDatabase.load();

    // 1. Run ML Kit Face Mesh detection.
    final inputImage = InputImage.fromFile(imageFile);
    final List<FaceMesh> meshes = await _meshDetector.processImage(inputImage);

    if (meshes.isEmpty) {
      throw const NoFaceDetectedException('Could not detect a face. Try a clearer photo.');
    }

    final FaceMesh mesh = meshes.first;

    // 2. Extract 468 mesh points in pixel coordinates
    List<IntPoint> meshPoints = mesh.points.map((p) => IntPoint(p.x.toInt(), p.y.toInt())).toList();

    // 3. Process heavy pixel math in an isolate.
    final _IsolateData payload = _IsolateData(
      imageFile.path,
      meshPoints,
      mesh.boundingBox.top.toInt(),
    );

    final ClassificationResult classification = await compute(_processImageInIsolate, payload);

    final recommendations = colorDatabase.getRecommendations(
      classification.tone,
      classification.undertone,
    );

    const List<String> monkColors = [
      "#f6ede4", "#f3e7db", "#f7ead0", "#eadaba", "#d7bd96",
      "#a07e56", "#825c43", "#604134", "#3a312a", "#292420"
    ];

    return AnalysisResult(
      tone: classification.tone,
      undertone: classification.undertone,
      toneConfidence: classification.toneConfidence,
      utConfidence: classification.utConfidence,
      bestColors: recommendations['best'] ?? [],
      avoidColors: recommendations['avoid'] ?? [],
      monkColors: monkColors,
    );
  }

  static Future<ClassificationResult> _processImageInIsolate(_IsolateData data) async {
    final bytes = await File(data.imagePath).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw const ImageProcessingException('Could not decode the image file.');
    }
    // bakeOrientation physically rotates pixels to DISPLAY orientation,
    // which matches where ML Kit's landmark coordinates point.
    image = img.bakeOrientation(image);

    final extractor = RegionExtractor(data.meshPoints);

    return SkinClassifier.classify(image, extractor, data.faceTop);
  }

  static Future<bool> checkHealth() async => true;
}
