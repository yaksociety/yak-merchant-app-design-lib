# YakCard

Universal card that wraps any content with optional decoration, padding, and tap. Styling can be set globally via `YakCardThemeData` in `ThemeData.extensions`; each card can override per property.

---

## When to use

- Content blocks (text, lists, images)
- Selectable tiles (e.g. menu options with image + title)
- Settings or list containers
- Any rounded, bordered, or elevated container

---

## Global theme: YakCardThemeData

Set defaults for all cards via `ThemeData.extensions`:

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `borderRadius` | `double` | `12` | Corner radius. |
| `color` | `Color?` | white | Background color. |
| `elevation` | `double` | `0` | Shadow depth (0 = no shadow). |
| `shadowColor` | `Color?` | — | Shadow color when elevation > 0. |
| `borderColor` | `Color?` | — | Border color when borderWidth > 0. |
| `borderWidth` | `double` | `0` | Border width (0 = no border). |
| `padding` | `EdgeInsetsGeometry?` | `16` | Default padding around child. |
| `clipBehavior` | `Clip` | `Clip.none` | Clip content to rounded rect. |

Example:
```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      YakCardThemeData(
        borderRadius: 12,
        color: Colors.white,
        elevation: 2,
        padding: EdgeInsets.all(16),
      ),
    ],
  ),
);
```

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `child` | `Widget` | required | Card content (text, image, list, custom layout). |
| `onTap` | `VoidCallback?` | — | Called when the card is tapped. Omit for non-tappable. |
| `padding` | `EdgeInsetsGeometry?` | theme | Padding around child. |
| `color` | `Color?` | theme | Background color. |
| `borderRadius` | `double?` | theme | Corner radius. |
| `elevation` | `double?` | theme | Shadow depth. |
| `shadowColor` | `Color?` | theme | Shadow color. |
| `borderColor` | `Color?` | theme | Border color. |
| `borderWidth` | `double?` | theme | Border width (0 = no border). |
| `width` | `double?` | — | Optional width. |
| `height` | `double?` | — | Optional height. |
| `clipBehavior` | `Clip?` | theme | Clip content (use `Clip.antiAlias` for image/gradient). |

---

## Examples

### Simple content
```dart
YakCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Title', style: TextStyle(fontWeight: FontWeight.w600)),
      SizedBox(height: 8),
      Text('Body text or any widget.'),
    ],
  ),
)
```

### Tappable with border
```dart
YakCard(
  onTap: () {},
  borderColor: YakColor.primitive.primary.primary500,
  borderWidth: 2,
  borderRadius: 16,
  child: Center(child: Text('Select me')),
)
```

### Image / gradient + overlay (composed with child)
```dart
YakCard(
  padding: EdgeInsets.zero,
  color: Colors.transparent,
  height: 160,
  clipBehavior: Clip.antiAlias,
  onTap: () {},
  child: Stack(
    fit: StackFit.expand,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(...),
        ),
      ),
      Positioned(
        left: 0, right: 0, bottom: 0,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title', style: TextStyle(color: Colors.white, fontSize: 18)),
              Text('Subtitle', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    ],
  ),
)
```

### List-style content
```dart
YakCard(
  padding: EdgeInsets.zero,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(leading: Icon(Icons.settings), title: Text('Settings'), onTap: () {}),
      Divider(height: 1),
      ListTile(leading: Icon(Icons.help), title: Text('Help'), onTap: () {}),
    ],
  ),
)
```
