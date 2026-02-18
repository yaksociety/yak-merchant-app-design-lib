# YakPinInput

PIN input where **previous digits show as dots (•)** and the **current (focused) digit shows the actual number**. Rounded boxes with gold border on the active box; same focus, backspace, and completion behavior as [YakOtpInput](yak_otp_input.md).

---

## When to use

- PIN entry where only the digit being typed is visible (e.g. 6-digit PIN)
- Security-sensitive input where filled digits are masked except the current one

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `length` | `int` | `6` | Number of digit boxes. |
| `errorMessage` | `String?` | — | Error message below the boxes. When non-empty, shows red borders and message. |
| `onChanged` | `ValueChanged<String>?` | — | Called when any digit changes. Returns full code. |
| `onCompleted` | `ValueChanged<String>?` | — | Called when all digits are filled. |
| `boxSize` | `double` | `48` | Width and height of each box. |
| `spacing` | `double` | `12` | Space between boxes. |
| `textStyle` | `TextStyle?` | — | Style for digits and dots. |
| `enabled` | `bool` | `true` | Enable/disable input. |

---

## Examples

### 6-digit PIN (current digit visible, previous as •)
```dart
YakPinInput(
  length: 6,
  onChanged: (code) {},
  onCompleted: (code) {
    // Verify PIN
  },
)
```

### With error state
```dart
YakPinInput(
  length: 6,
  errorMessage: 'รหัสยืนยันตัวตนไม่ถูกต้อง โปรดลองอีกครั้ง',
  onCompleted: (code) {},
)
```

### Custom size
```dart
YakPinInput(
  length: 6,
  boxSize: 56,
  spacing: 16,
  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  onCompleted: (code) {},
)
```
