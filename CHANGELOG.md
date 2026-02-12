# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v1.1.0] - 2026-02-12

**Title:** `v1.1.0 — Theme tokens, indicator, and example pages`

**Description:** Adds YakColor and YakTypography theme tokens (aligned with the Android merchant app), theme documentation, a new animated YakIndicator widget, and an example app with a dedicated page per widget. README and typography API adjustments for compatibility.

**Added**
- **YakColor** – color palette in `lib/theme/yak_color.dart`: primitive (Primary, Neutral, Gray, Danger, Success, Warning, Blue) and semantic (Background, TextAndIcons, Stroke)
- **YakTypography** – typography in `lib/theme/yak_typography.dart`: primitive (font sizes, weights, letter spacing) and semantic (Headings, Text L/M/S/XS/XXS), plus `textTheme` and `materialTypography` for `ThemeData`
- **YakIndicator** – rounded, smoothly animated horizontal progress indicator in `lib/indicators/yak_indicator.dart` with optional percentage bubble and example page in `example/lib/pages/indicator_page.dart`
- Theme docs: `docs/theme/yak_color.md` and `docs/theme/yak_typography.md` with usage and examples
- Example app: home list and separate page per widget (YakButton, YakToggleButton, YakTextInput, YakTextArea, YakSelect, YakOtpInput, YakIndicator)

**Changed**
- Main README: removed inline usage section (each widget has its own doc); added Theme section, Design System usage snippets, and links to theme docs
- `yak_merchant_app_design_lib.dart`: exports `indicators/yak_indicator.dart` for package consumers
- `YakTypography.materialTypography` now builds from a `TextTheme` (Typography `black`/`white`) for Flutter Typography API compatibility
- **YakSelect**: dropdown opens with smooth fade + scale animation; tighter spacing between list items and smaller gap between selector field and dropdown list

**Fixed**
- Typography constructor: no longer passes `displayLarge` etc. into `Typography()`; uses `TextTheme` and `Typography(black:, white:)` instead

---

## [v1.0.0] - 2026-02-12

**Title:** `v1.0.0 — Initial release`

**Added**
- YakButton – unified button with 5 variants (primary, secondary, ghost, icon, floating)
- YakToggleButton – on/off toggle switch
- YakTextInput – single-line text input with label, placeholder, error states, and `isRequired` indicator
- YakTextArea – multi-line text area for addresses and longer content
- YakSelect – dropdown/select with optional icons per item; chevron hidden when only 1 item
- YakOtpInput – OTP/PIN input with multiple digit boxes
- Per-widget docs in `docs/widgets/` with API reference and examples
- Main README with clickable links to each widget doc

**Changed**
- None

**Fixed**
- None

**Breaking**
- None
