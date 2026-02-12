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
- **[YakToggleButton](docs/widgets/yak_toggle_button.md)** - Toggle switch button for on/off states

### 📝 Input Components
- **[YakTextInput](docs/widgets/yak_text_input.md)** - Single-line text input with label, error states, and validation
- **[YakTextArea](docs/widgets/yak_text_area.md)** - Multi-line text area for addresses and longer content
- **[YakSelect](docs/widgets/yak_select.md)** - Dropdown/select with optional icons per item
- **[YakOtpInput](docs/widgets/yak_otp_input.md)** - OTP/PIN input with multiple digit boxes

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

The library follows these design principles:

- **Color Scheme**: Gold/Yellow (#F4C430) primary color with black text
- **Spacing**: 8px grid system with consistent padding
- **Typography**: Font size 16px with 0.15 letter spacing and 600 font weight
- **Accessibility**: Proper disabled states, touch targets, and visual feedback

---

## 📖 Widget Documentation

Each widget has its own README with API reference and examples. Click a widget to view its docs:

- [**YakButton**](docs/widgets/yak_button.md) – Buttons (primary, secondary, ghost, icon, FAB)
- [**YakToggleButton**](docs/widgets/yak_toggle_button.md) – On/off toggle switch
- [**YakTextInput**](docs/widgets/yak_text_input.md) – Single-line text input
- [**YakTextArea**](docs/widgets/yak_text_area.md) – Multi-line text area
- [**YakSelect**](docs/widgets/yak_select.md) – Dropdown/select
- [**YakOtpInput**](docs/widgets/yak_otp_input.md) – OTP/PIN digit boxes

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
