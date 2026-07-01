import 'dart:math' as math;

/// Core math for CIE Delta E 2000 and color conversions.
/// Replicates the logic from Python's colormath package.

class LabColor {
  final double l;
  final double a;
  final double b;

  const LabColor(this.l, this.a, this.b);

  @override
  String toString() => 'LabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

/// Convert normalized RGB (0-1) to Lab using Illuminant D65.
LabColor rgbToLab(double r, double g, double b) {
  // sRGB to Linear RGB
  double pivotRgb(double n) {
    return (n > 0.04045) ? math.pow((n + 0.055) / 1.055, 2.4).toDouble() : n / 12.92;
  }

  double R = pivotRgb(r) * 100.0;
  double G = pivotRgb(g) * 100.0;
  double B = pivotRgb(b) * 100.0;

  // Linear RGB to XYZ
  double x = R * 0.4124564 + G * 0.3575761 + B * 0.1804375;
  double y = R * 0.2126729 + G * 0.7151522 + B * 0.0721750;
  double z = R * 0.0193339 + G * 0.1191920 + B * 0.9503041;

  // XYZ to Lab (D65 references: X=95.047, Y=100.000, Z=108.883)
  double pivotXyz(double n) {
    return (n > 0.008856) ? math.pow(n, 1 / 3).toDouble() : (7.787 * n) + (16 / 116);
  }

  x = pivotXyz(x / 95.047);
  y = pivotXyz(y / 100.000);
  z = pivotXyz(z / 108.883);

  double l = math.max(0.0, (116 * y) - 16);
  double a = 500 * (x - y);
  double bVal = 200 * (y - z);

  return LabColor(l, a, bVal);
}

/// Calculates the Delta E CIE2000 distance between two Lab colors.
double deltaE2000(LabColor lab1, LabColor lab2) {
  final double l1 = lab1.l;
  final double a1 = lab1.a;
  final double b1 = lab1.b;

  final double l2 = lab2.l;
  final double a2 = lab2.a;
  final double b2 = lab2.b;

  final double c1 = math.sqrt(a1 * a1 + b1 * b1);
  final double c2 = math.sqrt(a2 * a2 + b2 * b2);

  final double meanC = (c1 + c2) / 2.0;

  final double g = 0.5 * (1 - math.sqrt(math.pow(meanC, 7) / (math.pow(meanC, 7) + math.pow(25.0, 7))));

  final double a1p = a1 * (1 + g);
  final double a2p = a2 * (1 + g);

  final double c1p = math.sqrt(a1p * a1p + b1 * b1);
  final double c2p = math.sqrt(a2p * a2p + b2 * b2);

  double h1p = (c1p == 0) ? 0 : math.atan2(b1, a1p) * 180 / math.pi;
  if (h1p < 0) h1p += 360;

  double h2p = (c2p == 0) ? 0 : math.atan2(b2, a2p) * 180 / math.pi;
  if (h2p < 0) h2p += 360;

  final double meanLp = (l1 + l2) / 2.0;
  final double meanCp = (c1p + c2p) / 2.0;

  double meanHp;
  if (c1p == 0 || c2p == 0) {
    meanHp = h1p + h2p;
  } else if ((h1p - h2p).abs() <= 180) {
    meanHp = (h1p + h2p) / 2.0;
  } else if (h1p + h2p < 360) {
    meanHp = (h1p + h2p + 360) / 2.0;
  } else {
    meanHp = (h1p + h2p - 360) / 2.0;
  }

  final double deltaLp = l2 - l1;
  final double deltaCp = c2p - c1p;

  double deltaHp;
  if (c1p == 0 || c2p == 0) {
    deltaHp = 0;
  } else if ((h2p - h1p).abs() <= 180) {
    deltaHp = h2p - h1p;
  } else if (h2p <= h1p) {
    deltaHp = h2p - h1p + 360;
  } else {
    deltaHp = h2p - h1p - 360;
  }
  deltaHp = 2 * math.sqrt(c1p * c2p) * math.sin((deltaHp / 2.0) * math.pi / 180);

  final double t = 1 -
      0.17 * math.cos((meanHp - 30) * math.pi / 180) +
      0.24 * math.cos((2 * meanHp) * math.pi / 180) +
      0.32 * math.cos((3 * meanHp + 6) * math.pi / 180) -
      0.20 * math.cos((4 * meanHp - 63) * math.pi / 180);

  final double deltaTheta = 30 * math.exp(-math.pow((meanHp - 275) / 25, 2));

  final double rc = 2 * math.sqrt(math.pow(meanCp, 7) / (math.pow(meanCp, 7) + math.pow(25.0, 7)));

  final double sl = 1 + (0.015 * math.pow(meanLp - 50, 2)) / math.sqrt(20 + math.pow(meanLp - 50, 2));
  final double sc = 1 + 0.045 * meanCp;
  final double sh = 1 + 0.015 * meanCp * t;
  final double rt = -math.sin(2 * deltaTheta * math.pi / 180) * rc;

  final double kl = 1.0;
  final double kc = 1.0;
  final double kh = 1.0;

  final double value = math.sqrt(
      math.pow(deltaLp / (kl * sl), 2) +
      math.pow(deltaCp / (kc * sc), 2) +
      math.pow(deltaHp / (kh * sh), 2) +
      rt * (deltaCp / (kc * sc)) * (deltaHp / (kh * sh)));

  return value;
}

/// Converts RGB (0-255) to YCrCb (0-255).
/// Returns a list [Y, Cr, Cb].
List<int> rgbToYCrCb(int r, int g, int b) {
  // OpenCV standard YCrCb conversion matrix
  // Y = 0.299*R + 0.587*G + 0.114*B
  // Cr = (R - Y)*0.713 + 128
  // Cb = (B - Y)*0.564 + 128
  
  double y = 0.299 * r + 0.587 * g + 0.114 * b;
  double cr = (r - y) * 0.713 + 128;
  double cb = (b - y) * 0.564 + 128;

  int yInt = y.round().clamp(0, 255);
  int crInt = cr.round().clamp(0, 255);
  int cbInt = cb.round().clamp(0, 255);

  return [yInt, crInt, cbInt];
}

/// Converts RGB (0-255) to HSV.
/// H is 0-360, S is 0-100, V is 0-255 (to match OpenCV's 8-bit scale).
/// Note: OpenCV normally scales H 0-179 and S 0-255. Here we use standard H(0-360), S(0-100), V(0-255)
/// but we must adjust the Python threshold logic which expects S in 0-255 if it was using OpenCV's `COLOR_RGB2HSV`.
/// Wait, Python's skin_tone.py used: S = hsv[...,1], which in OpenCV uint8 is 0-255.
/// We will return [H(0-179), S(0-255), V(0-255)] to exactly match OpenCV output.
List<int> rgbToHsvOpenCV(int r, int g, int b) {
  double rNorm = r / 255.0;
  double gNorm = g / 255.0;
  double bNorm = b / 255.0;

  double maxC = math.max(rNorm, math.max(gNorm, bNorm));
  double minC = math.min(rNorm, math.min(gNorm, bNorm));
  double delta = maxC - minC;

  double h = 0;
  if (delta > 0) {
    if (maxC == rNorm) {
      h = 60 * (((gNorm - bNorm) / delta) % 6);
    } else if (maxC == gNorm) {
      h = 60 * (((bNorm - rNorm) / delta) + 2);
    } else if (maxC == bNorm) {
      h = 60 * (((rNorm - gNorm) / delta) + 4);
    }
  }

  if (h < 0) {
    h += 360;
  }

  double s = maxC == 0 ? 0 : delta / maxC;
  double v = maxC;

  // OpenCV uint8 ranges: H = 0-179, S = 0-255, V = 0-255
  int hOut = (h / 2).round().clamp(0, 179);
  int sOut = (s * 255).round().clamp(0, 255);
  int vOut = (v * 255).round().clamp(0, 255);

  return [hOut, sOut, vOut];
}

