# YakTextArea

Multi-line text input for longer content. Same visual style as `YakTextInput` but taller.

---

## When to use

- Addresses
- Descriptions
- Notes, comments
- Any multi-line text

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String?` | — | Label above the field. |
| `isRequired` | `bool` | `false` | Show red `*` after label. |
| `placeholder` | `String?` | — | Hint text when empty. |
| `controller` | `TextEditingController?` | — | External controller. Uses internal if `null`. |
| `errorMessage` | `String?` | — | Error text below field. |
| `onChanged` | `ValueChanged<String>?` | — | Called on text change. |
| `minLines` | `int` | `4` | Min visible lines. |
| `maxLines` | `int?` | — | Max lines (`null` = unbounded). |
| `maxLength` | `int?` | — | Max character count. |
| `textStyle` | `TextStyle?` | — | Custom input text style. |
| `enabled` | `bool` | `true` | Enable/disable input. |

---

## States

- **Default** – Grey border
- **Focused** – Gold border
- **Error** – Red border and label, error message below

---

## Examples

### Basic
```dart
YakTextArea(
  label: 'Address',
  placeholder: '123 Charoenkrung Road',
  minLines: 4,
  onChanged: (value) {},
)
```

### Required
```dart
YakTextArea(
  label: 'Registered Address',
  isRequired: true,
  placeholder: 'Enter full address',
  controller: _addressController,
  onChanged: (value) {},
)
```

### With max length
```dart
YakTextArea(
  label: 'Description',
  placeholder: 'Max 500 characters',
  maxLength: 500,
  onChanged: (value) {},
)
```
