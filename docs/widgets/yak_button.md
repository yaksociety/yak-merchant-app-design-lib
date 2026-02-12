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
| `icon` | `IconData?` | — | Icon for `icon` and `floating` variants. |
| `isCircularIcon` | `bool` | `true` | Circular vs square for `icon` variant. |
| `isLoading` | `bool` | `false` | Show loading spinner. |
| `width` | `double?` | — | Fixed width. `null` = auto. |
| `height` | `double` | `48` | Button height (or size for icon/FAB). |
| `backgroundColor` | `Color?` | — | Override background. |
| `textColor` | `Color?` | — | Override text/icon color. |
| `textStyle` | `TextStyle?` | — | Override text style. |

---

## Examples

### Primary
```dart
YakButton(
  text: 'Continue',
  onPressed: () {},
)
```

### With icons
```dart
YakButton(
  text: 'Save',
  leftIcon: const Icon(Icons.check, size: 20),
  rightIcon: const Icon(Icons.arrow_forward, size: 20),
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

### Disabled
```dart
YakButton(
  text: 'Disabled',
  onPressed: null,
)
```
