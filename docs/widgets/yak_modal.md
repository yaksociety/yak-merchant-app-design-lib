# YakModal

Centered modal dialog container with rounded corners, padding, and a close (X). **YakModal does not impose any internal structure**—you provide everything (title, description, actions) via the `child`. Use `YakModal.show(context, child: ...)` to display via `showDialog`, or build `YakModal` as the dialog content. Styling via `YakModalThemeData`.

You can add any elements inside the modal via the **child** parameter: images, forms, inputs, checkboxes, toggles, file upload UI, etc.

---

## When to use

- Confirmations (e.g. with Cancel + Continue)
- Forms (login, sign up, add note)
- Selection (checkboxes, toggles, dropdowns)
- Photo/image preview with actions
- File upload with drop zone
- Any dialog that needs a consistent wrapper (rounded corners, close X, padding) around custom content

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
| `gap` | `double` | `16` | Recommended spacing for elements inside the modal (also available as `YakModal.gap`). |

---

## Props (YakModal widget)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `child` | `Widget` | required | Full modal content (you provide title/description/actions layout). |
| `onClose` | `VoidCallback?` | — | Called when close (X) is pressed. |
| `backgroundColor` | `Color?` | theme | Background color. |
| `borderRadius` | `double?` | theme | Corner radius. |
| `padding` | `double?` | theme | Padding around content. |
| `theme` | `YakModalThemeData?` | — | Override theme for this modal. |

---

## Static method: YakModal.show

Shows a modal dialog. Returns a `Future<T?>` that completes when the dialog is closed.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `context` | `BuildContext` | required | For dialog and theme. |
| `child` | `Widget` | required | Full modal content. |
| `onClose` | `VoidCallback?` | — | Close (X) callback (default: pop). |
| `backgroundColor` | `Color?` | — | Background color. |
| `borderRadius` | `double?` | — | Corner radius. |
| `padding` | `double?` | — | Padding around content. |
| `barrierDismissible` | `bool` | `true` | Tap outside to close. |

---

## Examples

### Basic modal (title + description + actions composed by you)
```dart
YakModal.show(
  context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text('Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      const SizedBox(height: YakModal.gap),
      Text('Add a photo to your profile.', style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: YakModal.gap),
      Image.asset('assets/photo.png'),
      const SizedBox(height: YakModal.gap),
      Row(
        children: [
          Expanded(
            child: YakButton(
              text: 'Cancel',
              variant: YakButtonVariant.secondary,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: YakModal.gap),
          Expanded(
            child: YakButton(
              text: 'Continue',
              variant: YakButtonVariant.primary,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ],
  ),
);
```

### Custom content (form inputs)
```dart
YakModal.show(
  context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text('Add a note', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      const SizedBox(height: YakModal.gap),
      YakTextInput(label: 'Project', hint: 'Label Academy'),
      const SizedBox(height: YakModal.gap),
      YakTextArea(label: 'Note', hint: 'Enter note...'),
      const SizedBox(height: YakModal.gap),
      YakButton(
        text: 'Save',
        variant: YakButtonVariant.primary,
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ),
);
```

### As dialog content (custom showDialog)
```dart
showDialog(
  context: context,
  builder: (context) => YakModal(
    child: YourWidget(),
    onClose: () => Navigator.pop(context),
  ),
);
```
