# YakTypography

Typography system with primitive and semantic styles. Mirrors TypographyStyle from the Android merchant app. Uses Google Sans font family.

---

## Font setup

Add Google Sans to your app's `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: GoogleSans
      fonts:
        - asset: fonts/GoogleSans-Regular.ttf
        - asset: fonts/GoogleSans-Medium.ttf
          weight: 500
        - asset: fonts/GoogleSans-SemiBold.ttf
          weight: 600
        - asset: fonts/GoogleSans-Bold.ttf
          weight: 700
```

---

## Structure

| Token | Use for |
|-------|---------|
| **primitive** | Font sizes, weights, letter spacing |
| **semantic** | Headings (1–3), Text sizes (L/M/S/XS/XXS) with regular/medium/semibold |
| **materialTypography** | Material 3 Typography for ThemeData |

---

## Usage

### Semantic text styles

```dart
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

// Headings
Text('Title', style: YakTypography.semantic.heading1.semibold)
Text('Subtitle', style: YakTypography.semantic.heading2.semibold)
Text('Section', style: YakTypography.semantic.heading3.semibold)

// Body text – L (18), M (16), S (14), XS (12), XXS (10)
Text('Large body', style: YakTypography.semantic.textL.regular)
Text('Medium body', style: YakTypography.semantic.textM.regular)
Text('Small body', style: YakTypography.semantic.textS.regular)

// Medium weight
Text('Label', style: YakTypography.semantic.textM.medium)

// Semibold
Text('Emphasis', style: YakTypography.semantic.textS.semibold)

// Small labels
Text('Caption', style: YakTypography.semantic.textXS.regular)
Text('Tiny', style: YakTypography.semantic.textXXS.medium)
```

### Primitive tokens

```dart
// Font sizes (8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 32, 36, 40, 48, 64, 72, 96)
YakTypography.primitive.fontSize.unit16

// Font weights
YakTypography.primitive.fontWeight.regular   // w400
YakTypography.primitive.fontWeight.medium    // w500
YakTypography.primitive.fontWeight.semibold  // w600
YakTypography.primitive.fontWeight.bold      // w700

// Letter spacing
YakTypography.primitive.letterSpacing.tighter
YakTypography.primitive.letterSpacing.light
YakTypography.primitive.letterSpacing.normal
YakTypography.primitive.letterSpacing.wide
YakTypography.primitive.letterSpacing.wider
```

### Material 3 ThemeData

```dart
MaterialApp(
  theme: ThemeData(
    typography: YakTypography.materialTypography,
  ),
  ...,
)
```

### Custom TextStyle

```dart
Text(
  'Custom',
  style: YakTypography.semantic.textM.regular.copyWith(
    color: YakColor.semantic.textAndIcons.primary,
  ),
)
```
