import 'dart:math';

/// Represents a 2D point.
class IntPoint {
  final int x, y;
  const IntPoint(this.x, this.y);
}

/// Represents a bounding polygon on the face.
class FaceRegion {
  final List<IntPoint> points;
  FaceRegion(this.points);

  Rectangle<int> get boundingBox {
    if (points.isEmpty) return const Rectangle(0, 0, 0, 0);
    int minX = points.first.x, maxX = points.first.x;
    int minY = points.first.y, maxY = points.first.y;
    for (var p in points) {
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }
    return Rectangle(minX, minY, maxX - minX, maxY - minY);
  }

  /// Ray-casting point-in-polygon test.
  bool contains(int x, int y) {
    if (points.isEmpty) return false;
    bool inside = false;
    for (int i = 0, j = points.length - 1; i < points.length; j = i++) {
      final xi = points[i].x, yi = points[i].y;
      final xj = points[j].x, yj = points[j].y;
      final intersect = ((yi > y) != (yj > y)) &&
          (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }
    return inside;
  }
}

/// Sort polygon points by angle around centroid → produces proper convex polygon order.
FaceRegion convexSortedPolygon(List<IntPoint> points) {
  if (points.length < 3) return FaceRegion(points);
  double cx = points.map((p) => p.x.toDouble()).reduce((a, b) => a + b) / points.length;
  double cy = points.map((p) => p.y.toDouble()).reduce((a, b) => a + b) / points.length;
  final sorted = List<IntPoint>.from(points)
    ..sort((a, b) {
      double angleA = atan2((a.y - cy), (a.x - cx));
      double angleB = atan2((b.y - cy), (b.x - cx));
      return angleA.compareTo(angleB);
    });
  return FaceRegion(sorted);
}

/// Offsets a polygon by an absolute pixel amount.
/// Positive values dilate (expand), negative values erode (shrink).
/// This perfectly mirrors OpenCV's cv2.dilate and cv2.erode behavior
/// where the kernel size determines an absolute pixel offset regardless of face size.
FaceRegion offsetPolygon(FaceRegion region, double pixelOffset) {
  if (region.points.length < 3) return region;
  
  // Calculate Area (Shoelace formula)
  double area = 0.0;
  for (int i = 0; i < region.points.length; i++) {
    int j = (i + 1) % region.points.length;
    area += region.points[i].x * region.points[j].y;
    area -= region.points[j].x * region.points[i].y;
  }
  area = area.abs() / 2.0;

  // Approximate radius of the polygon
  double r = sqrt(area / pi);
  if (r == 0) return region;

  // Calculate proportional scale factor to achieve the exact pixel offset
  double scaleFactor = (r + pixelOffset) / r;

  // Prevent complete inversion on extreme erosion
  if (scaleFactor < 0.1) scaleFactor = 0.1;

  double cx = 0, cy = 0;
  for (var p in region.points) {
    cx += p.x;
    cy += p.y;
  }
  cx /= region.points.length;
  cy /= region.points.length;

  return FaceRegion(region.points.map((p) {
    return IntPoint(
      (cx + (p.x - cx) * scaleFactor).toInt(),
      (cy + (p.y - cy) * scaleFactor).toInt(),
    );
  }).toList());
}

// ─────────────────────────────────────────────────────────────────────────────
// RegionExtractor using 468-point Face Mesh (1:1 with Python web app)
//
// We now use the exact same MediaPipe indices used in Python's skin_tone.py
// so the geometric selection is mathematically identical.
// ─────────────────────────────────────────────────────────────────────────────
class RegionExtractor {
  final List<IntPoint> meshPoints;

  RegionExtractor(this.meshPoints);

  // Exact MediaPipe indices from skin_tone.py v12.0
  static const List<int> _upperLeftCheek = [234, 93, 132, 116, 117, 118, 119, 120, 121, 128];
  static const List<int> _upperRightCheek = [454, 323, 361, 345, 346, 347, 348, 349, 350, 357];
  static const List<int> _foreheadPoly = [10, 338, 297, 332, 284, 251, 389];
  static const List<int> _nosePoly = [6, 197, 195, 5, 4, 45, 220, 218, 237, 1];
  
  static const List<int> _leftEyeRing = [33, 7, 163, 144, 145, 153, 154, 155, 133, 173, 157, 158, 159, 160, 161, 246];
  static const List<int> _rightEyeRing = [263, 249, 390, 373, 374, 380, 381, 382, 362, 398, 384, 385, 386, 387, 388, 466];
  static const List<int> _leftEyeFull = [..._leftEyeRing, 130, 247, 30, 29, 27];
  static const List<int> _rightEyeFull = [..._rightEyeRing, 359, 467, 260, 259, 257];

  static const List<int> _mouthOut = [61, 146, 91, 181, 84, 17, 314, 405, 321, 375, 291, 308];
  static const List<int> _leftEyebrow = [70, 63, 105, 66, 107, 55, 65, 52, 53, 46];
  static const List<int> _rightEyebrow = [300, 293, 334, 296, 336, 285, 295, 282, 283, 276];

  List<IntPoint> _getPoints(List<int> indices) {
    if (meshPoints.length < 468) return [];
    return indices.where((i) => i < meshPoints.length).map((i) => meshPoints[i]).toList();
  }

  FaceRegion? getLeftCheek() {
    final pts = _getPoints(_upperLeftCheek);
    if (pts.isEmpty) return null;
    // Python: cv2.erode(..., (8, 8)) => shrinks boundary by exactly 4 pixels
    return offsetPolygon(convexSortedPolygon(pts), -4.0);
  }

  FaceRegion? getRightCheek() {
    final pts = _getPoints(_upperRightCheek);
    if (pts.isEmpty) return null;
    // Python: cv2.erode(..., (8, 8)) => shrinks boundary by exactly 4 pixels
    return offsetPolygon(convexSortedPolygon(pts), -4.0);
  }

  FaceRegion? getForehead(int faceTopY) {
    final pts = _getPoints(_foreheadPoly);
    if (pts.isEmpty) return null;

    // Python logic: Remove top 18% (hairline) and bottom 20% (near eyebrows)
    int yTop = pts.map((p) => p.y).reduce(min);
    int yBot = pts.map((p) => p.y).reduce(max);
    int span = yBot - yTop;
    int hairlineClip = yTop + (span * 0.18).toInt();
    int eyebrowMargin = yBot - (span * 0.20).toInt();

    List<IntPoint> clipped = pts.where((p) => p.y >= hairlineClip && p.y <= eyebrowMargin).toList();
    if (clipped.isEmpty) return null;

    // Python: cv2.erode(..., (10, 10)) => shrinks boundary by exactly 5 pixels
    return offsetPolygon(convexSortedPolygon(clipped), -5.0);
  }

  FaceRegion? getNose() {
    final pts = _getPoints(_nosePoly);
    if (pts.isEmpty) return null;

    // Python logic: Remove top 30% of nose (bridge)
    int yTop = pts.map((p) => p.y).reduce(min);
    int yBot = pts.map((p) => p.y).reduce(max);
    int bridgeClip = yTop + ((yBot - yTop) * 0.30).toInt();

    List<IntPoint> clipped = pts.where((p) => p.y >= bridgeClip).toList();
    if (clipped.isEmpty) return null;

    // Python: cv2.erode(..., (6, 6)) => shrinks boundary by exactly 3 pixels
    return offsetPolygon(convexSortedPolygon(clipped), -3.0);
  }

  // ── SCLERA ZONES ────────────────────────────────────────────────────────
  List<FaceRegion> getEyes() {
    List<FaceRegion> eyes = [];
    final leftPts = _getPoints(_leftEyeFull);
    if (leftPts.isNotEmpty) {
      eyes.add(offsetPolygon(convexSortedPolygon(leftPts), 8.0));
    }
    final rightPts = _getPoints(_rightEyeFull);
    if (rightPts.isNotEmpty) {
      eyes.add(offsetPolygon(convexSortedPolygon(rightPts), 8.0));
    }
    return eyes;
  }

  // ── EXCLUSION ZONES ───────────────────────────────────────────────────────
  List<FaceRegion> getExclusions() {
    List<FaceRegion> exc = [];

    void addOffset(List<int> indices, double pixelOffset) {
      final pts = _getPoints(indices);
      if (pts.isNotEmpty) {
        exc.add(offsetPolygon(convexSortedPolygon(pts), pixelOffset));
      }
    }

    // Python: cv2.dilate(..., px=16) => expands by 8 pixels
    addOffset(_leftEyeFull, 8.0);
    addOffset(_rightEyeFull, 8.0);

    // Python: cv2.dilate(..., px=14) => expands by 7 pixels
    addOffset(_leftEyebrow, 7.0);
    addOffset(_rightEyebrow, 7.0);

    // Python: cv2.dilate(..., px=18) => expands by 9 pixels
    addOffset(_mouthOut, 9.0);

    return exc;
  }
}
