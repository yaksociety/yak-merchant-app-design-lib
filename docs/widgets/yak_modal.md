# YakModal

Centered modal dialog with optional header icon or image, title, description, **custom child content**, and optional Cancel + Continue buttons. Use `YakModal.show(context, child: ...)` to display via `showDialog`, or build `YakModal` as the dialog content. Styling via `YakModalThemeData`.

You can add any elements inside the modal via the **child** parameter: images, forms, inputs, checkboxes, toggles, file upload UI, etc.

---

## When to use

- Confirmations (e.g. with Cancel + Continue)
- Forms (login, sign up, add note)
- Selection (checkboxes, toggles, dropdowns)
- Photo/image preview with actions
- File upload with drop zone
- Any dialog that needs a consistent wrapper (rounded corners, close X, optional icon/title/description and action buttons) around custom content

---

## Header icon types

| Type | Color | Use case |
|------|--------|----------|
| `YakModalIconType.info` | Blue | General information |
| `YakModalIconType.success` | Green | Success / confirmation |
| `YakModalIconType.warning` | Orange | Warning |
| `YakModalIconType.error` | Red | Error; pair with `primaryIsDanger: true` for red Continue button |

---

## Global theme: YakModalThemeData

Set defaults for all modals via `ThemeData.extensions`:

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `borderRadius` | `double` | `12` | Corner radius. |
| `elevation` | `double` | `8` | Shadow depth. |
| `shadowColor` | `Color?` | — | Shadow color. |
| `backgroundColor` | `Color?` | white | Background color. |
| `padding` | `double` | `24` | Padding around content. |
| `headerIconSize` | `double` | `48` | Size of the header icon circle. |
| `titleDescriptionSpacing` | `double` | `8` | Space between title and description. |
| `contentTopSpacing` | `double` | `20` | Space above child. |
| `actionsTopSpacing` | `double` | `24` | Space above action buttons. |
| `actionsSpacing` | `double` | `12` | Space between Cancel and Continue. |

---

## Props (YakModal widget)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `child` | `Widget` | required | Main content; add any widgets (forms, images, lists, etc.). |
| `title` | `String?` | — | Optional title below header. |
| `description` | `String?` | — | Optional description below title. |
| `headerIcon` | `Widget?` | — | Optional custom header widget. |
| `headerIconType` | `YakModalIconType?` | — | Optional preset icon (info/success/warning/error) in colored circle. |
| `headerImage` | `Widget?` | — | Optional image/widget at the very top. |
| `cancelLabel` | `String?` | — | Cancel button label (e.g. "Cancel"). |
| `onCancel` | `VoidCallback?` | — | Called when cancel is pressed. |
| `primaryLabel` | `String?` | — | Primary button label (e.g. "Continue"). |
| `onPrimary` | `VoidCallback?` | — | Called when primary is pressed. |
| `primaryIsDanger` | `bool` | `false` | When true, primary button is red (for errors/destructive). |
| `onClose` | `VoidCallback?` | — | Called when close (X) is pressed. |
| `backgroundColor` | `Color?` | theme | Background color. |
| `borderRadius` | `double?` | theme | Corner radius. |
| `theme` | `YakModalThemeData?` | — | Override theme for this modal. |

---

## Static method: YakModal.show

Shows a modal dialog. Returns a `Future<T?>` that completes when the dialog is closed.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `context` | `BuildContext` | required | For dialog and theme. |
| `child` | `Widget` | required | Main content. |
| `title` | `String?` | — | Optional title. |
| `description` | `String?` | — | Optional description. |
| `headerIcon` | `Widget?` | — | Optional custom header. |
| `headerIconType` | `YakModalIconType?` | — | Optional preset icon. |
| `headerImage` | `Widget?` | — | Optional top image. |
| `cancelLabel` | `String?` | — | Cancel button label. |
| `onCancel` | `VoidCallback?` | — | Cancel callback (default: pop). |
| `primaryLabel` | `String?` | — | Primary button label. |
| `onPrimary` | `VoidCallback?` | — | Primary callback (default: pop). |
| `primaryIsDanger` | `bool` | `false` | Red primary button. |
| `onClose` | `VoidCallback?` | — | Close (X) callback (default: pop). |
| `backgroundColor` | `Color?` | — | Background color. |
| `borderRadius` | `double?` | — | Corner radius. |
| `barrierDismissible` | `bool` | `true` | Tap outside to close. |

---

## Examples

### Simple (title + child + actions)
```dart
YakModal.show(
  context,
  title: 'Photo',
  description: 'Add a photo to your profile.',
  child: Image.asset('assets/photo.png'),
  primaryLabel: 'Continue',
  cancelLabel: 'Cancel',
);
```

### With header icon (info)
```dart
YakModal.show(
  context,
  headerIconType: YakModalIconType.info,
  title: 'Subscribe',
  description: 'Choose what you want to receive.',
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CheckboxListTile(title: Text('Guides'), value: false, onChanged: (_) {}),
      CheckboxListTile(title: Text('Resources'), value: true, onChanged: (_) {}),
    ],
  ),
  primaryLabel: 'Continue',
  cancelLabel: 'Cancel',
);
```

### Error modal (red primary button)
```dart
YakModal.show(
  context,
  headerIconType: YakModalIconType.error,
  title: 'Error',
  description: 'Something went wrong. Please try again.',
  child: const SizedBox.shrink(),
  primaryLabel: 'Continue',
  primaryIsDanger: true,
  cancelLabel: 'Cancel',
);
```

### Custom content (form inputs)
```dart
YakModal.show(
  context,
  title: 'Add a note',
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      YakTextInput(label: 'Project', hint: 'Label Academy'),
      SizedBox(height: 16),
      YakTextArea(label: 'Note', hint: 'Enter note...'),
    ],
  ),
  primaryLabel: 'Save',
  cancelLabel: 'Cancel',
);
```

### As dialog content (custom showDialog)
```dart
showDialog(
  context: context,
  builder: (context) => YakModal(
    title: 'Custom',
    child: YourWidget(),
    primaryLabel: 'OK',
    onPrimary: () => Navigator.pop(context),
    onClose: () => Navigator.pop(context),
  ),
);
```
