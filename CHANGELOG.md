# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v1.7.3] - 2026-04-20

**Title:** `v1.7.3 — Fix semantic color token mappings`

**Description:** Aligns `YakColor.semantic` mappings with the latest Semantic Color token set (per design spec), ensuring components using semantic tokens render the correct colors.

**Added**

- None

**Changed**

- None

**Fixed**

- **YakColorSemantic**:
  - `background.primaryThird` now maps to `Primary/100`
  - Added missing `textAndIcons.primarySecond` mapping to `Primary/500`

**Removed**

- None

---

## [v1.7.2] - 2026-04-03

**Title:** `v1.7.2 — Toggle label tap + color customization, modal close removal`

**Description:** Improves **YakToggleButton** usability by making the label area tappable (larger hit target) and adds simple color customization for track/thumb. Also removes the built-in close (X) button from **YakModal** to keep it container-only.

**Added**

- **YakToggleButton**:
  - Optional `label` (+ `labelStyle`, `labelSpacing`) to render a single tappable row (switch + text)
  - `color` shorthand for “on” track color (with `activeColor` taking precedence)
  - `activeThumbColor` and `inactiveThumbColor` for knob customization
- **Tests**:
  - Added coverage for toggling via label tap

**Changed**

- **Example app**:
  - `ToggleButtonPage` updated to demonstrate label tap behavior and custom colors (tracks + thumbs)

**Fixed**

- **YakToggleButton**:
  - Uses `activeThumbColor` (Flutter API) instead of deprecated `activeColor`

**Removed**

- **YakModal**:
  - Removed the built-in top-right close (X) button (consumers should provide their own close action inside `child`)

---

## [v1.7.1] - 2026-03-24

**Title:** `v1.7.1 — Thai font fallback and input label alignment`

**Description:** Improves typography rendering for multilingual apps by adding Thai fallback font support to Yak typography styles (resolved from the package directly for consumers), and aligns input label styling across form controls. Also includes the latest modal refresh and smooth dialog animation updates.

**Added**

- **Typography fonts**:
  - Added bundled `NotoSansThai` font family (Regular/Medium/SemiBold/Bold) to support Thai glyph fallback consistently

**Changed**

- **YakTypography**:
  - All semantic text styles now use `fontFamilyFallback: ['NotoSansThai']`
  - Added `package: 'yak_merchant_app_design_lib'` in generated `TextStyle`s so consumer apps resolve package fonts correctly
- **Input labels**:
  - Aligned label + required asterisk style to `YakTypography.semantic.textS.medium` across:
    - `YakTextInput`
    - `YakTextArea`
    - `YakSelect`
    - `YakDateInput`
    - `YakSearchInput`
- **YakSearchInput**:
  - Updated to semantic token-based label/border/error colors to match other inputs
  - Refined hint typography to `textXS.regular` and consistent label spacing
- **YakModal**:
  - Simplified to container-only API where users provide full content via `child`
  - `YakModal.show(...)` now uses smooth fade + subtle scale transition
  - Updated modal examples/docs in `README` and widget docs

**Fixed**

- Thai text in package typography now falls back reliably in consumer apps without requiring app-level font overrides

**Removed**

- None

---

## [v1.7.0] - 2026-03-19

**Title:** `v1.7.0 — Form controls refresh (buttons, radio, checkbox)`

**Description:** A major refresh of form controls to match the latest Figma/Supernova styles. Adds **YakCheckboxButton**, rewrites **YakRadioButton** with radio-dot visuals and sizing variants, and refines **YakButton** layout, disabled behavior, focus styling, and typography defaults. Also updates examples, docs, README, and missing semantic color tokens used by components.

**Added**

- **YakColor** – semantic background tokens:
  - `YakColor.semantic.background.primaryThird` → `Primary/25`
  - `YakColor.semantic.background.primaryFocus` → `Primary/100` (used for button focus ring)
- **YakButton** – new alignment control:
  - `contentAlignment` (`YakButtonContentAlignment.center` | `YakButtonContentAlignment.start`) for full-width buttons
- **YakCheckboxButton** – new checkbox control:
  - Stroke/fill variants, circle/rounded-square shapes, sizes S/M/L
  - Customizable `color`, `checkColor`, `labelStyle`, `subtitleStyle`
- **YakRadioButton** – new style controls:
  - `color` (main ring/fill color, default `YakColor.semantic.textAndIcons.primary`)
  - `checkColor` (inner dot color; if `color` is set, dot follows `color`)
  - `size` (`YakRadioSize.s`, `YakRadioSize.m`, `YakRadioSize.l`)
  - `labelStyle` and `subtitleStyle` for text style customization

**Changed**

- **YakButton** – styling & behavior:
  - Uses **YakColor semantic tokens** for button styling (background/text/stroke), plus new semantic focus token for the outer ring
  - Default **corner radius** is now **12**
  - Default **padding** is now **12×12** and default **icon/text gap** is **12**
  - Disabled state now **fades** (opacity) instead of swapping/deriving new colors
  - Full-width behavior: button only expands when `width` is set; otherwise sizes to content
  - Full-width centered layout now properly centers content even with a trailing icon
  - Focus/hover/press:
    - Secondary uses **border color change** (neutral → primary) without a separate ring, keeping fill unchanged
    - Primary keeps its **filled style** and does not draw an outline/ring overlay
  - Default text styles:
    - Primary → `YakTypography.semantic.textS.semibold`
    - Secondary/Ghost → `YakTypography.semantic.textS.regular`
  - Floating (FAB) variant now supports `heroTag` (default `null`) to prevent duplicate Hero tag crashes when multiple FABs are shown on the same route
- **Example app / docs**:
  - Updated YakButton “field-style” examples to match the provided UI screenshots and rely on defaults
  - **YakModal** updated to be a **container-only** dialog (users compose title/description/actions via `child`), with defaults: radius `12`, padding `24`, and recommended gap `16` (`YakModal.gap`)
  - `YakModal.show(...)` now uses a smooth, modern open transition (fade + subtle scale)

- **YakTextInput / YakTextArea**:
  - Updated to use **YakColor**/**YakTypography** tokens for borders, labels, placeholders, error, and disabled states
  - Disabled state styling refined for YakTextInput, plus example & docs updates
- **YakRadioButton**:
  - Rewritten from native `RadioListTile` rendering to custom radio indicator rendering for closer design matching
  - Indicator now uses radio-dot style (instead of checkmark), with tuned focused glow and disabled states
  - Indicator/text spacing tightened and large-size label alignment corrected (centered for single-line labels)
- **YakCheckboxButton**:
  - New checkbox indicator rendering with stroke/fill styles, focus glow, and bolder checkmark
- **Radio example page**:
  - `example/lib/pages/radio_page.dart` simplified to style-focused demos only (sizes, custom colors, disabled)
- **Checkbox example page**:
  - Added `example/lib/pages/checkbox_page.dart` and wired into example app routes/home list
- **README**:
  - Updated usage/docs for YakRadioButton and YakCheckboxButton (including label/subtitle style overrides)

**Fixed**

- **YakButton** – prevents text/icon row overflow by constraining and ellipsizing long labels when needed

**Removed**

- None

---

## [v1.6.2] - 2026-03-16

**Title:** `v1.6.2 — YakOtpInput autofocus`

**Description:** Adds an `autofocus` parameter to YakOtpInput so the first digit box can automatically receive focus when the widget is built. Docs and the example OTP page are updated with a focused-by-default demo to make keyboard and soft keyboard behavior easy to test.

**Added**

- **YakOtpInput** – new `autofocus` (`bool`, default `false`) parameter:
  - When `true`, the first digit box requests focus on build via `autofocus: true` on the first internal `TextField`
  - When `false` (default), behavior is unchanged and the input does not grab focus automatically
- **Docs** – `docs/widgets/yak_otp_input.md` updated:
  - Props table now documents the `autofocus` parameter and its default
  - 6-digit OTP example demonstrates `autofocus: true` for quick copy‑paste into apps
- **Example app** – `example/lib/pages/otp_input_page.dart`:
  - The primary “6-digit OTP” demo uses `autofocus: true` so the page opens with the first box focused for immediate typing

**Changed**

- None

**Fixed**

- None

**Removed**

- None

---

## [v1.6.1] - 2026-02-23

**Title:** `v1.6.1 — YakSearchInput & example`

**Description:** Adds **YakSearchInput**, a search input that behaves like YakTextInput but uses Text S/Regular (YakTypography) for input and placeholder, with 150% line height and semantic text colors (YakColor). Supports label, required indicator, placeholder, optional controller/focus node, error message, and enabled state. Example app gains a dedicated Search Input page demonstrating basic, required, error, disabled, and unlabeled variants.

**Added**

- **YakSearchInput** – New widget in `lib/inputs/yak_search_input.dart`:
  - **Styling:** Text S/Regular from `YakTypography.semantic.textS.regular`; input color `YakColor.semantic.textAndIcons.baseMain`, hint `baseSecond`; disabled uses `baseSecond`.
  - **Layout:** Same as YakTextInput – 16px border radius, 1.5px border (grey default, gold focused, red error), white background, 16px horizontal / 14px vertical padding.
  - **Parameters:** `label`, `isRequired`, `placeholder`, `controller`, `focusNode`, `errorMessage`, `onChanged`, `keyboardType`, `enabled` (default true). Owns and disposes controller/focus node when not provided.
- **Example app** – New route `/search-input` and **YakSearchInput** entry on home; `example/lib/pages/search_input_page.dart` with demos: basic search, required, error state, disabled, without label.
- **Library export** – `lib/yak_merchant_app_design_lib.dart`: exports `inputs/yak_search_input.dart`.

**Changed**

- None

**Fixed**

- None

**Removed**

- None

---

## [v1.6.0] - 2026-02-23

**Title:** `v1.6.0 — YakPinInput (PIN with current digit visible, previous as dots) & YakButton disabled param`

**Description:** Adds **YakPinInput**, a PIN entry widget where previously entered digits are shown as dots (•) and only the currently focused digit shows the actual number. Matches the design of rounded boxes, gold border on the active box, and light gray borders on filled/inactive boxes. Supports error state, backspace-to-previous-box, and completion callback. Documented in `docs/widgets/yak_pin_input.md` and demonstrated on the example app’s OTP input page. **YakButton** now uses an explicit `disabled` boolean instead of inferring disabled state from `onPressed: null`.

**Added**

- **YakPinInput** – New widget in `lib/inputs/yak_pin_input.dart`:
  - **Display:** Filled digits in non-focused boxes render as a single dot (•); the focused box shows the actual digit being entered.
  - **Layout:** One box per digit (default 6), configurable `boxSize` and `spacing`; boxes use rounded corners (12px), white background; active box has gold border (`#F4C430`), others light gray (`#E0E0E0`); layout shrinks on small screens via `LayoutBuilder`.
  - **Behavior:** Same as YakOtpInput: backspace in an empty box clears the previous box and moves focus back; typing a digit moves focus to the next box; `onChanged(String)` returns the full PIN; `onCompleted(String)` when all digits are filled.
  - **Parameters:** `length` (default 6), `errorMessage` (optional; when set, red borders and message below boxes), `onChanged`, `onCompleted`, `boxSize` (default 48), `spacing` (default 12), `textStyle`, `enabled` (default true).
  - **Implementation:** Each box uses a transparent `TextField` for input with an overlay `Text` that shows either the digit (when focused) or • (when filled); focus and key handling reuse the same pattern as YakOtpInput (per-box `FocusNode`, backspace handling in `onKeyEvent`).
- **YakPinInput docs** – `docs/widgets/yak_pin_input.md`: when to use, props table, examples (6-digit PIN, error state, custom size/spacing).
- **Example app** – OTP input page (`example/lib/pages/otp_input_page.dart`): new section “YakPinInput (current digit visible, previous as •)” with short description and a 6-digit `YakPinInput` wired to `onChanged` and `onCompleted`.

**Changed**

- **YakButton** – Disabled state is now controlled by an explicit `disabled` parameter (default `false`) instead of `onPressed: null`. Use `disabled: true` to show a disabled button while still optionally providing `onPressed` for when it becomes enabled. Example and docs updated to use `disabled: true`; tests updated accordingly.
- **README** – Input Components: added YakPinInput with one-line description (previous as dots, current digit visible, gold border). Documentation widget list: added link to YakPinInput doc. Examples: OTP input page now mentions YakPinInput demo.
- **Library export** – `lib/yak_merchant_app_design_lib.dart`: exports `inputs/yak_pin_input.dart`.

**Fixed**

- None

**Removed**

- None

---

## [v1.5.2] - 2026-02-17

**YakSelect icon rendering, YakOtpInput delete/focus, and example flag assets**

**Added**

- **YakSelect** – Item icons (e.g. `YakSelectItem(icon: SvgPicture.asset(...))`) use tight constraints so SVG assets render reliably; **compact** style applies a rounded clip (`ClipRRect`) only to the icon in the **selector**; overlay/dropdown list icons are not rounded
- **YakOtpInput** – Backspace deletes the current digit and moves focus to the previous box when the current box is empty; focused digit box shows themed border and fill (`borderFocused`, `fillFocused`) so the active box is clearly visible
- **YakOtpInput** – `errorMessage` parameter to show error state (red borders) and render the error message below the digit boxes
- Example assets: **ic_flag_th.svg** and **ic_flag_en.svg** (Thai and UK/English flags, converted from Android vector XML) with rounded-rect clip; used for language select and "Sign in with" in the select page

**Changed**

- Example app: language select and all flag options now use **ic_flag_th.svg** and **ic_flag_en.svg** instead of ic_thai.svg / ic_english.svg
- Example app: OTP input page includes an error-state demo for `YakOtpInput(errorMessage: ...)`
- README: YakSelect description and docs link updated to mention item icons and compact selector icon clip; YakOtpInput line updated for backspace, focus border, and error message; Examples section notes select page flag icons (ic_flag_th, ic_flag_en) and OTP error-state demo

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
