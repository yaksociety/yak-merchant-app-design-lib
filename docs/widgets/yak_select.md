# YakSelect

Dropdown/select for choosing one option from a list. Supports optional icons per item. Chevron is hidden when there is only one item.

---

## When to use

- Country/language picker
- Single-choice from a list
- Phone code selector (with flag icons)

---

## YakSelectItem<T>

Each option is a `YakSelectItem`:

| Prop | Type | Description |
|------|------|-------------|
| `value` | `T` | Value returned when selected. |
| `label` | `String` | Text shown for this option. |
| `icon` | `Widget?` | Optional icon (e.g. flag) before label. |

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `items` | `List<YakSelectItem<T>>` | required | Options to choose from. |
| `value` | `T?` | — | Currently selected value. |
| `onChanged` | `ValueChanged<T?>?` | — | Called when selection changes. |
| `label` | `String?` | — | Label above the field. |
| `isRequired` | `bool` | `false` | Show red `*` after label. |
| `placeholder` | `String?` | `'Dropdown'` | Shown when nothing selected. |
| `errorMessage` | `String?` | — | Error text below field. |
| `enabled` | `bool` | `true` | Enable/disable. |

---

## Behavior

- **Single item** – No chevron. Tapping selects the only option.
- **Multiple items** – Chevron down when closed, up when open. Dropdown list appears below.

---

## Examples

### Basic
```dart
YakSelect<String>(
  label: 'Country',
  placeholder: 'Select country',
  items: const [
    YakSelectItem(value: 'item1', label: 'Item 1'),
    YakSelectItem(value: 'item2', label: 'Item 2'),
    YakSelectItem(value: 'item3', label: 'Item 3'),
  ],
  value: _selected,
  onChanged: (value) => setState(() => _selected = value),
)
```

### With icons (e.g. flag)
```dart
YakSelect<String>(
  label: 'Language',
  items: [
    YakSelectItem(
      value: 'th',
      label: 'ไทย',
      icon: Container(
        width: 24,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.blue, // or custom flag
        ),
      ),
    ),
    YakSelectItem(value: 'en', label: 'English'),
  ],
  value: _selected,
  onChanged: (v) => setState(() => _selected = v),
)
```

### Single item (no chevron)
```dart
YakSelect<String>(
  label: 'Country Code',
  items: const [
    YakSelectItem(value: '66', label: '+66'),
  ],
  value: '66',
  onChanged: (_) {},
)
```

### Required
```dart
YakSelect<String>(
  label: 'Region',
  isRequired: true,
  items: [...],
  value: _selected,
  onChanged: (v) => setState(() => _selected = v),
)
```
