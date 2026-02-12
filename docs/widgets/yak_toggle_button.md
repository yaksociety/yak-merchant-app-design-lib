# YakToggleButton

Toggle switch for on/off states (settings, preferences, feature flags).

---

## When to use

- Enable/disable settings
- Toggle features or options
- Yes/No or on/off choices

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `bool` | required | Current on/off state. |
| `onChanged` | `ValueChanged<bool>?` | required | Called when toggled. `null` = disabled. |
| `width` | `double` | `51` | Toggle track width. |
| `height` | `double` | `31` | Toggle track height. |
| `activeColor` | `Color?` | `#4CAF50` | Track color when on. |
| `inactiveColor` | `Color?` | `#E0E0E0` | Track color when off. |

---

## Examples

### Basic
```dart
YakToggleButton(
  value: isEnabled,
  onChanged: (value) {
    setState(() => isEnabled = value);
  },
)
```

### Custom colors
```dart
YakToggleButton(
  value: isOn,
  onChanged: (v) => setState(() => isOn = v),
  activeColor: Colors.blue,
  inactiveColor: Colors.grey[300],
)
```

### Disabled
```dart
YakToggleButton(
  value: true,
  onChanged: null,
)
```
