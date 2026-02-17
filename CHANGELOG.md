# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v1.5.2] - 2026-02-17

**YakSelect icon rendering and example flag assets**

**Added**

- **YakSelect** – Item icons (e.g. `YakSelectItem(icon: SvgPicture.asset(...))`) use tight constraints so SVG assets render reliably; **compact** style applies a rounded clip (`ClipRRect`) to the icon in both the selector and the dropdown list
- Example assets: **ic_flag_th.svg** and **ic_flag_en.svg** (Thai and UK/English flags, converted from Android vector XML) with rounded-rect clip; used for language select and "Sign in with" in the select page

**Changed**

- Example app: language select and all flag options now use **ic_flag_th.svg** and **ic_flag_en.svg** instead of ic_thai.svg / ic_english.svg
- README: YakSelect description and docs link updated to mention item icons and compact rounded icon; Examples section notes select page flag icons (ic_flag_th, ic_flag_en)

**Removed**

- Example app: **ic_flag_th.xml** and **ic_flag_en.xml** (replaced by SVG versions)

---

## [v1.5.1] - 2026-02-16

**YakButton enhancements**

**Added**

- **YakButton** – custom styling and field-style support:
  - **Stroke** – `stroke` (`BorderSide?`) to set custom border (primary/secondary/ghost)
  - **Rounded** – `borderRadius` (`double?`, default 8) for corner radius
  - **Padding** – `padding` (`EdgeInsetsGeometry?`) for inner button padding (default 24 horizontal, 12 vertical)
  - **Icons** – `leadingIcon` and `trailingIcon` (`IconData?`) with `iconSize` (default 20); or `leftIcon`/`rightIcon` (`Widget?`) for full control
  - **Label & required** – `label` (`String?`) shown above the button; `isRequired` (bool) shows red asterisk after label; optional `labelStyle`
  - Content row uses `MainAxisAlignment.spaceBetween` when a trailing icon is present (label/placeholder left, chevron right)
- Example app: "Label & required (field-style)" section with location field, province select, disabled district field, and optional field examples
- Docs: `docs/widgets/yak_button.md` updated with new props and examples

**Changed**

- README: YakButton section and widget doc link updated to describe new options (stroke, rounded, padding, icons, label/required)

**Fixed**

- **YakButton** – `effectivePadding` type corrected to `EdgeInsetsGeometry` (was `EdgeInsets`) to fix assignment from `padding ?? const EdgeInsets.symmetric(...)`

**YakSheet enhancements**

**Added**

- **YakSheet.show()** – optional parameters `showDragHandle`, `borderRadius`, and `padding` to override theme for a single sheet (e.g. `YakSheet.show(context, showDragHandle: false, child: ...)`)
- Example app: sheet page now uses `YakSheet.show()` for all four demos (simple, with title, no handle, options list); no direct `showModalBottomSheet` + builder

**Fixed**

- **YakSheet** – top corner `borderRadius` now renders correctly; sheet content is wrapped in `ClipRRect` so the modal’s rounded top corners are visible on all platforms

**YakSelect improvements (align with DropdownStyle.kt)**

**Added**

- **YakSelectStyle** – enum `compact`, `minimal`, `normal` (matches Android DropdownClass); affects selector text size/weight
- **YakSelect** – `style` (default `normal`), `visibleIcon` (default `true`), `buttonTextColor` (optional override)
- Theming via **YakColor**: border (error → danger600, focused/open → primary500, default → neutral700), background (disabled → neutral50), label and error text; border width 1, radius 12, padding 16×12; label spacing 8
- Chevron size 20, rotates 180° when dropdown is open; only shown when `items.length > 1`
- Dropdown menu: max height 200, rounded 12; selected item shows **check icon** (primary, size 12); item icon size 16 when `visibleIcon` is true; error message padding left 12, top 4
- Default placeholder text: `"Select an option"`

**Changed**

- **YakSelect** – Uses YakColor for all border, background, label, and text colors; label uses danger color when `errorMessage` is set
- Docs: `docs/widgets/yak_select.md` updated with YakSelectStyle, new props, behavior, and examples (style variants, error, disabled)
- Example app: select page adds compact style, with error, and disabled examples

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
