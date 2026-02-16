# YakButton

Unified button component with 5 variants. Use it for all primary, secondary, and icon actions in the app.

---

## When to use

| Variant | Use for |
|---------|---------|
| **primary** | Main action (submit, confirm, save) |
| **secondary** | Secondary action (cancel, back) |
| **ghost** | Subtle action (skip, link-style) |
| **icon** | Icon-only action (heart, share, settings) |
| **floating** | FAB – primary action floating on screen |

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `text` | `String` | required | Button label. Empty for icon-only. |
| `onPressed` | `VoidCallback?` | — | Called on tap. `null` = disabled. |
| `variant` | `YakButtonVariant` | `primary` | Style variant. |
| `leftIcon` | `Widget?` | — | Icon before text (primary/secondary/ghost). |
| `rightIcon` | `Widget?` | — | Icon after text. |
| `leadingIcon` | `IconData?` | — | Leading icon (primary/secondary/ghost). Rendered with [iconSize]. Ignored if [leftIcon] is set. |
| `trailingIcon` | `IconData?` | — | Trailing icon. Ignored if [rightIcon] is set. |
| `iconSize` | `double` | `20` | Size of [leadingIcon] and [trailingIcon]. |
| `icon` | `IconData?` | — | Icon for `icon` and `floating` variants. |
| `isCircularIcon` | `bool` | `true` | Circular vs square for `icon` variant. |
| `isLoading` | `bool` | `false` | Show loading spinner. |
| `width` | `double?` | — | Fixed width. `null` = auto. |
| `height` | `double` | `48` | Button height (or size for icon/FAB). |
| `backgroundColor` | `Color?` | — | Override background. |
| `textColor` | `Color?` | — | Override text/icon color. |
| `textStyle` | `TextStyle?` | — | Override text style. |
| `stroke` | `BorderSide?` | — | Custom border/stroke. Overrides default outline for secondary; adds border to primary/ghost. |
| `borderRadius` | `double?` | `8` | Corner radius. Ignored for circular icon variant. |
| `label` | `String?` | — | Optional label shown above the button (e.g. form field label). |
| `isRequired` | `bool` | `false` | When true, shows a red asterisk (*) after the label. |
| `labelStyle` | `TextStyle?` | — | Text style for the label. |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.symmetric(horizontal: 24, vertical: 12)` | Inner padding (primary/secondary/ghost). |

---

## Examples

### Primary
```dart
YakButton(
  text: 'Continue',
  onPressed: () {},
)
```

### With icons (Widget or IconData)
```dart
// Using leftIcon/rightIcon (full control)
YakButton(
  text: 'Save',
  leftIcon: const Icon(Icons.check, size: 20),
  rightIcon: const Icon(Icons.arrow_forward, size: 20),
  variant: YakButtonVariant.primary,
  onPressed: () {},
)

// Using leadingIcon/trailingIcon (simple IconData)
YakButton(
  text: 'Next',
  leadingIcon: Icons.arrow_back,
  trailingIcon: Icons.arrow_forward,
  variant: YakButtonVariant.primary,
  onPressed: () {},
)
```

### Loading
```dart
YakButton(
  text: 'Loading',
  isLoading: true,
  onPressed: () {},
)
```

### Secondary
```dart
YakButton(
  text: 'Cancel',
  variant: YakButtonVariant.secondary,
  onPressed: () {},
)
```

### Ghost
```dart
YakButton(
  text: 'Skip',
  variant: YakButtonVariant.ghost,
  onPressed: () {},
)
```

### Icon button
```dart
// Circular
YakButton(
  text: '',
  icon: Icons.favorite,
  variant: YakButtonVariant.icon,
  onPressed: () {},
)

// Square
YakButton(
  text: '',
  icon: Icons.settings,
  isCircularIcon: false,
  variant: YakButtonVariant.icon,
  onPressed: () {},
)
```

### Floating (FAB)
```dart
YakButton(
  text: '',
  icon: Icons.add,
  variant: YakButtonVariant.floating,
  onPressed: () {},
)

// Extended FAB
YakButton(
  text: 'Edit',
  icon: Icons.edit,
  variant: YakButtonVariant.floating,
  onPressed: () {},
)
```

### Label and required (field-style)
```dart
// Like a form field: label with red asterisk, placeholder text, leading/trailing icons
YakButton(
  label: 'ที่ตั้งร้านค้า',
  isRequired: true,
  text: 'เลือกตำแหน่งร้านค้า',
  variant: YakButtonVariant.secondary,
  backgroundColor: Colors.white,
  textColor: Colors.grey[600],
  leftIcon: const Icon(Icons.location_on, color: Color(0xFFF4C430), size: 22),
  trailingIcon: Icons.chevron_right,
  borderRadius: 12,
  stroke: BorderSide(color: Colors.grey[400]!, width: 1),
  width: double.infinity,
  onPressed: () {},
)
```

### Custom stroke and rounded
```dart
// Custom border and corner radius
YakButton(
  text: 'Outlined',
  variant: YakButtonVariant.primary,
  stroke: BorderSide(color: Colors.black, width: 2),
  borderRadius: 24,
  onPressed: () {},
)

YakButton(
  text: 'Pill',
  variant: YakButtonVariant.secondary,
  borderRadius: 999,
  onPressed: () {},
)
```

### Disabled
```dart
YakButton(
  text: 'Disabled',
  onPressed: null,
)
```
