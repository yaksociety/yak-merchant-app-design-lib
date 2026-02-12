# YakColor

Color palette with primitive and semantic tokens. Mirrors ColorStyle from the Android merchant app.

---

## Structure

| Token | Use for |
|-------|---------|
| **primitive** | Raw color values (Primary, Neutral, Gray, Danger, Success, Warning, Blue) |
| **semantic** | Context-specific colors (Background, TextAndIcons, Stroke) |

---

## Usage

### Primitive colors

```dart
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

// Primary palette (25–900)
YakColor.primitive.primary.primary500
YakColor.primitive.primary.primary100

// Base
YakColor.primitive.base.white
YakColor.primitive.base.black

// Neutral, Gray, Danger, Success, Warning, Blue
YakColor.primitive.neutral.neutral100
YakColor.primitive.gray.gray700
YakColor.primitive.danger.danger500
YakColor.primitive.success.success500
YakColor.primitive.warning.warning500
YakColor.primitive.blue.blue500
```

### Semantic colors

```dart
// Backgrounds
YakColor.semantic.background.baseMain      // White
YakColor.semantic.background.baseSecond    // Neutral 100
YakColor.semantic.background.primaryMain   // Primary 500
YakColor.semantic.background.primarySecond // Primary 50
YakColor.semantic.background.disabled
YakColor.semantic.background.baseDarkMain  // Gray 900

// Text and icons
YakColor.semantic.textAndIcons.baseMain    // Gray 700
YakColor.semantic.textAndIcons.baseSecond  // Gray 200
YakColor.semantic.textAndIcons.onColor     // White (on colored backgrounds)
YakColor.semantic.textAndIcons.disabled
YakColor.semantic.textAndIcons.primary
YakColor.semantic.textAndIcons.success
YakColor.semantic.textAndIcons.danger
YakColor.semantic.textAndIcons.warning
YakColor.semantic.textAndIcons.blue

// Strokes / borders
YakColor.semantic.stroke.base
YakColor.semantic.stroke.baseDark
YakColor.semantic.stroke.primary
YakColor.semantic.stroke.danger
```

### In widgets

```dart
Container(
  color: YakColor.semantic.background.primaryMain,
  child: Text(
    'Hello',
    style: TextStyle(color: YakColor.semantic.textAndIcons.onColor),
  ),
)

DecoratedBox(
  decoration: BoxDecoration(
    border: Border.all(color: YakColor.semantic.stroke.base),
  ),
  child: ...,
)

ThemeData(
  colorScheme: ColorScheme.light(
    primary: YakColor.primitive.primary.primary500,
    onPrimary: YakColor.semantic.textAndIcons.onColor,
    error: YakColor.primitive.danger.danger500,
  ),
)
```
