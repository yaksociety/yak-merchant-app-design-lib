# YakSheet

Bottom sheet with optional drag handle and title. Styling can be set globally via `YakSheetThemeData` in `ThemeData.extensions`; each sheet can override per property. Use `YakSheet.show(context, child: ...)` to display a modal sheet, or build `YakSheet` as the content for `showModalBottomSheet`.

---

## When to use

- Confirmation dialogs (confirm / cancel)
- Options or action menus (e.g. Edit, Share, Delete)
- Forms or filters that slide up from the bottom
- Any modal content that should appear as a bottom sheet with optional drag-to-dismiss

---

## Global theme: YakSheetThemeData

Set defaults for all sheets via `ThemeData.extensions`:

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `borderRadius` | `double` | `24` | Top corner radius of the sheet. |
| `backgroundColor` | `Color?` | white | Background color. |
| `dragHandleColor` | `Color?` | neutral700 | Color of the drag handle bar. |
| `dragHandleWidth` | `double` | `40` | Width of the drag handle. |
| `dragHandleHeight` | `double` | `4` | Height (thickness) of the drag handle. |
| `padding` | `EdgeInsetsGeometry?` | `(24, 0, 24, 24)` | Padding around sheet content (excluding handle area). |
| `showDragHandle` | `bool` | `true` | Whether to show the drag handle at the top. |

Example:
```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      YakSheetThemeData(
        borderRadius: 24,
        backgroundColor: YakColor.primitive.base.white,
        showDragHandle: true,
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
    ],
  ),
);
```

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `child` | `Widget` | required | Sheet content. |
| `title` | `Widget?` | — | Optional title shown below the drag handle. |
| `backgroundColor` | `Color?` | theme | Background color. |
| `borderRadius` | `double?` | theme | Top corner radius. |
| `padding` | `EdgeInsetsGeometry?` | theme | Padding around content. |
| `showDragHandle` | `bool?` | theme | Whether to show the drag handle. |
| `dragHandleColor` | `Color?` | theme | Drag handle bar color. |
| `dragHandleWidth` | `double?` | theme | Drag handle width. |
| `dragHandleHeight` | `double?` | theme | Drag handle height (thickness). |
| `isScrollControlled` | `bool` | `true` | Whether the sheet can expand to full height (used by `YakSheet.show`). |

---

## Static method: YakSheet.show

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `context` | `BuildContext` | required | Used for navigator and theme. |
| `child` | `Widget` | required | Sheet body. |
| `title` | `Widget?` | — | Optional title below the drag handle. |
| `backgroundColor` | `Color?` | theme | Sheet background. |
| `barrierColor` | `Color?` | `Colors.black54` | Scrim behind the sheet. |
| `shape` | `ShapeBorder?` | rounded top | Sheet shape. |
| `isScrollControlled` | `bool` | `true` | Allow sheet to use more height. |
| `isDismissible` | `bool` | `true` | Tap outside to close. |
| `enableDrag` | `bool` | `true` | Drag down to close. |

Returns `Future<T?>` (e.g. value passed to `Navigator.pop(context, value)`).

---

## Examples

### Simple sheet (YakSheet.show)
```dart
YakSheet.show(
  context,
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text('Sheet content. Drag handle at top by default.'),
  ),
);
```

### Sheet with title
```dart
YakSheet.show(
  context,
  title: Text(
    'Confirm action',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Do you want to proceed?'),
      SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context), child: Text('Confirm')),
        ],
      ),
    ],
  ),
);
```

### Sheet without drag handle (custom modal)
```dart
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (context) => YakSheet(
    showDragHandle: false,
    borderRadius: 24,
    child: Text('This sheet has no drag handle.'),
  ),
);
```

### Options menu (YakSheet as content)
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (context) => YakSheet(
    title: Text('Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(leading: Icon(Icons.edit), title: Text('Edit'), onTap: () => Navigator.pop(context)),
        ListTile(leading: Icon(Icons.share), title: Text('Share'), onTap: () => Navigator.pop(context)),
        ListTile(
          leading: Icon(Icons.delete, color: YakColor.primitive.danger.danger500),
          title: Text('Delete', style: TextStyle(color: YakColor.primitive.danger.danger500)),
          onTap: () => Navigator.pop(context),
        ),
      ],
    ),
  ),
);
```
