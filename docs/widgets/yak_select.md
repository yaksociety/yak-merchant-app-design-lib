# YakSelect

Dropdown/select for choosing one option from a list. Aligned with **DropdownStyle** from the Android app: label with optional required asterisk, border states (error → danger, focused → primary, default → neutral), disabled background, chevron that rotates when open, and dropdown menu with check icon on the selected item.

---

## When to use

- Country/language picker
- Single-choice from a list
- Phone code selector (with flag icons)

---

## YakSelectStyle

Style variant (matches DropdownClass on Android):

| Value | Description |
|-------|-------------|
| `compact` | Minimal padding, XS semibold text. |
| `minimal` | Minimal styling, S regular text. |
| `normal` | Standard styling (default), S regular text. |

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
| `placeholder` | `String?` | `'Select an option'` | Shown when nothing selected. |
| `errorMessage` | `String?` | — | Error text below field (label uses danger color when set). |
| `enabled` | `bool` | `true` | Enable/disable (grey background when disabled). |
| `style` | `YakSelectStyle` | `normal` | compact / minimal / normal. |
| `visibleIcon` | `bool` | `true` | Show item icon in selector and in dropdown list. |
| `buttonTextColor` | `Color?` | — | Override text/placeholder color in the selector. |

---

## Behavior

- **Single item** – No chevron. Tapping selects the only option.
- **Multiple items** – Chevron (size 20) rotates 180° when open. Dropdown list appears below (max height 200, rounded 12); selected item shows a check icon (primary color).
- **Colors** – Uses YakColor: border (error/focused/default), background (disabled neutral50), label and error text.

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

### Style variants
```dart
YakSelect<String>(
  label: 'Compact',
  style: YakSelectStyle.compact,
  items: [...],
  value: _selected,
  onChanged: (v) => setState(() => _selected = v),
)

YakSelect<String>(
  label: 'Minimal',
  style: YakSelectStyle.minimal,
  placeholder: 'Select item',
  items: [...],
  value: _selected,
  onChanged: (v) => setState(() => _selected = v),
)
```

### With error
```dart
YakSelect<String>(
  label: 'Province',
  isRequired: true,
  placeholder: 'Please select',
  items: [...],
  value: null,
  onChanged: (v) => setState(() => _selected = v),
  errorMessage: 'This field is required',
)
```

### Disabled
```dart
YakSelect<String>(
  label: 'Disabled',
  items: [...],
  value: 'item1',
  onChanged: null,
  enabled: false,
)
```
