<div align="center">

# Vistone AI
### AI-Powered Personal Colour Palette Matcher

*Discover the colors that bring out your best.*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange?style=for-the-badge)](pubspec.yaml)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)](https://flutter.dev/multi-platform)

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [How It Works](#-how-it-works)
- [AI & Color Science](#-ai--color-science)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Color Recommendation Logic](#-color-recommendation-logic)
- [Design System](#-design-system)
- [Accessibility](#-accessibility)
- [Privacy & Security](#-privacy--security)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎨 Overview

**Vistone AI** is a sophisticated, privacy-first mobile application that uses on-device computer vision and color science to analyze a user's skin tone and recommend a personalized clothing color palette — all without sending a single pixel to a remote server.

The app identifies where your skin tone falls on the **Google Monk Skin Tone (MST) Scale** — a 10-shade, scientifically validated scale developed by Ellis et al. (2022) at Google — and pairs that with undertone detection (Warm / Cool / Neutral) to generate a uniquely tailored set of recommended and avoided clothing colors, grounded in professional **Seasonal Color Analysis (SCA)** methodology.

Whether you are a fashion enthusiast, a personal stylist, a photographer, or simply someone looking to build a wardrobe that enhances your natural complexion, Vistone AI delivers results that would otherwise require a consultation with a professional image consultant.

---

## ✨ Features

### Core
| Feature | Description |
|---|---|
| 📸 **Photo Analysis** | Capture a new selfie or upload from your gallery |
| 🤖 **On-Device ML** | 100% on-device analysis using Google ML Kit — no internet required |
| 🎨 **6 Best Colors** | Six precisely curated "wear" colors per skin tone × undertone combination |
| 🚫 **6 Avoid Colors** | Six scientifically-backed colors to avoid for your profile |
| 🔢 **Monk Scale Visualization** | Interactive 10-swatch visual showing your exact tone on the MST scale |
| 📊 **Confidence Scores** | Separate tone and undertone confidence percentages |
| 🌗 **Light & Dark Mode** | Full support for both themes with persistent user preference |
| 📋 **Hex Copy** | Tap any color swatch to copy the hex code to clipboard |
| 🧑‍💻 **Color Preview** | Full-screen immersive preview for each recommended color |

### UX & Design
| Feature | Description |
|---|---|
| 🌿 **Botanical UI** | Elegant organic leaf graphics on the splash and about screens |
| ⚡ **Smooth Animations** | Fade-in, slide, and scale animations throughout the app |
| 📱 **Fully Responsive** | Adaptive layout for any mobile screen size, safe area aware |
| 💾 **Persistent Theme** | Remembers your light/dark mode preference across restarts |
| 🌡️ **Low-light Warning** | Flags when lighting conditions may reduce accuracy |

---

## 📸 Screenshots

> *Running on Android — 1220 × 2712 px display*

| Splash Screen | Home Screen | Analyzing | Results |
|:---:|:---:|:---:|:---:|
| Botanical leaves & logo on warm sand background | Camera upload zone with tips | Live step-by-step progress | Monk scale + 6 best / 6 avoid swatches |

| Color Preview | Saved Palettes | About |
|:---:|:---:|:---:|
| Full-screen immersive swatch view | — | Botanical hero card + info cards |

---

## 🔬 How It Works

Vistone AI performs a **5-stage analysis pipeline**, all running on your device:

```
📷 Photo Input
     │
     ▼
┌─────────────────────────────────────┐
│  Stage 1 — Face Mesh Detection      │
│  Google ML Kit FaceMesh (468 pts)   │
└─────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────┐
│  Stage 2 — Region Extraction        │
│  Forehead / Cheeks / Nose polygons  │
│  Eyes, brows, hair excluded         │
└─────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────┐
│  Stage 3 — Lighting Correction      │
│  ACE (Automatic Color Equalization) │
│  + Histogram normalization          │
└─────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────┐
│  Stage 4 — Skin Tone Classification │
│  CIELAB color space comparison      │
│  ΔE distance → Monk 1-10 scale      │
└─────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────┐
│  Stage 5 — Undertone Detection      │
│  Tone-stratified a*b* Lab analysis  │
│  → Warm / Cool / Neutral            │
└─────────────────────────────────────┘
     │
     ▼
🎨 6 Best + 6 Avoid Color Recommendations
```

### Stage Details

**Stage 1 — Face Mesh Detection**
ML Kit's `FaceMeshDetector` locates 468 facial landmark points in real time. The full `faceMesh` option is used (vs `boundingBox` only) to achieve sub-millimeter accuracy on landmark placement.

**Stage 2 — Region Extraction**
The `RegionExtractor` (`face_regions.dart`) builds convex polygons from the 468 landmarks, covering:
- **Upper cheeks** (left + right) — primary sampling zone
- **Forehead center** — secondary zone
- **Nose bridge** — tertiary zone

Critically, the following are **explicitly excluded** by polygon subtraction:
- Eye sockets and eyelids
- Eyebrow arches
- Lip area
- Beard / facial hair coverage zones

**Stage 3 — Lighting Correction**
Two normalization passes run on the sampled pixel set:
1. **Histogram stretch** — maps the pixel luminance range to [0, 255] to counter over/under-exposure
2. **ACE pass** — applies a grey-world assumption to correct color casts from warm or cool artificial light

**Stage 4 — Monk Scale Classification**
The corrected pixels are converted to **CIELAB (D65 illuminant)** color space. The median Lab value is computed and compared to 10 calibrated reference Lab values (`_monkLabD65` in `skin_classifier.dart`). A weighted ΔE₂₀₀₀ (Delta E 2000) distance metric determines the nearest Monk tone (1–10), with a confidence score derived from the distance margin between the first and second closest matches.

**Stage 5 — Undertone Detection**
Using the detected Monk band (1–3, 4–5, 6–7, 8–10), a separate tone-stratified lookup table (`_undertoneRefs`) provides three Lab reference vectors (Warm, Cool, Neutral). The measured skin Lab vector is projected onto each reference, and the smallest angular distance determines the undertone. A separate confidence percentage is reported.

---

## 🧬 AI & Color Science

### Google Monk Skin Tone Scale
The **Monk Skin Tone (MST) Scale** is a 10-shade reference system published by Ellis et al. (2022) and adopted by Google. It was designed to replace the older, less inclusive Fitzpatrick scale (6 shades) with broader representation across human skin diversity. Vistone AI uses the official MST D65-calibrated Lab values for maximum photometric accuracy.

> **Reference:** Ellis, K., Morán, I. K., & Morley, S. K. (2022). *Diversity and Inclusion in AI: Skin Tone Scales.* Google Research.

### Seasonal Color Analysis (SCA)
Color recommendations are based on **SCA**, a professional styling methodology that maps individuals to a color archetype based on their skin tone depth and undertone. The system recognizes that:

- **Cool undertones** (blue/pink/red hue in skin) → are complemented by blue-based, jewel, or icy colors
- **Warm undertones** (yellow/peach/golden hue in skin) → are complemented by earth tones, spices, warm neutrals
- **Neutral undertones** (a balance of warm and cool) → can wear both, but with muted/dusty variants

Vistone AI applies this framework per Monk tone group, producing recommendations that are not only undertone-correct but also **contrast-correct** for the depth of the skin tone.

### CIELAB & Delta E
All color comparisons are performed in **CIE L*a*b* (CIELAB)** color space, which is perceptually uniform — meaning a numerically equal Delta E corresponds to a perceptually equal difference in color, regardless of hue. This is the standard used in:
- Paint / textile industry color matching
- Medical skin tone diagnostics
- Professional photography color grading

---

## 🏗 Architecture

Vistone AI follows a clean, layered architecture:

```
┌────────────────────────────────────────────┐
│                   UI Layer                  │
│  Screens (6) · Widgets (7) · Design System  │
│  Go Router for navigation                   │
└────────────────────────┬───────────────────┘
                         │ consumes
┌────────────────────────▼───────────────────┐
│              State Management               │
│  Flutter Riverpod — NotifierProvider        │
│  ThemeNotifier (persisted via SharedPrefs)  │
└────────────────────────┬───────────────────┘
                         │ reads/writes
┌────────────────────────▼───────────────────┐
│              Service Layer                  │
│  AnalysisService — orchestrates pipeline    │
│  ColorDatabase — loads & queries JSON asset │
└────────────────────────┬───────────────────┘
                         │ delegates
┌────────────────────────▼───────────────────┐
│            Engine Layer (Pure Dart)         │
│  SkinClassifier · RegionExtractor           │
│  ColorMath (Lab/ΔE) · FaceRegions           │
│  Runs in Dart Isolate (off main thread)     │
└────────────────────────────────────────────┘
```

### Key Design Decisions

**On-Device Only**
All ML inference runs locally. No image data or analysis results are transmitted to any server. The `FaceMeshDetector` model is bundled with ML Kit and runs entirely in native code.

**Isolate-based Processing**
The heavy pixel math (region extraction, lighting correction, Lab conversion) runs in a Dart `Isolate` via `compute()`, keeping the UI thread free and preventing jank during analysis.

**Asset-based Color Database**
The full 10-tone × 3-undertone × 30-combination color database is stored as a local JSON asset (`monk_skin_tone_color_recommendations.json`). It is loaded once into memory on first analysis and cached as a singleton thereafter.

---

## 🛠 Tech Stack

| Category | Technology | Version |
|---|---|---|
| **Framework** | Flutter | `^3.x` |
| **Language** | Dart | `^3.8.1` |
| **State Management** | Flutter Riverpod | `^2.6.1` |
| **Navigation** | Go Router | `^14.8.1` |
| **On-Device ML** | Google ML Kit Face Mesh | `^0.4.2` |
| **Image Processing** | `image` package | `^4.5.2` |
| **Image Picker** | `image_picker` | `^1.1.2` |
| **Typography** | Google Fonts (Playfair Display + Inter) | `^6.3.2` |
| **Icons** | Material Symbols | `^4.2951.0` |
| **Animations** | Flutter Animate | `^4.5.0` |
| **Persistence** | Shared Preferences | `^2.5.3` |
| **Clipboard** | `clipboard` | `^0.1.3` |

---

## 📁 Project Structure

```
vistone_flutter/
├── assets/
│   ├── icon/
│   │   └── vistone_logo.png              # App icon & splash logo
│   └── monk_skin_tone_color_recommendations.json  # Color database (30 combos × 12 colors)
│
├── lib/
│   ├── main.dart                         # App entry, SharedPreferences init, ProviderScope
│   ├── router.dart                       # Go Router configuration & routes
│   │
│   ├── engine/                           # Pure Dart color science (runs in Isolate)
│   │   ├── color_math.dart               # CIELAB conversion, ΔE2000 computation
│   │   ├── face_regions.dart             # Polygon region extraction, ray-casting
│   │   ├── offset_logic.dart             # Landmark offset utilities
│   │   └── skin_classifier.dart          # Monk scale + undertone classification
│   │
│   ├── models/
│   │   ├── analysis_result.dart          # AnalysisResult data class
│   │   └── color_swatch.dart             # ColorSwatch data class
│   │
│   ├── providers/
│   │   └── theme_provider.dart           # ThemeNotifier + SharedPreferences persistence
│   │
│   ├── screens/
│   │   ├── splash_screen.dart            # Animated splash with botanical background
│   │   ├── home_screen.dart              # Upload zone, tips, main CTA
│   │   ├── analyzing_screen.dart         # Step-by-step analysis progress
│   │   ├── result_screen.dart            # Monk scale, confidence, color grids
│   │   ├── color_preview_screen.dart     # Full-screen swatch preview + hex copy
│   │   └── about_screen.dart             # Botanical hero card + info sections
│   │
│   ├── services/
│   │   ├── analysis_service.dart         # ML Kit orchestration + Isolate dispatch
│   │   └── color_database.dart           # JSON asset loader + recommendation query
│   │
│   ├── theme/
│   │   ├── app_colors.dart               # Complete earthy light & dark color tokens
│   │   ├── app_spacing.dart              # Spacing scale + shadow system
│   │   ├── app_theme.dart                # MaterialTheme light/dark configurations
│   │   └── app_typography.dart           # 13-tier type system (Playfair Display + Inter)
│   │
│   └── widgets/
│       ├── botanical_background.dart     # CustomPainter botanical leaf graphics
│       ├── buttons.dart                  # AppButton component system
│       ├── color_swatch_card.dart        # Interactive animated color swatch
│       ├── confidence_bar.dart           # Animated confidence percentage bar
│       ├── design_system.dart            # Barrel export for all design tokens
│       ├── monk_scale_slider.dart        # Horizontal Monk 1-10 scale widget
│       └── upload_zone.dart              # Camera/gallery pick zone
│
├── pubspec.yaml
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.0.0`
- Dart SDK `>=3.8.1`
- Android Studio / Xcode (for device deployment)
- A **physical device** or emulator with camera support

> ⚠️ **Note:** Google ML Kit Face Mesh requires a physical Android/iOS device for best results. Emulators may produce inaccurate readings due to camera simulation limitations.

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/karanks6/vistone_flutter.git
cd vistone_flutter
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Run on device**
```bash
flutter run
```

**4. Build release APK** *(optional)*
```bash
flutter build apk --release
```

### Android Permissions
The following permissions are declared in `AndroidManifest.xml` and are required:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

---

## 🎨 Color Recommendation Logic

### Database Structure
The color database (`monk_skin_tone_color_recommendations.json`) is organized as a 3-level nested map:

```
tone_1 … tone_10
    └── cool / warm / neutral
            ├── best: [ 6 ColorSwatch objects ]
            └── avoid: [ 6 ColorSwatch objects ]
```

**Total combinations:** 10 tones × 3 undertones = **30 unique profiles**
**Total swatches:** 30 profiles × 12 swatches = **360 curated colors**

### Recommendation Philosophy

| Tone Group | Depth | Cool Best | Warm Best |
|---|---|---|---|
| **1–3** (Light/Fair) | Low contrast | Pastels, powder blues, mauves | Blush, peach, champagne |
| **4–6** (Medium/Olive) | Medium contrast | Jewel tones, sapphire, emerald | Terracotta, bronze, olive |
| **7** (Tan/Deep Medium) | High contrast | Electric royal, cobalt, vivid teal | Warm brick, amber, dark moss |
| **8–10** (Deep/Dark) | Maximum contrast | Pure white, vivid crimson, royal purple | Burnt orange, mustard gold, mahogany |

### Avoid Logic
Avoid colors are selected as the **chromatic opposite** of the best colors:
- **Cool undertones avoid:** warm ambers, mustard yellows, earthy olives, rust reds
- **Warm undertones avoid:** icy blues, cool greys, lavender, frosty pastels
- **Neutral undertones avoid:** neons, harsh high-saturation extremes on both warm/cool ends

---

## 🎨 Design System

Vistone AI uses a proprietary **earthy, nature-inspired design language** for its light mode.

### Color Palette

| Token | Light Mode | Dark Mode | Usage |
|---|---|---|---|
| `bgLight` | `#F3ECE3` Warm Sand | `#0E1116` | Scaffold background |
| `surfaceLight` | `#FAF6F0` Cream White | `#181C24` | Cards, surfaces |
| `primary` | `#1F2A1F` Dark Green | `#7CA9FF` | Primary text, icons, CTAs |
| `accent` | `#E76F51` Terracotta | `#FF9A7A` | Highlights, active states |
| `sageGreen` | `#7A946F` | — | Botanical graphics |
| `border` | `#E2D6C6` Sandstone | — | Dividers, card borders |

### Typography
Two-font system:
- **Playfair Display** — Display headings (`displayLarge`, `displayMedium`, `displaySmall`)
- **Inter** — Body text, labels, captions (all remaining styles)

### Spacing Scale
```
s4=4 · s8=8 · s12=12 · s16=16 · s24=24 · s32=32 · s48=48 · s64=64
```

### Shadow System (Dual-layer)
```
Level 0 — No shadow (base surfaces)
Level 1 — 2px offset, 8px blur (cards)
Level 2 — 4px offset, 16px blur + 12px outer (elevated cards)
```

---

## ♿ Accessibility

- All text meets **WCAG AA contrast** (minimum 4.5:1 ratio)
- `Semantics` labels applied to all icon buttons
- `Expanded` + `Wrap` layouts prevent overflow on any font scale
- `SafeArea` wrapping on all screens prevents notch/cutout clipping
- Orientation locked to **portrait** to ensure consistent layout

---

## 🔒 Privacy & Security

Vistone AI was built with a **privacy-by-design** philosophy:

- ✅ **Zero network requests** — the app makes no HTTP calls whatsoever
- ✅ **No analytics or tracking** — no Firebase, Mixpanel, Sentry, or similar SDKs
- ✅ **No image storage** — photos are processed in memory and immediately discarded
- ✅ **No account required** — no login, no email, no profile
- ✅ **On-device ML only** — the `google_mlkit_face_mesh_detection` model runs entirely in native code on the device
- ✅ **Open source** — full source available for audit

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a **Pull Request**

### Guidelines
- Follow the existing design system — use tokens from `app_colors.dart`, `app_spacing.dart`, and `app_typography.dart`. Do not hardcode colors or sizes.
- Color recommendations must be based on established SCA or colorimetry research. Include a citation when adding or modifying the JSON database.
- All new screens must implement `SafeArea` and support both light and dark themes.
- Run `flutter analyze` before submitting — PRs with lint warnings will not be merged.

---

## 📄 License

```
MIT License

Copyright (c) 2025 Vistone AI

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---


<div align="center">

*Vistone AI — Discover your true colors.*

</div>