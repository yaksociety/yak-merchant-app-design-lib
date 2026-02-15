# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v1.5.0] - 2026-02-15

**Title:** `v1.5.0 — File upload (YakFileUpload)`

**Description:** Adds YakFileUpload, a configurable file upload component with drag-and-drop, optional label and instructions, vertical or horizontal drop zone layout, image thumbnail preview, and upload states (uploading with progress, success, failed). Supports custom upload sources (e.g. Take a photo, Choose file, Import from library) for platform-appropriate flows. Documented in `docs/widgets/yak_file_upload.md` with a full example in `example/lib/pages/file_upload_page.dart`.

**Added**
- **YakFileUpload** – file upload widget in `lib/file_uploads/yak_file_upload.dart`:
  - Empty state: dashed-border drop zone with icon and hint (vertical or horizontal layout)
  - Disabled state: greyed-out drop zone
  - Uploading: file card with thumbnail/icon, name, size, progress bar, cancel (X)
  - Success: file card with thumbnail, name, size, pill-style “Change” button, delete icon
  - Failed: file card with error styling and retry icon
- **YakFileUploadItem** – model with `name`, `sizeBytes`, `status` (uploading/success/failed), `progress`, optional `errorMessage`, optional `thumbnail` (ImageProvider for image preview)
- **YakFileUploadStatus** – enum: `uploading`, `success`, `failed`
- **YakFileUploadCallbacks** – `onPickRequested`, `onCancelUpload`, `onRetry`, `onRemove`, `onChangeRequested`, `onFilesDropped`
- **YakFileUploadSource** – custom upload option (label, icon, onSelected) for bottom sheet (e.g. Take a photo, Choose file, Import from library)
- **YakFileUploadDropZoneLayout** – enum: `vertical` (icon on top), `horizontal` (icon left, text right)
- Config: `label`, `isRequired` (red asterisk), `hintText`, `hintSubtext`, `maxFileSizeLabel`, `dropZoneLayout`, `instructions` (widget below drop zone), `changeButtonLabel`
- Widget doc: `docs/widgets/yak_file_upload.md` with API, states, configurable layout, custom sources, and best practices
- Example app: `example/lib/pages/file_upload_page.dart` with main upload (sources + thumbnail), configurable document upload (label + horizontal + instructions, full pick/upload/change/remove), disabled state, and state demo buttons
- README: File Upload section, YakFileUpload doc link, and usage snippets (basic + configurable)

**Changed**
- `lib/yak_merchant_app_design_lib.dart`: exports `file_uploads/yak_file_upload.dart`
- Example app: route `/file-upload` and home list entry for YakFileUpload; dependencies `file_picker`, `image_picker` in example `pubspec.yaml`

**Fixed**
- None

---

## [v1.4.0] - 2026-02-15

**Title:** `v1.4.0 — Radio button and radio group`

**Description:** Adds YakRadioButton and YakRadioGroup for single-choice selection. Use YakRadioGroup to wrap multiple options with shared groupValue/onChanged; each option supports label, optional subtitle, and optional per-option or group-level helper text with optional close action. Styled with YakColor (primary when selected, gray when unselected). Documented in docs/widgets/yak_radio_button.md and linked from the main README.

**Added**
- **YakRadioButton** – single radio option in `lib/buttons/yak_radio_button.dart` with `value`, `label`, optional `subtitle`, optional `helperText` (indented below option), optional `onHelperClose`; works inside YakRadioGroup (omit groupValue/onChanged) or standalone; customizable `activeColor` and `inactiveColor`
- **YakRadioGroup** – wrapper in `lib/buttons/yak_radio_button.dart` with `groupValue`, `onChanged`, `children` (YakRadioButton widgets), optional `helperText`, `onHelperClose`, `helperStyle`, `helperPadding`, `paddingTop`, `paddingBottom`
- Widget doc: `docs/widgets/yak_radio_button.md` with when-to-use, props tables for both widgets, and examples (group usage, group-level helper, subtitle, standalone, custom colors)
- README: YakRadioButton & YakRadioGroup in Button Components and Documentation widget list

**Changed**
- None

**Fixed**
- None

---

## [v1.3.0] - 2026-02-13

**Title:** `v1.3.0 — Sheets, alerts, and Google Sans font`

**Description:** Adds YakSheet for bottom sheets with optional drag handle and title, and YakAlert for top-of-screen banner alerts with icon, message, action link, and smooth animations. Bundles Google Sans font so apps get the typography font automatically. Both widgets support global theming and are documented with example pages.

**Added**
- **YakSheet** – bottom sheet in `lib/sheets/yak_sheet.dart` with optional drag handle, title, and `YakSheetThemeData`; `YakSheet.show(context, ...)` and use as content for `showModalBottomSheet`; docs in `docs/widgets/yak_sheet.md` and example in `example/lib/pages/sheet_page.dart`
- **YakAlert** – top-of-screen alert in `lib/alerts/yak_alert.dart` with icon, title, message, optional action link (“Show More →”), and dismiss (X); types: info, warning, error, success with distinct icon colors (blue, warning, danger, success); `YakAlertThemeData`; slide-down + fade-in / slide-up + fade-out animations; inline SVG icon (Material info symbol); default icon size 24; `YakAlert.show(context, ...)`; docs in `docs/widgets/yak_alert.md` and example in `example/lib/pages/alert_page.dart`
- **Google Sans font** – font family bundled in package (`fonts/` with Regular, Italic, Medium, SemiBold, Bold and italic variants); declared in `pubspec.yaml` under family `GoogleSans`; apps depending on the package get the font automatically (no app-level font setup required)
- Dependency: `flutter_svg` for alert icon rendering
- README: Sheets and Alerts sections, usage snippets, and doc links for YakSheet and YakAlert
- Example app: routes and home list entries for `/sheet` (YakSheet) and `/alert` (YakAlert)

**Changed**
- `yak_merchant_app_design_lib.dart`: exports `sheets/yak_sheet.dart` and `alerts/yak_alert.dart`
- **YakTypography** – docs and README updated to state that Google Sans is bundled with the package; `lib/theme/yak_typography.dart` doc comment no longer instructs apps to add font assets

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
