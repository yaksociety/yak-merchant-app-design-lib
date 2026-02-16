# Yak Merchant App Design Library

A Flutter design system library for **Yak Merchant App**, providing reusable UI components that follow consistent design guidelines and best practices.

## 📦 What This Library Contains

This library provides pre-built UI components for the Yak Merchant App:

### 🎯 Button Components
- **[YakButton](docs/widgets/yak_button.md)** - Unified button component with 5 variants:
  - `primary` - Main action button (gold background)
  - `secondary` - Outlined button for secondary actions
  - `ghost` - Transparent button for subtle actions
  - `icon` - Icon-only button (circular or square)
  - `floating` - Floating action button (FAB)
  - Custom styling: `stroke`, `borderRadius`, `padding`; leading/trailing icons (`leadingIcon`, `trailingIcon`, or `leftIcon`/`rightIcon`); optional `label` with `isRequired` (red asterisk) for field-style buttons; content uses space-between layout when a trailing icon is set.
- **[YakToggleButton](docs/widgets/yak_toggle_button.md)** - Toggle switch button for on/off states
- **[YakRadioButton & YakRadioGroup](docs/widgets/yak_radio_button.md)** - Radio options for single-choice selection (delivery method, payment, size, etc.) with optional label, subtitle, and per-option or group-level helper text

### 📝 Input Components
- **[YakTextInput](docs/widgets/yak_text_input.md)** - Single-line text input with label, error states, and validation
- **[YakTextArea](docs/widgets/yak_text_area.md)** - Multi-line text area for addresses and longer content
- **[YakSelect](docs/widgets/yak_select.md)** - Dropdown/select with optional icons per item
- **[YakOtpInput](docs/widgets/yak_otp_input.md)** - OTP/PIN input with multiple digit boxes

### 📤 File Upload
- **[YakFileUpload](docs/widgets/yak_file_upload.md)** - File upload with drag-and-drop, optional label, vertical/horizontal drop zone layout, image thumbnail, progress/success/failed states, and optional instructions. Supports custom upload sources (e.g. Take a photo, Choose file, Import from library) and configurable hint, max file size, and Change button label.

### 📊 Indicators
- **[YakIndicator](docs/widgets/yak_indicator.md)** - Horizontal progress indicator with rounded ends and smooth animation

### 🃏 Cards
- **[YakCard](docs/widgets/yak_card.md)** - Universal card with optional decoration, padding, and tap; globally themed via `YakCardThemeData`

### 📄 Sheets
- **[YakSheet](docs/widgets/yak_sheet.md)** - Bottom sheet with optional drag handle and title; themed via `YakSheetThemeData`. Use `YakSheet.show(context, child: ...)` with optional `showDragHandle`, `borderRadius`, `padding`; top corners clip correctly with the set radius.

### 🪟 Modals
- **[YakModal](docs/widgets/yak_modal.md)** - Centered dialog with optional header icon (info/success/warning/error), title, description, and **custom child** (forms, images, checkboxes, toggles, etc.); optional Cancel + Continue buttons; close (X); themed via `YakModalThemeData`. Use `YakModal.show(context, child: ...)`.

### 🔔 Alerts
- **[YakAlert](docs/widgets/yak_alert.md)** - Banner alert at the top of the screen with icon, title, message, optional action link, and dismiss; types: info, warning, error, success. Use `YakAlert.show(context, ...)` to display as overlay.

### 🎨 Theme
- **[YakColor](docs/theme/yak_color.md)** - Color palette with primitive (Primary, Neutral, Gray, Danger, Success, Warning, Blue) and semantic (Background, TextAndIcons, Stroke) tokens
- **[YakTypography](docs/theme/yak_typography.md)** - Typography system with primitive (font sizes, weights, letter spacing) and semantic (Headings, Text L/M/S/XS/XXS) styles, plus Material 3 compatible typography

All components support:
- ✅ Loading states
- ✅ Disabled states
- ✅ Error handling
- ✅ Customizable styling
- ✅ Consistent spacing and typography
- ✅ Accessible design

---

## 🚀 Installation

Add this package to your Flutter project's `pubspec.yaml`:

```yaml
dependencies:
  yak_merchant_app_design_lib:
    git:
      url: https://github.com/yaksociety/yak-merchant-app-design-lib.git
      ref: main
```

Then run:
```bash
flutter pub get
```

---

## 🎨 Design System

The library provides theme tokens aligned with the Android merchant app. See [YakColor](docs/theme/yak_color.md) and [YakTypography](docs/theme/yak_typography.md) for full usage and examples.

### Usage

**YakColor**
```dart
YakColor.primitive.primary.primary500
YakColor.semantic.textAndIcons.baseMain
YakColor.semantic.background.primaryMain
YakColor.semantic.stroke.base
```

**YakTypography**
```dart
Text('Title', style: YakTypography.semantic.heading1.semibold)
Text('Body', style: YakTypography.semantic.textM.regular)

MaterialApp(
  theme: ThemeData(typography: YakTypography.materialTypography),
  ...,
)
```

**Font**: Uses Google Sans, bundled with the package (no extra setup needed).

**YakSheet**
```dart
// Simple modal sheet
YakSheet.show(context, child: Text('Content'));

// With title
YakSheet.show(
  context,
  title: Text('Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  child: YourContent(),
);

// As content for showModalBottomSheet
showModalBottomSheet(
  context: context,
  builder: (context) => YakSheet(title: Text('Options'), child: ...),
);
```

**YakModal**
```dart
YakModal.show(
  context,
  title: 'Subscribe',
  description: 'Choose what you want to receive.',
  headerIconType: YakModalIconType.info,
  child: Column(
    children: [
      CheckboxListTile(title: Text('Guides'), value: false, onChanged: (_) {}),
      CheckboxListTile(title: Text('Resources'), value: true, onChanged: (_) {}),
    ],
  ),
  primaryLabel: 'Continue',
  cancelLabel: 'Cancel',
);
```

**YakAlert**
```dart
// Show at top of screen (e.g. login failed)
YakAlert.show(
  context,
  title: 'Login failed',
  message: 'Identity verification incomplete. Please try again.',
  type: YakAlertType.error,
);

// With action link and auto-dismiss
YakAlert.show(
  context,
  title: 'Some kind of alert!',
  message: 'This is an alert message in the body.',
  type: YakAlertType.info,
  actionLabel: 'Show More →',
  onAction: () => {},
  duration: Duration(seconds: 4),
);
```

**YakFileUpload**
```dart
// Basic: single pick callback
YakFileUpload(
  value: _fileItem,
  acceptedTypes: const ['jpg', 'png', 'pdf'],
  callbacks: YakFileUploadCallbacks(
    onPickRequested: () async {
      final result = await FilePicker.platform.pickFiles(...);
      if (result != null) setState(() => _fileItem = YakFileUploadItem(...));
    },
    onRemove: () => setState(() => _fileItem = null),
  ),
);

// Configurable: label, horizontal layout, max size, instructions
YakFileUpload(
  value: _fileItem,
  label: 'Professional license in Thailand',
  isRequired: true,
  hintText: 'Attach image or file for upload',
  maxFileSizeLabel: 'max 2 MB',
  dropZoneLayout: YakFileUploadDropZoneLayout.horizontal,
  instructions: Column(children: [Text('Please attach...'), _bullet('...')]),
  callbacks: YakFileUploadCallbacks(onPickRequested: _pickDocument, onRemove: _remove),
);
```

---

## 📖 Documentation

Each widget and theme token has its own doc with API reference and examples:

**Widgets**
- [**YakButton**](docs/widgets/yak_button.md) – Buttons (primary, secondary, ghost, icon, FAB; label/required, stroke, rounded, padding, leading/trailing icons)
- [**YakToggleButton**](docs/widgets/yak_toggle_button.md) – On/off toggle switch
- [**YakRadioButton & YakRadioGroup**](docs/widgets/yak_radio_button.md) – Radio options for single-choice (label, subtitle, helper text)
- [**YakTextInput**](docs/widgets/yak_text_input.md) – Single-line text input
- [**YakTextArea**](docs/widgets/yak_text_area.md) – Multi-line text area
- [**YakSelect**](docs/widgets/yak_select.md) – Dropdown/select
- [**YakOtpInput**](docs/widgets/yak_otp_input.md) – OTP/PIN digit boxes
- [**YakFileUpload**](docs/widgets/yak_file_upload.md) – File upload (drag-and-drop, label, horizontal/vertical layout, thumbnail, instructions)
- [**YakIndicator**](docs/widgets/yak_indicator.md) – Progress indicator
- [**YakCard**](docs/widgets/yak_card.md) – Universal card
- [**YakSheet**](docs/widgets/yak_sheet.md) – Bottom sheet (drag handle, title, `YakSheet.show()`; optional `showDragHandle`, `borderRadius`, `padding`; rounded top corners)
- [**YakModal**](docs/widgets/yak_modal.md) – Centered modal (icon, title, description, custom child, `YakModal.show()`)
- [**YakAlert**](docs/widgets/yak_alert.md) – Top-of-screen alert (info, warning, error, success, `YakAlert.show()`)

**Theme**
- [**YakColor**](docs/theme/yak_color.md) – Color palette
- [**YakTypography**](docs/theme/yak_typography.md) – Typography system

---

## 📚 Examples

Check out the `example/` directory for complete working examples of all components.

To run the example app:
```bash
cd example
flutter run
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🐛 Issues

If you encounter any issues or have suggestions, please file them on the [issue tracker](https://github.com/yaksociety/yak-merchant-app-design-lib/issues).

## 📄 License

See [LICENSE](LICENSE) for details.
