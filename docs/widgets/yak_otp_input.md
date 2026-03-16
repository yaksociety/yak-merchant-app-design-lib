# YakOtpInput

OTP/PIN input with separate boxes for each digit. Shows gold border and highlight on the active box, supports backspace-to-delete, and can display an error state with an error message.

---

## When to use

- OTP verification (e.g. 6 digits)
- PIN entry (e.g. 4 digits)
- Any fixed-length code input

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `length` | `int` | `6` | Number of digit boxes. |
| `errorMessage` | `String?` | — | Error message shown below the boxes. When non-empty, shows red borders on all boxes. |
| `onChanged` | `ValueChanged<String>?` | — | Called when any digit changes. Returns full code. |
| `onCompleted` | `ValueChanged<String>?` | — | Called when all digits are filled. |
| `boxSize` | `double` | `48` | Width and height of each box. |
| `spacing` | `double` | `12` | Space between boxes. |
| `textStyle` | `TextStyle?` | — | Style for digits. |
| `autofocus` | `bool` | `false` | Automatically focus the first digit box when the widget is built. |
| `obscureText` | `bool` | `false` | Show • instead of digits. |
| `enabled` | `bool` | `true` | Enable/disable input. |

---

## Examples

### 6-digit OTP
```dart
YakOtpInput(
  length: 6,
  autofocus: true,
  onChanged: (code) {
    print('Current: $code');
  },
  onCompleted: (code) {
    print('Complete: $code');
    // Verify OTP
  },
)
```

### Error state (message + red borders)
```dart
YakOtpInput(
  length: 6,
  errorMessage: 'รหัสยืนยันตัวตนไม่ถูกต้อง โปรดลองอีกครั้ง',
  onChanged: (code) {},
)
```

### 4-digit PIN (obscured)
```dart
YakOtpInput(
  length: 4,
  obscureText: true,
  onCompleted: (code) {
    // Handle PIN
  },
)
```

### Custom size and spacing
```dart
YakOtpInput(
  length: 6,
  boxSize: 56,
  spacing: 16,
  textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  ),
  onCompleted: (code) {},
)
```
