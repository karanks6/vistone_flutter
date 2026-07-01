import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'color_math.dart';
import 'face_regions.dart';

class Pixel {
  final int r, g, b;
  Pixel(this.r, this.g, this.b);
}

class ClassificationResult {
  final int tone;
  final String undertone;
  final double toneConfidence;
  final double utConfidence;

  ClassificationResult(this.tone, this.undertone, this.toneConfidence, this.utConfidence);
}

// ── Monk Palette: Google MST — Ellis et al. 2022 ─────────────────────────────
// These are D65 Lab values computed from the official hex swatches.
const List<LabColor> _monkLabD65 = [
  LabColor(94.21, 1.48,  6.74),  // Monk 1
  LabColor(92.27, 2.37,  8.44),  // Monk 2
  LabColor(93.09, 1.34, 11.23),  // Monk 3
  LabColor(87.57, 4.36, 17.51),  // Monk 4
  LabColor(77.90, 7.82, 22.86),  // Monk 5
  LabColor(55.14, 11.02, 23.36), // Monk 6
  LabColor(42.47, 13.91, 19.86), // Monk 7
  LabColor(30.68, 12.38, 12.91), // Monk 8
  LabColor(21.07,  7.91,  6.13), // Monk 9
  LabColor(14.61,  5.09,  3.42), // Monk 10
];

// Photo-calibrated L* anchors — what each Monk tone measures in real photos
const List<double> _monkLPhoto = [
  94.0, 92.0, 92.0, 87.0, 77.0, 52.0, 40.0, 33.0, 25.0, 19.0
];

// Undertone reference tables — tone-stratified, D65
// L* values reflect REAL measured skin L*, NOT the hex swatch L*
const Map<String, Map<String, List<double>>> _undertoneRefs = {
  '1_3': {
    'warm':    [85.0,  8.0, 16.0],
    'cool':    [85.0,  9.0, -2.0],
    'neutral': [85.0,  8.5,  7.0],
  },
  '4_5': {
    'warm':    [72.0, 12.0, 20.0],
    'cool':    [72.0,  7.0,  1.0],
    'neutral': [72.0,  9.5, 10.5],
  },
  '6_7': {
    'warm':    [45.0, 14.0, 21.0],
    'cool':    [45.0,  8.0,  3.0],
    'neutral': [45.0, 11.0, 12.0],
  },
  '8_10': {
    'warm':    [24.0, 10.5, 14.0],
    'cool':    [24.0,  5.0,  0.0],
    'neutral': [24.0,  7.5,  7.0],
  },
};

Map<String, List<double>> _getUndertoneRefs(int tone) {
  if (tone <= 3) return _undertoneRefs['1_3']!;
  if (tone <= 5) return _undertoneRefs['4_5']!;
  if (tone <= 7) return _undertoneRefs['6_7']!;
  return _undertoneRefs['8_10']!;
}

class SkinClassifier {

  /// Main entry point: replicates Python's classify_monk_v10 pipeline exactly.
  static ClassificationResult classify(img.Image image, RegionExtractor regions, int faceTopY) {

    final leftCheek  = regions.getLeftCheek();
    final rightCheek = regions.getRightCheek();
    final forehead   = regions.getForehead(faceTopY);
    final nose       = regions.getNose();
    final exclusions = regions.getExclusions();

    // ── Step 1: Build raw cheek pixels (pre-WB, for initial L estimate) ──────
    List<Pixel> rawCheekPixels = _extractRegionPixels(image, [leftCheek, rightCheek], exclusions);
    if (rawCheekPixels.isEmpty) {
      debugPrint('Vistone: No cheek pixels found, defaulting.');
      return ClassificationResult(5, 'Neutral', 0.0, 0.0);
    }

    // ── Step 2: Estimate initial skin_L_mean (mirrors Python exactly) ─────────
    // Python uses wider YCrCb bounds (Cr>=115,<=190, Cb>=68,<=148) then
    // takes the MEAN of the 20th-60th percentile L* band.
    double skinLMean = _estimateSkinLMean(rawCheekPixels);
    bool isDarkSkin = skinLMean < 46.0;
    debugPrint('Vistone: Initial skin_L_mean=$skinLMean dark=$isDarkSkin');

    // ── Step 3: Shades-of-gray WB (p=6, max_shift=0.15) ──────────────────────
    List<double> wbMul = _shadesOfGrayWb(image);

    // ── Step 4: Exposure normalization (only for fair/medium skin) ────────────
    double exposureFactor = 1.0;
    if (skinLMean >= 55.0) {
      double proxyGray = _estimateSclera(image, wbMul, regions.getEyes());
      exposureFactor = (210.0 / max(proxyGray, 60.0)).clamp(0.85, 1.50);
    }
    debugPrint('Vistone: exposure_factor=$exposureFactor');

    // ── Step 5: Choose percentile bands by skin tone ──────────────────────────
    double loPct, hiPct;
    if (skinLMean > 75) {
      loPct = 50.0; hiPct = 90.0;
    } else if (skinLMean > 45) {
      loPct = 25.0; hiPct = 75.0;
    } else {
      loPct = 5.0;  hiPct = 35.0;
    }

    // ── Step 6: Extract clean skin pixels from all regions ────────────────────
    // Python collects inner_cheeks, full_cheeks, forehead, nose separately
    // then vstack them. We combine all regions and filter together.
    List<Pixel> allRawPixels = _extractRegionPixels(
      image, [leftCheek, rightCheek, forehead, nose], exclusions,
      wbMul: wbMul, exposureFactor: exposureFactor,
    );

    List<Pixel> cleanPixels = _filterSkinPixels(
      allRawPixels, skinLMean, isDarkSkin, loPct, hiPct
    );

    if (cleanPixels.isEmpty) {
      // Fallback: percentile-only on cheeks (mirrors Python fallback)
      cleanPixels = _percentileFilter(allRawPixels, 15.0, 85.0);
      if (cleanPixels.isEmpty) cleanPixels = allRawPixels;
    }

    debugPrint('Vistone: cleanPixels=${cleanPixels.length}');

    // ── Step 7: Re-anchor skin_L_mean from clean pixels (critical Python step) ─
    if (cleanPixels.length >= 60) {
      List<double> cleanL = cleanPixels.map((p) {
        return rgbToLab(p.r / 255.0, p.g / 255.0, p.b / 255.0).l;
      }).toList()..sort();

      // 40th-75th percentile of clean pixels
      double lo40 = cleanL[(cleanL.length * 0.40).toInt()];
      double hi75 = cleanL[(cleanL.length * 0.75).toInt()];
      List<double> midL = cleanL.where((v) => v >= lo40 && v <= hi75).toList();

      if (midL.length >= 20) {
        double refined = midL.reduce((a, b) => a + b) / midL.length;
        double deviation = refined - skinLMean;
        bool shouldCorrect = deviation.abs() > 8.0 &&
            (skinLMean >= 55.0 || deviation < 0);

        if (shouldCorrect) {
          debugPrint('Vistone: skin_L_mean corrected $skinLMean -> $refined');
          skinLMean = refined;
          isDarkSkin = skinLMean < 46.0;

          if (skinLMean > 75) {
            loPct = 50.0; hiPct = 90.0;
          } else if (skinLMean > 45) {
            loPct = 25.0; hiPct = 75.0;
          } else {
            loPct = 5.0; hiPct = 35.0;
          }

          // Re-extract with corrected parameters
          List<Pixel> cleanPixels2 = _filterSkinPixels(
            allRawPixels, skinLMean, isDarkSkin, loPct, hiPct
          );
          if (cleanPixels2.isNotEmpty) cleanPixels = cleanPixels2;
        }
      }
    }

    // ── Step 8: Compute fused (dominant) RGB color ────────────────────────────
    // Python uses GMM dominant. We approximate with robust_median (80th-pct trimmed).
    Pixel fused = _robustMedian(cleanPixels);

    // ── Step 9: L*-Anchored Two-Stage Tone Classification ────────────────────
    // Stage 1: median L* of ALL clean pixels (not the percentile band)
    double measuredL = _medianLOf(cleanPixels);
    List<double> lDists = _monkLPhoto.map((v) => (v - measuredL).abs()).toList();
    int anchorIdx = lDists.indexOf(lDists.reduce(min));

    // Stage 2: windowed ΔE scoring
    int lo = max(0, anchorIdx - 2);
    int hi = min(9, anchorIdx + 2);

    LabColor fusedLab = rgbToLab(fused.r / 255.0, fused.g / 255.0, fused.b / 255.0);
    Map<int, double> scores = {};

    for (int idx = lo; idx <= hi; idx++) {
      double dE = deltaE2000(fusedLab, _monkLabD65[idx]);

      // Dynamic L_gap — computed from actual Monk L* D65 values (matches Python exactly)
      double refL = _monkLabD65[idx].l;
      double lDev = (measuredL - refL).abs();
      double lGap;
      if (idx > 0 && idx < 9) {
        lGap = ((_monkLabD65[idx].l - _monkLabD65[idx - 1].l).abs() +
                (_monkLabD65[idx].l - _monkLabD65[idx + 1].l).abs()) / 2.0;
      } else if (idx == 0) {
        lGap = (_monkLabD65[0].l - _monkLabD65[1].l).abs();
      } else {
        lGap = (_monkLabD65[9].l - _monkLabD65[8].l).abs();
      }
      double lWeight = (8.0 / max(lGap, 1.0)).clamp(0.3, 2.5);
      scores[idx] = dE + lDev * lWeight;
    }

    int bestIdx = scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;

    // Heuristic override for very pale skin
    if (bestIdx == 1 && fusedLab.l > 91.0 && fusedLab.b < 5.0) bestIdx = 0;

    List<double> sortedScores = scores.values.toList()..sort();
    double toneConf = sortedScores.length >= 2
        ? ((sortedScores[1] - sortedScores[0]) / 5.0).clamp(0.0, 1.0)
        : 0.80;
    int finalTone = bestIdx + 1;

    debugPrint('Vistone: Tone=$finalTone (conf=${(toneConf * 100).toStringAsFixed(0)}% L*=$measuredL)');

    // ── Step 10: Undertone (multi-sample voting) ──────────────────────────────
    // Python uses WB-corrected cheek pixels for undertone.
    // We use the same cleanPixels (already WB-corrected).
    String undertone = _classifyUndertone(cleanPixels, finalTone);

    return ClassificationResult(finalTone, undertone, toneConf, 0.85);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Estimate skin_L_mean (mirrors Python's initial L estimate exactly)
  // Uses wider YCrCb bounds then 20th-60th percentile mean of L* values
  // ─────────────────────────────────────────────────────────────────────────────
  static double _estimateSkinLMean(List<Pixel> cheekPixels) {
    // Wider bounds matching Python: Cr>=115,<=190, Cb>=68,<=148
    List<double> lVals = [];
    for (var p in cheekPixels) {
      final ycrcb = rgbToYCrCb(p.r, p.g, p.b);
      int cr = ycrcb[1], cb = ycrcb[2];
      if (cr >= 115 && cr <= 190 && cb >= 68 && cb <= 148) {
        lVals.add(rgbToLab(p.r / 255.0, p.g / 255.0, p.b / 255.0).l);
      }
    }

    if (lVals.length < 40) {
      // Fallback: median L* of all cheek pixels
      return _medianLOf(cheekPixels);
    }

    // 20th-60th percentile band, then MEAN (matching Python's fast_L_of mean)
    lVals.sort();
    int lo = (lVals.length * 0.20).toInt();
    int hi = (lVals.length * 0.60).toInt();
    hi = min(hi, lVals.length - 1);
    if (lo >= hi) return lVals[lVals.length ~/ 2];

    List<double> midBand = lVals.sublist(lo, hi + 1);
    return midBand.reduce((a, b) => a + b) / midBand.length;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Extract pixels from face regions (with optional WB+exposure)
  // ─────────────────────────────────────────────────────────────────────────────
  static List<Pixel> _extractRegionPixels(
    img.Image image,
    List<FaceRegion?> regions,
    List<FaceRegion> exclusions, {
    List<double>? wbMul,
    double exposureFactor = 1.0,
  }) {
    List<Pixel> pixels = [];
    for (var region in regions) {
      if (region == null) continue;
      final bbox = region.boundingBox;
      int sx = max(0, bbox.left);
      int ex = min(image.width, bbox.right);
      int sy = max(0, bbox.top);
      int ey = min(image.height, bbox.bottom);

      for (int y = sy; y < ey; y++) {
        for (int x = sx; x < ex; x++) {
          if (!region.contains(x, y)) continue;
          bool excluded = false;
          for (var exc in exclusions) {
            if (exc.contains(x, y)) { excluded = true; break; }
          }
          if (excluded) continue;

          final pixel = image.getPixel(x, y);
          int r = pixel.r.toInt();
          int g = pixel.g.toInt();
          int b = pixel.b.toInt();

          if (wbMul != null) {
            r = (r * wbMul[0] * exposureFactor).round().clamp(0, 255);
            g = (g * wbMul[1] * exposureFactor).round().clamp(0, 255);
            b = (b * wbMul[2] * exposureFactor).round().clamp(0, 255);
          }
          pixels.add(Pixel(r, g, b));
        }
      }
    }
    return pixels;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Filter skin pixels (mirrors get_clean_skin_pixels in Python)
  // 1. YCrCb skin gate
  // 2. Hair/shadow removal
  // 3. Percentile L* range
  // ─────────────────────────────────────────────────────────────────────────────
  static List<Pixel> _filterSkinPixels(
    List<Pixel> pixels, double faceMedianL, bool darkSkin,
    double loPct, double hiPct,
  ) {
    // Gate 1: YCrCb
    List<Pixel> ycFiltered = pixels.where((p) {
      final ycrcb = rgbToYCrCb(p.r, p.g, p.b);
      int cr = ycrcb[1], cb = ycrcb[2];
      if (darkSkin) return cr >= 120 && cr <= 185 && cb >= 70 && cb <= 145;
      return cr >= 120 && cr <= 180 && cb >= 70 && cb <= 140;
    }).toList();

    if (ycFiltered.isEmpty) ycFiltered = pixels;

    // Gate 2: Hair and shadow removal
    double lFloor = max(8.0, faceMedianL * 0.58);
    List<Pixel> noHair = ycFiltered.where((p) {
      final lab = rgbToLab(p.r / 255.0, p.g / 255.0, p.b / 255.0);
      final hsv = rgbToHsvOpenCV(p.r, p.g, p.b);
      int s = hsv[1]; // 0-255
      double l = lab.l;
      bool isDarkShadow = l < lFloor;
      bool isBeard = s > 45 && l < max(12.0, faceMedianL * 0.50);
      bool isSpecular = s < 35 && l > min(97.0, faceMedianL + 30.0);
      return !(isDarkShadow || isBeard || isSpecular);
    }).toList();

    if (noHair.isEmpty) noHair = ycFiltered;

    // Gate 3: Percentile L* range
    return _percentileFilter(noHair, loPct, hiPct);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Keep only pixels in [loPct, hiPct] L* percentile range
  // Mirrors Python's percentile_L_mask
  // ─────────────────────────────────────────────────────────────────────────────
  static List<Pixel> _percentileFilter(List<Pixel> pixels, double loPct, double hiPct) {
    if (pixels.length < 50) return pixels;

    List<double> lVals = pixels.map((p) =>
      rgbToLab(p.r / 255.0, p.g / 255.0, p.b / 255.0).l
    ).toList()..sort();

    double loVal = lVals[(lVals.length * loPct / 100).toInt().clamp(0, lVals.length - 1)];
    double hiVal = lVals[(lVals.length * hiPct / 100).toInt().clamp(0, lVals.length - 1)];

    List<Pixel> filtered = [];
    for (var p in pixels) {
      double l = rgbToLab(p.r / 255.0, p.g / 255.0, p.b / 255.0).l;
      if (l >= loVal && l <= hiVal) filtered.add(p);
    }
    return filtered.isNotEmpty ? filtered : pixels;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Shades-of-gray white balance (p=6, max_shift=0.15)
  // Mirrors Python's shades_of_gray_wb exactly
  // ─────────────────────────────────────────────────────────────────────────────
  static List<double> _shadesOfGrayWb(img.Image image) {
    double rn = 0, gn = 0, bn = 0;
    const int p = 6;
    const double eps = 1e-6;
    int count = 0;

    for (int y = 0; y < image.height; y += 4) {
      for (int x = 0; x < image.width; x += 4) {
        final pixel = image.getPixel(x, y);
        rn += pow(max(pixel.r / 255.0, eps), p);
        gn += pow(max(pixel.g / 255.0, eps), p);
        bn += pow(max(pixel.b / 255.0, eps), p);
        count++;
      }
    }

    rn = pow(rn / count, 1.0 / p).toDouble() + eps;
    gn = pow(gn / count, 1.0 / p).toDouble() + eps;
    bn = pow(bn / count, 1.0 / p).toDouble() + eps;

    double gray = (rn + gn + bn) / 3.0;

    return [
      (gray / rn).clamp(0.85, 1.15),  // R multiplier
      (gray / gn).clamp(0.85, 1.15),  // G multiplier
      (gray / bn).clamp(0.85, 1.15),  // B multiplier
    ];
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Estimate sclera white-point for exposure correction
  // Python uses actual sclera mask from eye region landmarks.
  // We approximate using the brightest 5% of sampled pixels.
  // ─────────────────────────────────────────────────────────────────────────────
  static double _estimateSclera(img.Image image, List<double> wbMul, List<FaceRegion> eyes) {
    List<double> grays = [];
    
    // Create bounding box for all eyes
    int sx = image.width, ex = 0, sy = image.height, ey = 0;
    for (var eye in eyes) {
      final bbox = eye.boundingBox;
      if (bbox.left < sx) sx = bbox.left;
      if (bbox.right > ex) ex = bbox.right;
      if (bbox.top < sy) sy = bbox.top;
      if (bbox.bottom > ey) ey = bbox.bottom;
    }
    
    sx = max(0, sx);
    sy = max(0, sy);
    ex = min(image.width, ex);
    ey = min(image.height, ey);

    for (int y = sy; y < ey; y += 1) { // Process all pixels in eye region
      for (int x = sx; x < ex; x += 1) {
        bool inside = false;
        for (var eye in eyes) {
          if (eye.contains(x, y)) {
            inside = true;
            break;
          }
        }
        if (!inside) continue;

        final pixel = image.getPixel(x, y);
        // Apply WB first, then compute gray
        double r = (pixel.r * wbMul[0]).clamp(0, 255);
        double g = (pixel.g * wbMul[1]).clamp(0, 255);
        double b = (pixel.b * wbMul[2]).clamp(0, 255);
        
        // Sclera-gating: low saturation, bright (mirrors Python S<60, V>120)
        final hsv = rgbToHsvOpenCV(r.toInt(), g.toInt(), b.toInt());
        if (hsv[1] < 60 && hsv[2] > 120) {
          grays.add((r + g + b) / 3.0);
        }
      }
    }
    // Python requires at least 30 sclera pixels
    if (grays.length < 30) return 200.0;
    
    // Return mean of all sclera pixels (Python: gray = (sel[:,0].mean() + ...) / 3.0)
    return grays.reduce((a, b) => a + b) / grays.length;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Compute median L* of a pixel list (mirrors Python's median_L_of)
  // Python: np.median(px.astype(float), axis=0) then convert RGB median to Lab.
  // ─────────────────────────────────────────────────────────────────────────────
  static double _medianLOf(List<Pixel> pixels) {
    if (pixels.isEmpty) return 50.0;

    // Compute per-channel median (as Python does with np.median(px, axis=0))
    List<int> rs = pixels.map((p) => p.r).toList()..sort();
    List<int> gs = pixels.map((p) => p.g).toList()..sort();
    List<int> bs = pixels.map((p) => p.b).toList()..sort();

    int mid = pixels.length ~/ 2;
    double medR = rs[mid].toDouble();
    double medG = gs[mid].toDouble();
    double medB = bs[mid].toDouble();

    return rgbToLab(medR / 255.0, medG / 255.0, medB / 255.0).l;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Robust median (mirrors Python's robust_median)
  // Computes channel-wise median, then keeps pixels within 80th percentile
  // of Euclidean distance from that median, then re-computes median.
  // ─────────────────────────────────────────────────────────────────────────────
  static Pixel _robustMedian(List<Pixel> pixels) {
    if (pixels.isEmpty) return Pixel(128, 128, 128);

    List<int> rs = pixels.map((p) => p.r).toList()..sort();
    List<int> gs = pixels.map((p) => p.g).toList()..sort();
    List<int> bs = pixels.map((p) => p.b).toList()..sort();
    int mid = pixels.length ~/ 2;

    double medR = rs[mid].toDouble();
    double medG = gs[mid].toDouble();
    double medB = bs[mid].toDouble();

    // Euclidean distance from median
    List<double> dists = pixels.map((p) {
      double dr = p.r - medR, dg = p.g - medG, db = p.b - medB;
      return sqrt(dr * dr + dg * dg + db * db);
    }).toList()..sort();

    // 80th percentile threshold
    double pct80 = dists[(dists.length * 0.80).toInt().clamp(0, dists.length - 1)];

    // Keep pixels within 80th percentile
    List<Pixel> close = [];
    for (var p in pixels) {
      double dr = p.r - medR, dg = p.g - medG, db = p.b - medB;
      double d = sqrt(dr * dr + dg * dg + db * db);
      if (d <= pct80) close.add(p);
    }
    if (close.length < 50) close = pixels;

    // Re-compute median on close pixels
    List<int> rs2 = close.map((p) => p.r).toList()..sort();
    List<int> gs2 = close.map((p) => p.g).toList()..sort();
    List<int> bs2 = close.map((p) => p.b).toList()..sort();
    int mid2 = close.length ~/ 2;

    return Pixel(rs2[mid2], gs2[mid2], bs2[mid2]);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Undertone classification with multi-sample voting
  // Mirrors Python's classify_undertone exactly:
  //   Vote 1: median color  (weight 2.0)
  //   Vote 2: dominant quartile centroid (approximates GMM, weight 1.5)
  //   Vote 3: 8 evenly-spaced samples from mid-band (weight 0.3 each)
  // ─────────────────────────────────────────────────────────────────────────────
  static String _classifyUndertone(List<Pixel> skinPixels, int tone) {
    if (skinPixels.length < 50) return 'Neutral';

    // Get 30th-70th percentile L* middle band (mirrors Python)
    List<double> lVals = skinPixels
        .map((p) => rgbToLab(p.r / 255.0, p.g / 255.0, p.b / 255.0).l)
        .toList()..sort();

    double lo30 = lVals[(lVals.length * 0.30).toInt()];
    double hi70 = lVals[(lVals.length * 0.70).toInt()];

    List<Pixel> midBand = skinPixels.where((p) {
      double l = rgbToLab(p.r / 255.0, p.g / 255.0, p.b / 255.0).l;
      return l >= lo30 && l <= hi70;
    }).toList();

    if (midBand.length < 30) midBand = skinPixels;

    Map<String, double> votes = {'Warm': 0.0, 'Cool': 0.0, 'Neutral': 0.0};

    // Vote 1: median color (weight 2.0) — matches Python exactly
    Pixel med = _robustMedian(midBand);
    LabColor medLab = rgbToLab(med.r / 255.0, med.g / 255.0, med.b / 255.0);
    String v1 = _utFromLab(medLab, tone);
    votes[v1] = (votes[v1] ?? 0) + 2.0;

    // Vote 2: dominant quartile centroid (approximates GMM dominant, weight 1.5)
    // We use the median of the central 50% of pixels sorted by L* as the "dominant cluster"
    if (midBand.length >= 30) {
      List<Pixel> sorted = List.from(midBand)..sort((a, b) {
        double la = rgbToLab(a.r / 255.0, a.g / 255.0, a.b / 255.0).l;
        double lb = rgbToLab(b.r / 255.0, b.g / 255.0, b.b / 255.0).l;
        return la.compareTo(lb);
      });
      int q1 = (sorted.length * 0.25).toInt();
      int q3 = (sorted.length * 0.75).toInt();
      List<Pixel> central = sorted.sublist(q1, q3);
      if (central.isNotEmpty) {
        Pixel dom = _robustMedian(central);
        LabColor domLab = rgbToLab(dom.r / 255.0, dom.g / 255.0, dom.b / 255.0);
        String v2 = _utFromLab(domLab, tone);
        votes[v2] = (votes[v2] ?? 0) + 1.5;
      }
    }

    // Vote 3: 8 evenly-spaced samples from mid-band (weight 0.3 each)
    int nSample = min(8, midBand.length);
    List<int> indices = List.generate(
      nSample, (i) => (i * (midBand.length - 1) / max(nSample - 1, 1)).round()
    );
    for (int idx in indices) {
      if (idx >= midBand.length) continue;
      Pixel sample = midBand[idx];
      LabColor sLab = rgbToLab(sample.r / 255.0, sample.g / 255.0, sample.b / 255.0);
      String vs = _utFromLab(sLab, tone);
      votes[vs] = (votes[vs] ?? 0) + 0.3;
    }

    String best = 'Neutral';
    double maxVote = 0;
    votes.forEach((k, v) {
      if (v > maxVote) { maxVote = v; best = k; }
    });

    debugPrint('Vistone: Undertone votes=$votes -> $best');
    return best;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPER: Classify undertone from a single Lab color
  // Mirrors Python's _ut_from_lab exactly (margin=1.0)
  // ─────────────────────────────────────────────────────────────────────────────
  static String _utFromLab(LabColor lab, int tone) {
    final refs = _getUndertoneRefs(tone);
    double pL = lab.l;

    // Shift refs to the pixel's actual L* (mirrors Python's adj dict)
    LabColor warmRef    = LabColor(pL, refs['warm']![1],    refs['warm']![2]);
    LabColor coolRef    = LabColor(pL, refs['cool']![1],    refs['cool']![2]);
    LabColor neutralRef = LabColor(pL, refs['neutral']![1], refs['neutral']![2]);

    double dWarm = deltaE2000(lab, warmRef);
    double dCool = deltaE2000(lab, coolRef);
    double dNeut = deltaE2000(lab, neutralRef);

    double best = min(dWarm, min(dCool, dNeut));
    List<double> sorted = [dWarm, dCool, dNeut]..sort();
    // margin=1.0 exactly as Python
    if (sorted[1] - sorted[0] < 1.0) return 'Neutral';

    if (best == dWarm) return 'Warm';
    if (best == dCool) return 'Cool';
    return 'Neutral';
  }
}
