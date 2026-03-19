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
- **YakCheckboxButton** - Checkbox option (stroke/fill, circle/rounded-square, sizes S/M/L) with customizable `color`, `checkColor`, `labelStyle`, `subtitleStyle`
- **[YakRadioButton & YakRadioGroup](docs/widgets/yak_radio_button.md)** - Radio options (radio-dot style) for single-choice selection (delivery method, payment, size, etc.) with optional label/subtitle/helper text and style controls: `size` (S/M/L), `color` (ring/fill), `checkColor` (inner dot), `labelStyle`, `subtitleStyle`

### 📝 Input Components
- **[YakTextInput](docs/widgets/yak_text_input.md)** - Single-line text input with label, error states, and validation
- **[YakTextArea](docs/widgets/yak_text_area.md)** - Multi-line text area for addresses and longer content
- **[YakSelect](docs/widgets/yak_select.md)** - Dropdown/select aligned with Android DropdownStyle: label/required/error, border states (YakColor), style variants (compact/minimal/normal), optional `visibleIcon` with item icons (e.g. `YakSelectItem(icon: SvgPicture.asset(...))`), compact style uses rounded clip on the selector icon; check icon on selected item, chevron rotation when open
- **[YakOtpInput](docs/widgets/yak_otp_input.md)** - OTP/PIN input with multiple digit boxes; backspace deletes and moves to previous box; focused digit shows themed border (e.g. gold); `errorMessage` shows red-border error state + message
- **[YakPinInput](docs/widgets/yak_pin_input.md)** - PIN input where previous digits show as dots (•) and the current (focused) digit shows the actual number; gold border on active box, same behavior as YakOtpInput

### 📤 File Upload
- **[YakFileUpload](docs/widgets/yak_file_upload.md)** - File upload with drag-and-drop, optional label, vertical/horizontal drop zone layout, image thumbnail, progress/success/failed states, and optional instructions. Supports custom upload sources (e.g. Take a photo, Choose file, Import from library) and configurable hint, max file size, and Change button label.

### 📊 Indicators
- **[YakIndicator](docs/widgets/yak_indicator.md)** - Horizontal progress indicator with rounded ends and smooth animation

### 🃏 Cards
- **[YakCard](docs/widgets/yak_card.md)** - Universal card with optional decoration, padding, and tap; globally themed via `YakCardThemeData`

### 📄 Sheets
- **[YakSheet](docs/widgets/yak_sheet.md)** - Bottom sheet with optional drag handle and title; themed via `YakSheetThemeData`. Use `YakSheet.show(context, child: ...)` with optional `showDragHandle`, `borderRadius`, `padding`; top corners clip correctly with the set radius.

### 🪟 Modals
- **[YakModal](docs/widgets/yak_modal.md)** - Centered dialog container with close (X), rounded corners, and padding; **you provide all content** (title/description/actions) via `child`; themed via `YakModalThemeData`. Use `YakModal.show(context, child: ...)`.

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
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Subscribe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      const SizedBox(height: YakModal.gap),
      CheckboxListTile(title: Text('Guides'), value: false, onChanged: (_) {}),
      CheckboxListTile(title: Text('Resources'), value: true, onChanged: (_) {}),
      const SizedBox(height: YakModal.gap),
      YakButton(
        text: 'Done',
        variant: YakButtonVariant.primary,
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ),
);
```

**YakRadioGroup / YakRadioButton**
```dart
YakRadioGroup<String>(
  groupValue: _value,
  onChanged: (v) => setState(() => _value = v),
  children: const [
    YakRadioButton<String>(
      value: 'S',
      label: 'S',
      size: YakRadioSize.s,
    ),
    YakRadioButton<String>(
      value: 'M',
      label: 'M',
      size: YakRadioSize.m,
    ),
    YakRadioButton<String>(
      value: 'L',
      label: 'L',
      size: YakRadioSize.l,
    ),
  ],
)

// Custom color + dot color
YakRadioButton<String>(
  value: 'custom',
  groupValue: _value,
  onChanged: (v) => setState(() => _value = v),
  label: 'Custom',
  color: YakColor.semantic.textAndIcons.success,
  checkColor: YakColor.semantic.textAndIcons.success, // dot matches ring
)

// Custom label and subtitle text styles
YakRadioButton<String>(
  value: 'bank',
  groupValue: _value,
  onChanged: (v) => setState(() => _value = v),
  label: 'Bank transfer',
  subtitle: 'Pay within 24 hours',
  labelStyle: YakTypography.semantic.textM.medium,
  subtitleStyle: YakTypography.semantic.textXS.regular,
)
```

**YakCheckboxButton**
```dart
YakCheckboxButton(
  value: _checked,
  onChanged: (v) => setState(() => _checked = v),
  label: 'Option',
  subtitle: 'Optional subtitle',
  // Styling
  size: YakCheckboxSize.m,
  shape: YakCheckboxShape.roundedSquare,
  variant: YakCheckboxVariant.fill,
  color: YakColor.semantic.textAndIcons.primary,
  // Typography override
  labelStyle: YakTypography.semantic.textS.medium,
  subtitleStyle: YakTypography.semantic.textXS.regular,
)
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
- **YakCheckboxButton** – Checkbox options (stroke/fill, circle/rounded-square, sizes S/M/L, `color`, `checkColor`, `labelStyle`, `subtitleStyle`)
- [**YakRadioButton & YakRadioGroup**](docs/widgets/yak_radio_button.md) – Radio-dot options for single-choice (sizes S/M/L, `color`, `checkColor`, `labelStyle`, `subtitleStyle`, label/subtitle/helper text)
- [**YakTextInput**](docs/widgets/yak_text_input.md) – Single-line text input
- [**YakTextArea**](docs/widgets/yak_text_area.md) – Multi-line text area
- [**YakSelect**](docs/widgets/yak_select.md) – Dropdown/select (YakSelectStyle, visibleIcon, item icons e.g. ic_flag_th/ic_flag_en, compact rounded icon, label/error, check icon on selected)
- [**YakOtpInput**](docs/widgets/yak_otp_input.md) – OTP/PIN digit boxes (backspace to delete, focus border on active digit, error message support)
- [**YakPinInput**](docs/widgets/yak_pin_input.md) – PIN input (previous digits as •, current digit visible, gold border on active box)
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

Check out the `example/` directory for complete working examples of all components. The select page demonstrates **YakSelect** with SVG flag icons: language and “Sign in with” use `ic_flag_th.svg` and `ic_flag_en.svg` (Thai and UK flags) from `example/assets/icons/`. The OTP input page includes an **error state** demo and **YakPinInput** (current digit visible, previous as •).

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
