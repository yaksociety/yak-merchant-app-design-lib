# YakIndicator

Horizontal progress indicator with rounded ends and smooth value animation. Use it for upload/download progress, step completion, or any 0–100% display.

---

## When to use

- Upload or download progress
- Multi-step flow (e.g. step 2 of 4)
- Profile or form completion percentage
- Any progress from 0% to 100%

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `double` | required | Progress from 0.0 to 1.0 (clamped). |
| `height` | `double` | `12` | Height of the bar. |
| `indicatorRadius` | `double?` | `height / 2` | Radius for rounded ends (pill when ≥ half height). |
| `duration` | `Duration` | `400 ms` | Animation duration when `value` changes. |
| `curve` | `Curve` | `Curves.easeInOut` | Animation curve. |
| `activeColor` | `Color?` | success green | Color of the filled segment. |
| `backgroundColor` | `Color?` | light cream | Color of the track. |
| `showLabel` | `bool` | `false` | Show percentage bubble above the bar. |

---

## Behavior

- **0%** – A small circular dot at the left.
- **1–100%** – Rounded bar grows left to right; value changes animate smoothly.
- **Label** – When `showLabel` is true, a percentage appears above the trailing end of the bar.

---

## Examples

### Basic
```dart
YakIndicator(
  value: 0.5,
)
```

### With label
```dart
YakIndicator(
  value: 0.75,
  showLabel: true,
)
```

### Custom colors and radius
```dart
YakIndicator(
  value: 0.6,
  height: 16,
  indicatorRadius: 10,
  activeColor: YakColor.primitive.primary.primary500,
  backgroundColor: YakColor.primitive.neutral.neutral200,
)
```

### Animated (e.g. from a stream or timer)
```dart
YakIndicator(
  value: progress,  // updates over time
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeOutCubic,
  showLabel: true,
)
```
