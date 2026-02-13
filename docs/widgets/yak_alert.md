# YakAlert

Banner alert that shows at the top of the screen with icon, title, message, optional action link, and dismiss button. Use `YakAlert.show(context, ...)` to display as an overlay at the top, or place `YakAlert` in your layout. Styling can be set globally via `YakAlertThemeData` in `ThemeData.extensions`.

Design: horizontal layout (icon | info container | close), 8px item spacing, 16px padding, Headline/XS/Medium for title, Text/M/Regular for body, optional "Show More →" link, drop shadow XSM.

---

## When to use

- **Error** – Issues preventing action (e.g. login failed, validation error)
- **Warning** – Potential problems or caution
- **Success / Confirmation** – Successful actions or decisions
- **Information** – Important but non-critical info

Placement: top of the screen so the alert is visible without blocking the main flow.

---

## Alert types

| Type | Icon color | Use case |
|------|------------|----------|
| `YakAlertType.info` | Yellow/orange | General information |
| `YakAlertType.warning` | Yellow/orange | Warnings, caution |
| `YakAlertType.error` | Red | Errors, failures |
| `YakAlertType.success` | Green | Success, confirmation |

---

## Global theme: YakAlertThemeData

Set defaults for all alerts via `ThemeData.extensions`:

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `borderRadius` | `double` | `12` | Corner radius. |
| `elevation` | `double` | `2` | Shadow depth. |
| `shadowColor` | `Color?` | — | Shadow color. |
| `horizontalPadding` | `double` | `16` | Left/right padding. |
| `verticalPadding` | `double` | `16` | Top/bottom padding. |
| `itemSpacing` | `double` | `8` | Space between icon, content, close. |
| `contentSpacing` | `double` | `16` | Space between body and action link. |
| `titleBodySpacing` | `double` | `4` | Space between title and body. |
| `iconSize` | `double` | `24` | Size of the alert icon. |

---

## Props (YakAlert widget)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `String` | required | Alert title. |
| `message` | `String` | required | Body message. |
| `type` | `YakAlertType` | `info` | info, warning, error, success. |
| `actionLabel` | `String?` | — | Optional link label (e.g. "Show More →"). |
| `onAction` | `VoidCallback?` | — | Called when action link is tapped. |
| `onDismiss` | `VoidCallback?` | — | Called when close (X) is tapped. |
| `backgroundColor` | `Color?` | white | Background color. |
| `borderRadius` | `double?` | theme | Corner radius. |
| `theme` | `YakAlertThemeData?` | — | Override theme for this alert. |

---

## Static method: YakAlert.show

Shows an alert at the top of the screen (below status bar) as an overlay. Returns a `Future<void>` that completes when the alert is dismissed.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `context` | `BuildContext` | required | For overlay and theme. |
| `title` | `String` | required | Alert title. |
| `message` | `String` | required | Body message. |
| `type` | `YakAlertType` | `info` | info, warning, error, success. |
| `actionLabel` | `String?` | — | Optional action link label. |
| `onAction` | `VoidCallback?` | — | Called when action is tapped (alert dismisses). |
| `onDismiss` | `VoidCallback?` | — | Called when close is tapped. |
| `backgroundColor` | `Color?` | white | Background color. |
| `duration` | `Duration?` | — | If set, alert auto-dismisses after this duration. |

---

## Examples

### Show error at top (e.g. login failed)
```dart
YakAlert.show(
  context,
  title: 'การเข้าสู่ระบบไม่สำเร็จ',
  message: 'การยืนยันตัวตนกับผู้ให้บริการไม่สมบูรณ์ โปรดเริ่มกระบวนการเข้าสู่ระบบใหม่อีกครั้ง',
  type: YakAlertType.error,
  onDismiss: () {},
);
```

### Info alert with action link
```dart
YakAlert.show(
  context,
  title: 'Some kind of alert!',
  message: 'This is an alert message that will be placed inside the body of this alert box.',
  type: YakAlertType.info,
  actionLabel: 'Show More →',
  onAction: () => navigateToDetails(),
);
```

### Success with auto-dismiss
```dart
YakAlert.show(
  context,
  title: 'Saved',
  message: 'Your changes have been saved.',
  type: YakAlertType.success,
  duration: Duration(seconds: 3),
);
```

### Inline YakAlert (in layout)
```dart
YakAlert(
  title: 'Warning',
  message: 'Please complete your profile before continuing.',
  type: YakAlertType.warning,
  actionLabel: 'Show More →',
  onAction: () {},
  onDismiss: () => setState(() => _showAlert = false),
)
```
