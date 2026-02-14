# YakRadioButton & YakRadioGroup

Radio options for single-choice selection. Use **YakRadioGroup** to wrap multiple **YakRadioButton**s with shared `groupValue` and `onChanged`; each option can have a label, optional subtitle, and optional per-option helper text.

---

## When to use

| Use case | Example |
|----------|---------|
| **Single choice** | Delivery method, payment method, size (S/M/L) |
| **Yes/No or short options** | Tax option with description under "No" |
| **Options with extra description** | Per-option helper text (e.g. tax note) |

Use **YakRadioGroup** when you have a list of options and want group-level helper text; use **YakRadioButton** inside it and omit `groupValue`/`onChanged` on each button.

---

## YakRadioGroup props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `groupValue` | `T?` | required | Currently selected value for the group. |
| `onChanged` | `ValueChanged<T?>` | required | Called when selection changes. |
| `children` | `List<Widget>` | required | Radio options (e.g. [YakRadioButton] widgets). Do not pass groupValue/onChanged to them. |
| `helperText` | `String?` | — | Optional description shown below the group. |
| `onHelperClose` | `VoidCallback?` | — | When set, a close icon is shown next to helper text. |
| `helperStyle` | `TextStyle?` | gray700, 14px | Style for helper text. |
| `helperPadding` | `EdgeInsetsGeometry?` | top: 8, left: 48 | Padding around the helper text. |
| `paddingTop` | `double?` | 0 | Top padding above the first radio. |
| `paddingBottom` | `double?` | 0 | Bottom padding below helper or children. |

---

## YakRadioButton props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `T` | required | Value this option represents. |
| `groupValue` | `T?` | — | Currently selected value. Omit when inside [YakRadioGroup]. |
| `onChanged` | `ValueChanged<T?>?` | — | Called when this option is selected. Omit when inside [YakRadioGroup]. |
| `label` | `String` | required | Main label shown next to the radio. |
| `subtitle` | `String?` | — | Optional secondary text below label (inside the tile). |
| `helperText` | `String?` | — | Optional helper text below this option only, indented to align with label. |
| `helperStyle` | `TextStyle?` | gray, 14px | Style for this option's helper text. |
| `onHelperClose` | `VoidCallback?` | — | When set, a close icon is shown for this option's helper. |
| `activeColor` | `Color?` | primary500 | Color when selected. |
| `inactiveColor` | `Color?` | gray300 | Color for unselected border/circle. |

---

## Examples

### With YakRadioGroup (recommended)

```dart
YakRadioGroup<String>(
  groupValue: _selected,
  onChanged: (v) => setState(() => _selected = v),
  children: [
    YakRadioButton<String>(value: 'yes', label: 'ใช่'),
    YakRadioButton<String>(value: 'no', label: 'ไม่ใช่', helperText: 'ไม่ต้องออกใบกำกับภาษี'),
  ],
)
```

### With group-level helper text

```dart
YakRadioGroup<String>(
  groupValue: _method,
  onChanged: (v) => setState(() => _method = v),
  helperText: 'เลือกวิธีจัดส่งที่ต้องการ',
  children: [
    YakRadioButton<String>(value: 'standard', label: 'จัดส่งธรรมดา'),
    YakRadioButton<String>(value: 'express', label: 'จัดส่งด่วน'),
  ],
)
```

### With subtitle

```dart
YakRadioGroup<String>(
  groupValue: _size,
  onChanged: (v) => setState(() => _size = v),
  children: [
    YakRadioButton<String>(
      value: 's',
      label: 'S',
      subtitle: 'เหมาะกับ 1–2 คน',
    ),
    YakRadioButton<String>(
      value: 'm',
      label: 'M',
      subtitle: 'เหมาะกับ 2–4 คน',
    ),
  ],
)
```

### Standalone (without YakRadioGroup)

```dart
Column(
  children: [
    YakRadioButton<String>(
      value: 'a',
      groupValue: _value,
      onChanged: (v) => setState(() => _value = v),
      label: 'Option A',
    ),
    YakRadioButton<String>(
      value: 'b',
      groupValue: _value,
      onChanged: (v) => setState(() => _value = v),
      label: 'Option B',
    ),
  ],
)
```

### Custom colors

```dart
YakRadioButton<String>(
  value: 'custom',
  groupValue: _value,
  onChanged: (v) => setState(() => _value = v),
  label: 'Custom style',
  activeColor: YakColor.primitive.blue.blue600,
  inactiveColor: YakColor.primitive.gray.gray400,
)
```
