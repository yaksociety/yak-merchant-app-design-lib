import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Paints a dashed rectangle with the given [color] and [strokeWidth].
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, this.strokeWidth = 1.5});

  final Color color;
  final double strokeWidth;

  static const double _dashWidth = 8;
  static const double _dashSpace = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16),
        ),
      );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + _dashWidth);
        canvas.drawPath(segment, paint);
        distance += _dashWidth + _dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Layout of the empty drop zone: icon and text arrangement.
enum YakFileUploadDropZoneLayout {
  /// Icon on top, text below (default).
  vertical,

  /// Icon on the left, text on the right (e.g. for document upload with instructions below).
  horizontal,
}

/// Status of a single file in the upload component.
enum YakFileUploadStatus {
  /// Upload is in progress.
  uploading,

  /// Upload completed successfully.
  success,

  /// Upload failed; user can retry.
  failed,
}

/// Represents one file displayed in [YakFileUpload].
///
/// Use [progress] (0.0–1.0) only when [status] is [YakFileUploadStatus.uploading].
/// [errorMessage] is optional when [status] is [YakFileUploadStatus.failed].
/// Set [thumbnail] (e.g. [MemoryImage], [FileImage]) to show an image preview in the card.
@immutable
class YakFileUploadItem {
  const YakFileUploadItem({
    required this.name,
    required this.sizeBytes,
    required this.status,
    this.progress,
    this.errorMessage,
    this.thumbnail,
  });

  /// Display name of the file (e.g. "Yak.pdf").
  final String name;

  /// File size in bytes.
  final int sizeBytes;

  /// Current upload status.
  final YakFileUploadStatus status;

  /// Progress from 0.0 to 1.0 when [status] is [YakFileUploadStatus.uploading].
  final double? progress;

  /// Optional error message when [status] is [YakFileUploadStatus.failed].
  final String? errorMessage;

  /// Optional image to show as thumbnail (e.g. [MemoryImage] from file bytes).
  /// When set, the card shows this instead of the default document icon.
  final ImageProvider? thumbnail;

  String get sizeLabel {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).round()} kb';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  YakFileUploadItem copyWith({
    String? name,
    int? sizeBytes,
    YakFileUploadStatus? status,
    double? progress,
    String? errorMessage,
    ImageProvider? thumbnail,
  }) {
    return YakFileUploadItem(
      name: name ?? this.name,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}

/// One custom upload option (e.g. "Take a photo", "Choose file", "Import from library").
///
/// When [YakFileUpload.uploadSources] is set, tapping the drop zone shows a bottom sheet
/// with these options. Use platform-specific lists (e.g. camera + gallery on mobile,
/// choose file only on web) so each OS gets appropriate actions.
@immutable
class YakFileUploadSource {
  const YakFileUploadSource({
    required this.label,
    this.icon,
    required this.onSelected,
  });

  /// Display label (e.g. "Take a photo", "Choose file", "Import from library").
  final String label;

  /// Optional icon (e.g. [Icons.camera_alt], [Icons.folder_open], [Icons.photo_library]).
  final IconData? icon;

  /// Called when the user selects this option. Typically open camera, file picker, or gallery.
  final VoidCallback onSelected;
}

/// Callbacks for [YakFileUpload] actions.
///
/// Implement these to open a file picker, cancel/retry/remove uploads, or replace the file.
class YakFileUploadCallbacks {
  const YakFileUploadCallbacks({
    this.onPickRequested,
    this.onCancelUpload,
    this.onRetry,
    this.onRemove,
    this.onChangeRequested,
    this.onFilesDropped,
  });

  /// Called when the user taps the drop zone or "choose your file".
  /// Typically open a file picker and then update the parent state with the chosen file(s).
  final VoidCallback? onPickRequested;

  /// Called when the user taps cancel (X) during upload.
  final VoidCallback? onCancelUpload;

  /// Called when the user taps retry after a failed upload.
  final VoidCallback? onRetry;

  /// Called when the user taps delete (trash) on a successful upload.
  final VoidCallback? onRemove;

  /// Called when the user taps "Change" to replace the current file.
  final VoidCallback? onChangeRequested;

  /// Called when the user drops file(s) onto the drop zone.
  /// [files] are the dropped file paths or [XFile]-like objects; on web you may get bytes.
  /// Caller can cast to PlatformFile or XFile as needed.
  final void Function(List<Object>)? onFilesDropped;
}

/// File upload component for the Yak design system.
///
/// Supports:
/// - **Empty state**: Dashed border, drag-and-drop area, "choose your file" link.
/// - **Disabled state**: Greyed-out drop zone.
/// - **Uploading**: File card with progress bar and cancel.
/// - **Success**: File card with "Change" and delete.
/// - **Failed**: File card with error styling and retry.
///
/// The widget is controlled: pass [value] (current file item or null) and [callbacks]
/// so the parent owns state and handles picking/upload/remove.
///
/// Example:
/// ```dart
/// YakFileUpload(
///   value: _uploadItem,
///   acceptedTypes: ['jpg', 'png', 'svg'],
///   enabled: true,
///   callbacks: YakFileUploadCallbacks(
///     onPickRequested: () async {
///       final result = await FilePicker.platform.pickFiles(...);
///       if (result != null) setState(() => _uploadItem = ...);
///     },
///     onRemove: () => setState(() => _uploadItem = null),
///   ),
/// )
/// ```
class YakFileUpload extends StatefulWidget {
  const YakFileUpload({
    super.key,
    this.value,
    this.acceptedTypes = const ['jpg', 'png', 'svg'],
    this.hintText,
    this.hintSubtext,
    this.maxFileSizeLabel,
    this.label,
    this.isRequired = false,
    this.dropZoneLayout = YakFileUploadDropZoneLayout.vertical,
    this.instructions,
    this.enabled = true,
    this.callbacks = const YakFileUploadCallbacks(),
    this.uploadSources,
    this.changeButtonLabel = 'Change',
  });

  /// Current file to display, or null to show the empty drop zone.
  final YakFileUploadItem? value;

  /// Accepted file type labels for hint (e.g. "JPG, PNG or SVG").
  final List<String> acceptedTypes;

  /// Override for the main hint (default: "Drag and Drop or choose your file for upload.").
  /// In horizontal layout this is the primary line (often in primary color).
  final String? hintText;

  /// Second line below [hintText] (e.g. "JPG, PNG หรือ PDF สูงสุด 2 MB").
  /// If null, built from [acceptedTypes] and optional [maxFileSizeLabel].
  final String? hintSubtext;

  /// Optional max file size text (e.g. "สูงสุด 2 MB", "max 2 MB"). Shown after accepted types when [hintSubtext] is null.
  final String? maxFileSizeLabel;

  /// Optional label above the upload area (e.g. "เอกสารอนุญาตประกอบอาชีพในประเทศไทย").
  final String? label;

  /// When true, show a red asterisk after [label] to indicate required.
  final bool isRequired;

  /// Layout of the empty drop zone: [YakFileUploadDropZoneLayout.vertical] (icon on top) or [horizontal] (icon left, text right).
  final YakFileUploadDropZoneLayout dropZoneLayout;

  /// Optional widget below the drop zone when empty (e.g. instructions or bullet list).
  final Widget? instructions;

  /// Whether the control is enabled.
  final bool enabled;

  /// Callbacks for pick, cancel, retry, remove, change, and drop.
  final YakFileUploadCallbacks callbacks;

  /// Custom upload options (e.g. "Take a photo", "Choose file", "Import from library").
  /// When non-null and non-empty, tapping the drop zone or "choose your file" shows
  /// a bottom sheet with these options instead of calling [YakFileUploadCallbacks.onPickRequested].
  /// Use platform-specific lists per OS (camera + gallery on mobile, file picker on web, etc.).
  final List<YakFileUploadSource>? uploadSources;

  /// Label for the "Change" button when upload succeeded (e.g. 'Change' or 'เปลี่ยน').
  final String changeButtonLabel;

  @override
  State<YakFileUpload> createState() => _YakFileUploadState();
}

class _YakFileUploadState extends State<YakFileUpload> {
  bool _isDragging = false;

  static const String _defaultHint =
      'Drag and Drop or choose your file for upload.';

  String get _acceptedTypesLabel =>
      widget.acceptedTypes.map((e) => e.toUpperCase()).join(', ');

  String get _secondaryLabel {
    if (widget.hintSubtext != null && widget.hintSubtext!.isNotEmpty) {
      return widget.hintSubtext!;
    }
    if (widget.maxFileSizeLabel != null && widget.maxFileSizeLabel!.isNotEmpty) {
      return '${_acceptedTypesLabel} ${widget.maxFileSizeLabel}';
    }
    return _acceptedTypesLabel;
  }

  void _onPickRequested() {
    if (!widget.enabled) return;
    final sources = widget.uploadSources;
    if (sources != null && sources.isNotEmpty) {
      _showUploadSourcesSheet(sources);
    } else {
      widget.callbacks.onPickRequested?.call();
    }
  }

  void _showUploadSourcesSheet(List<YakFileUploadSource> sources) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: YakColor.primitive.base.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Upload from',
                style: YakTypography.semantic.textM.medium.copyWith(
                  color: YakColor.primitive.gray.gray700,
                ),
              ),
              const SizedBox(height: 8),
              ...sources.map(
                (source) => ListTile(
                  leading: source.icon != null
                      ? Icon(
                          source.icon,
                          color: YakColor.semantic.textAndIcons.primary,
                          size: 24,
                        )
                      : null,
                  title: Text(
                    source.label,
                    style: YakTypography.semantic.textM.regular.copyWith(
                      color: YakColor.primitive.gray.gray700,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    source.onSelected();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFilesDropped(List<Object> files) {
    if (!widget.enabled || files.isEmpty) return;
    widget.callbacks.onFilesDropped?.call(files);
  }

  @override
  Widget build(BuildContext context) {
    final hasLabel = widget.label != null && widget.label!.trim().isNotEmpty;
    final hasInstructions = widget.instructions != null;

    final content = widget.value != null
        ? _buildFileCard(widget.value!)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropZone(),
              if (hasInstructions) ...[
                const SizedBox(height: 12),
                widget.instructions!,
              ],
            ],
          );

    if (hasLabel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel(),
          const SizedBox(height: 8),
          content,
        ],
      );
    }
    return content;
  }

  Widget _buildLabel() {
    final label = widget.label!.trim();
    return RichText(
      text: TextSpan(
        style: YakTypography.semantic.textM.medium.copyWith(
          color: YakColor.primitive.gray.gray700,
        ),
        text: label,
        children: widget.isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: YakColor.primitive.danger.danger500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildDropZone() {
    final enabled = widget.enabled;
    final borderColor = enabled
        ? (_isDragging
              ? YakColor.primitive.primary.primary500
              : YakColor.primitive.neutral.neutral700)
        : YakColor.primitive.neutral.neutral700;
    final contentColor = enabled
        ? YakColor.primitive.gray.gray700
        : YakColor.semantic.textAndIcons.disabled;
    final primaryColor = enabled
        ? YakColor.semantic.textAndIcons.primary
        : contentColor;

    final hint = widget.hintText ?? _defaultHint;
    final hasChooseLink = hint.contains('choose your file');
    final isHorizontal = widget.dropZoneLayout == YakFileUploadDropZoneLayout.horizontal;

    Widget primaryLine;
    if (hasChooseLink && hint == _defaultHint) {
      primaryLine = RichText(
        textAlign: isHorizontal ? TextAlign.start : TextAlign.center,
        text: TextSpan(
          style: YakTypography.semantic.textM.regular.copyWith(color: contentColor),
          children: [
            const TextSpan(text: 'Drag and Drop or '),
            TextSpan(
              text: 'choose your file',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' for upload.'),
          ],
        ),
      );
    } else {
      primaryLine = Text(
        hint,
        textAlign: isHorizontal ? TextAlign.start : TextAlign.center,
        style: YakTypography.semantic.textM.regular.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final secondaryLine = Text(
      _secondaryLabel,
      textAlign: isHorizontal ? TextAlign.start : TextAlign.center,
      style: YakTypography.semantic.textS.regular.copyWith(color: contentColor),
    );

    const double iconSize = 48;
    final iconWidget = Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: YakColor.primitive.neutral.neutral400,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.upload_file_rounded,
        size: 28,
        color: contentColor,
      ),
    );

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isHorizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        primaryLine,
        const SizedBox(height: 4),
        secondaryLine,
      ],
    );

    final body = isHorizontal
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Row(
              children: [
                iconWidget,
                const SizedBox(width: 16),
                Expanded(child: textColumn),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.upload_file_rounded,
                  size: iconSize,
                  color: contentColor,
                ),
                const SizedBox(height: 16),
                textColumn,
              ],
            ),
          );

    return GestureDetector(
      onTap: enabled ? _onPickRequested : null,
      child: DragTarget<Object>(
        onWillAcceptWithDetails: enabled ? (_) => true : null,
        onAcceptWithDetails: (details) {
          setState(() => _isDragging = false);
          final data = details.data;
          if (data is List) {
            _onFilesDropped(List<Object>.from(data));
          } else {
            _onFilesDropped([data]);
          }
        },
        onLeave: (_) => setState(() => _isDragging = false),
        onMove: (_) => setState(() => _isDragging = true),
        builder: (context, candidateData, rejectedData) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: YakColor.primitive.base.white,
              borderRadius: BorderRadius.circular(16),
              border: enabled
                  ? null
                  : Border.all(
                      color: borderColor,
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
            ),
            child: Stack(
              children: [
                body,
                if (enabled)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DashedBorderPainter(
                        color: borderColor,
                        strokeWidth: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFileCard(YakFileUploadItem item) {
    const double iconSize = 60;
    final isFailed = item.status == YakFileUploadStatus.failed;
    final fileNameStyle = YakTypography.semantic.textM.medium.copyWith(
      color: isFailed
          ? YakColor.semantic.textAndIcons.danger
          : YakColor.primitive.gray.gray700,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YakColor.primitive.base.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: YakColor.primitive.neutral.neutral700,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: item.thumbnail != null
                      ? Image(
                          image: item.thumbnail!,
                          fit: BoxFit.cover,
                          width: iconSize,
                          height: iconSize,
                          errorBuilder: (_, _, _) =>
                              _buildDefaultFileIcon(iconSize),
                        )
                      : _buildDefaultFileIcon(iconSize),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: fileNameStyle),
                    const SizedBox(height: 2),
                    Text(
                      item.sizeLabel,
                      style: YakTypography.semantic.textS.regular.copyWith(
                        color: YakColor.primitive.gray.gray400,
                      ),
                    ),
                    if (item.status == YakFileUploadStatus.success) ...[
                      const SizedBox(height: 4),
                      OutlinedButton(
                        onPressed: widget.enabled
                            ? widget.callbacks.onChangeRequested
                            : null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: YakColor.primitive.base.white,
                          foregroundColor:
                              YakColor.semantic.textAndIcons.primary,
                          side: BorderSide(
                            color: YakColor.primitive.neutral.neutral700,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                        ),
                        child: Text(
                          widget.changeButtonLabel,
                          style: YakTypography.semantic.textS.medium.copyWith(
                            color: widget.enabled
                                ? YakColor.semantic.textAndIcons.primary
                                : YakColor.semantic.textAndIcons.disabled,
                          ),
                        ),
                      ),
                      if (item.status == YakFileUploadStatus.uploading) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: item.progress?.clamp(0.0, 1.0) ?? 0,
                                  minHeight: 8,
                                  backgroundColor:
                                      YakColor.primitive.neutral.neutral500,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    YakColor.primitive.success.success500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${((item.progress ?? 0) * 100).round()}%',
                              style: YakTypography.semantic.textS.medium
                                  .copyWith(
                                    color: YakColor.primitive.gray.gray500,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              _buildCardActions(item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultFileIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: YakColor.primitive.neutral.neutral400,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.description_outlined,
        size: size * 0.6,
        color: YakColor.primitive.gray.gray400,
      ),
    );
  }

  Widget _buildCardActions(YakFileUploadItem item) {
    if (item.status == YakFileUploadStatus.uploading) {
      return IconButton(
        onPressed: widget.enabled ? widget.callbacks.onCancelUpload : null,
        icon: Icon(
          Icons.close,
          size: 20,
          color: YakColor.primitive.gray.gray500,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      );
    }
    if (item.status == YakFileUploadStatus.success) {
      return IconButton(
        onPressed: widget.enabled ? widget.callbacks.onRemove : null,
        icon: Icon(
          Icons.delete_outline_rounded,
          size: 20,
          color: YakColor.primitive.gray.gray500,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      );
    }
    if (item.status == YakFileUploadStatus.failed) {
      return IconButton(
        onPressed: widget.enabled ? widget.callbacks.onRetry : null,
        icon: Icon(
          Icons.refresh_rounded,
          size: 20,
          color: YakColor.primitive.gray.gray500,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      );
    }
    return const SizedBox.shrink();
  }
}
