# YakTextInput

Single-line text input with label, placeholder, and error handling. Matches Yak design: grey border, gold focus, red error.

---

## When to use

- Email, username, phone
- Short text fields (name, search)
- Password (with `obscureText`)

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String?` | — | Label above the field. |
| `isRequired` | `bool` | `false` | Show red `*` after label. |
| `placeholder` | `String?` | — | Hint text when empty. |
| `controller` | `TextEditingController?` | — | External controller. Uses internal if `null`. |
| `errorMessage` | `String?` | — | Error text below field (red state). |
| `onChanged` | `ValueChanged<String>?` | — | Called on text change. |
| `keyboardType` | `TextInputType` | `text` | Keyboard type. |
| `obscureText` | `bool` | `false` | Mask text (e.g. password). |
| `textStyle` | `TextStyle?` | — | Custom input text style. |
| `enabled` | `bool` | `true` | Enable/disable input. |

---

## States

- **Default** – Grey border
- **Focused** – Gold border
- **Error** – Red border and label, error message below
- **Disabled** – Muted colors and non-editable field

---

## Examples

### Basic
```dart
YakTextInput(
  label: 'Email',
  placeholder: 'name@email.com',
  onChanged: (value) {},
)
```

### Required
```dart
YakTextInput(
  label: 'Password',
  isRequired: true,
  placeholder: 'Enter password',
  obscureText: true,
  onChanged: (value) {},
)
```

### With controller
```dart
final _controller = TextEditingController();

YakTextInput(
  label: 'Username',
  controller: _controller,
  placeholder: 'Enter username',
  onChanged: (value) {},
)
```

### With error
```dart
YakTextInput(
  label: 'Email',
  placeholder: 'name@email.com',
  errorMessage: 'Invalid email address',
  onChanged: (value) {},
)
```

### Disabled
```dart
YakTextInput(
  label: 'Label',
  placeholder: 'Input text',
  enabled: false,
)
```

### Email keyboard
```dart
YakTextInput(
  label: 'Email',
  placeholder: 'name@email.com',
  keyboardType: TextInputType.emailAddress,
  onChanged: (value) {},
)
```

### No label
```dart
YakTextInput(
  placeholder: 'Search...',
  onChanged: (value) {},
)
```
