import 'dart:math';

class IntPoint {
  final int x, y;
  const IntPoint(this.x, this.y);
}

class FaceRegion {
  final List<IntPoint> points;
  FaceRegion(this.points);
}

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

  // Approximate radius
  double r = sqrt(area / pi);
  
  if (r == 0) return region;

  // Calculate scale factor
  double scaleFactor = (r + pixelOffset) / r;

  // For erosion, if offset is too large, limit it to avoid self-intersection
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
