# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v1.3.0] - 2026-02-13

**Title:** `v1.3.0 — Sheets and alerts`

**Description:** Adds YakSheet for bottom sheets with optional drag handle and title, and YakAlert for top-of-screen banner alerts with icon, message, action link, and smooth animations. Both support global theming and are documented with example pages.

**Added**
- **YakSheet** – bottom sheet in `lib/sheets/yak_sheet.dart` with optional drag handle, title, and `YakSheetThemeData`; `YakSheet.show(context, ...)` and use as content for `showModalBottomSheet`; docs in `docs/widgets/yak_sheet.md` and example in `example/lib/pages/sheet_page.dart`
- **YakAlert** – top-of-screen alert in `lib/alerts/yak_alert.dart` with icon, title, message, optional action link (“Show More →”), and dismiss (X); types: info, warning, error, success with distinct icon colors (blue, warning, danger, success); `YakAlertThemeData`; slide-down + fade-in / slide-up + fade-out animations; inline SVG icon (Material info symbol); default icon size 24; `YakAlert.show(context, ...)`; docs in `docs/widgets/yak_alert.md` and example in `example/lib/pages/alert_page.dart`
- Dependency: `flutter_svg` for alert icon rendering
- README: Sheets and Alerts sections, usage snippets, and doc links for YakSheet and YakAlert
- Example app: routes and home list entries for `/sheet` (YakSheet) and `/alert` (YakAlert)

**Changed**
- `yak_merchant_app_design_lib.dart`: exports `sheets/yak_sheet.dart` and `alerts/yak_alert.dart`

**Fixed**
- None

---

## [v1.2.0] - 2026-02-12

**Title:** `v1.2.0 — Cards, indicator, and select polish`

**Description:** Adds a universal YakCard widget with global theming, introduces YakIndicator as a reusable progress indicator, and refines YakSelect behavior and spacing. Docs and example pages are updated accordingly.

**Added**
- **YakIndicator** – rounded, smoothly animated horizontal progress indicator in `lib/indicators/yak_indicator.dart` with optional percentage bubble and example page in `example/lib/pages/indicator_page.dart`
- **YakCard** – universal card widget in `lib/cards/yak_card.dart` with `YakCardThemeData` theme extension and example page in `example/lib/pages/card_page.dart`
- Widget docs: `docs/widgets/yak_indicator.md` and `docs/widgets/yak_card.md` for API reference and examples

**Changed**
- **YakSelect**: dropdown opens with smooth fade + scale animation; tighter spacing between list items and smaller gap between selector field and dropdown list
- Main README: lists YakIndicator and YakCard in component overview and widget docs
- `yak_merchant_app_design_lib.dart`: exports `indicators/yak_indicator.dart` and `cards/yak_card.dart` for package consumers

**Fixed**
- **YakIndicator**: type-safety and clamping improvements to avoid runtime errors and ensure smooth 0–100% animation

---

## [v1.1.0] - 2026-02-12

**Title:** `v1.1.0 — Theme tokens and example pages`

**Description:** Adds YakColor and YakTypography theme tokens (aligned with the Android merchant app), theme documentation, and an example app with a dedicated page per widget. README and typography API adjustments for compatibility.

**Added**
- **YakColor** – color palette in `lib/theme/yak_color.dart`: primitive (Primary, Neutral, Gray, Danger, Success, Warning, Blue) and semantic (Background, TextAndIcons, Stroke)
- **YakTypography** – typography in `lib/theme/yak_typography.dart`: primitive (font sizes, weights, letter spacing) and semantic (Headings, Text L/M/S/XS/XXS), plus `textTheme` and `materialTypography` for `ThemeData`
- Theme docs: `docs/theme/yak_color.md` and `docs/theme/yak_typography.md` with usage and examples
- Example app: home list and separate page per widget (YakButton, YakToggleButton, YakTextInput, YakTextArea, YakSelect, YakOtpInput)

**Changed**
- Main README: removed inline usage section (each widget has its own doc); added Theme section, Design System usage snippets, and links to theme docs
- `YakTypography.materialTypography` now builds from a `TextTheme` (Typography `black`/`white`) for Flutter Typography API compatibility

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
