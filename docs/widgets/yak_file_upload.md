# YakFileUpload

File upload component for the Yak design system. Supports empty (drop zone), disabled, uploading (with progress), success, and failed states.

## States

| State      | UI                                                                 |
|-----------|--------------------------------------------------------------------|
| Empty     | Dashed border, upload icon, "Drag and Drop or **choose your file** for upload.", accepted types (e.g. JPG, PNG, SVG). |
| Disabled  | Same as empty with solid grey border and muted text/icon.          |
| Uploading | White card: file icon, name, size, green progress bar, %, cancel (X). |
| Success   | White card: file icon, name, size, "Change" button, delete (trash). |
| Failed    | White card: file name in red, retry (circular arrow) icon.         |

## Usage

The widget is **controlled**: you hold the current file (or `null`) and provide callbacks for pick, cancel, retry, remove, and change.

```dart
YakFileUploadItem? _file;

YakFileUpload(
  value: _file,
  acceptedTypes: const ['jpg', 'png', 'svg'],
  enabled: true,
  callbacks: YakFileUploadCallbacks(
    onPickRequested: () async {
      final result = await FilePicker.platform.pickFiles(...);
      if (result != null) setState(() => _file = _createItemFrom(result));
    },
    onCancelUpload: () => setState(() => _file = null),
    onRetry: () => _retryUpload(),
    onRemove: () => setState(() => _file = null),
    onChangeRequested: () => _pickAndReplace(),
  ),
)
```

## API

- **value** – `YakFileUploadItem?` – Current file to show, or `null` for the drop zone.
- **acceptedTypes** – `List<String>` – Shown in hint (e.g. "JPG, PNG or SVG"). Does not enforce types; use your picker/backend for that.
- **hintText** – `String?` – Main hint line (e.g. "Attach image or file for upload"). Default: "Drag and Drop or choose your file for upload."
- **hintSubtext** – `String?` – Second line below hint. If null, built from accepted types and optional **maxFileSizeLabel**.
- **maxFileSizeLabel** – `String?` – e.g. "max 2 MB", shown after accepted types when hintSubtext is null.
- **label** – `String?` – Title above the upload area (e.g. "Professional license in Thailand").
- **isRequired** – `bool` – When true, show red `*` after label.
- **dropZoneLayout** – `YakFileUploadDropZoneLayout` – `vertical` (icon on top) or `horizontal` (icon left, text right).
- **instructions** – `Widget?` – Optional widget below the drop zone when empty (e.g. bullet list of requirements).
- **enabled** – `bool` – When false, drop zone is disabled (solid grey border, no tap/drop).
- **callbacks** – `YakFileUploadCallbacks` – `onPickRequested`, `onCancelUpload`, `onRetry`, `onRemove`, `onChangeRequested`, `onFilesDropped`.

## YakFileUploadItem

- **name** – Display name (e.g. "Yak.pdf").
- **sizeBytes** – File size; widget shows "500 kb" etc. via `sizeLabel`.
- **status** – `YakFileUploadStatus.uploading` | `success` | `failed`.
- **progress** – `0.0`–`1.0` when status is `uploading`.
- **errorMessage** – Optional when status is `failed`.

## Configurable (label, horizontal, instructions)

To match a document-upload screen with a title, horizontal drop zone, and instructions below:

```dart
YakFileUpload(
  label: 'Professional license in Thailand',
  isRequired: true,
  hintText: 'Attach image or file for upload',
  maxFileSizeLabel: 'max 2 MB',
  acceptedTypes: ['jpg', 'png', 'pdf'],
  dropZoneLayout: YakFileUploadDropZoneLayout.horizontal,
  instructions: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Please attach a copy of...'),
      _bullet('Ensure all information is complete and clear.'),
      _bullet('...'),
    ],
  ),
  callbacks: YakFileUploadCallbacks(onPickRequested: () => ...),
)
```

- **vertical** (default): icon on top, text below.
- **horizontal**: icon on the left in a circle, primary hint (primary color) and secondary line (types + max size) on the right.

## Custom upload sources (e.g. Take a photo, Choose file, Import library)

Set [uploadSources] to show a bottom sheet of options when the user taps the drop zone or "choose your file". Each option can open camera, file picker, or gallery so you can tailor actions per OS.

```dart
// Platform-specific: camera + gallery on mobile, choose file on all
final sources = <YakFileUploadSource>[];
if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
  sources.add(YakFileUploadSource(label: 'Take a photo', icon: Icons.camera_alt, onSelected: _takePhoto));
  sources.add(YakFileUploadSource(label: 'Import from library', icon: Icons.photo_library, onSelected: _pickFromGallery));
}
sources.add(YakFileUploadSource(label: 'Choose file', icon: Icons.folder_open, onSelected: _chooseFile));

YakFileUpload(
  uploadSources: sources,
  ...
)
```

When [uploadSources] is non-null and non-empty, tapping the drop zone opens this sheet instead of calling [YakFileUploadCallbacks.onPickRequested]. For "Change", the parent can show the same options (e.g. via [onChangeRequested]) by presenting the same list in a bottom sheet.

## Best practices

1. **Single source of truth** – Keep `value` in parent state; update it in callbacks after picker/upload/remove.
2. **File picking** – Use `file_picker` (or similar) in `onPickRequested`; create a `YakFileUploadItem` from the result and start your upload.
3. **Custom sources** – Use `uploadSources` with platform-specific lists (camera + gallery on iOS/Android, choose file on web) so each OS gets appropriate actions.
4. **Progress** – During upload, set `status: uploading` and update `progress` until done, then set `success` or `failed`.
5. **Retry** – In `onRetry`, reuse the same file (name/size) and set status back to `uploading` with `progress: 0`, then re-run upload logic.
