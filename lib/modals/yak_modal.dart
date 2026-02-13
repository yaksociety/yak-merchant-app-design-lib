import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../buttons/yak_button.dart';
import '../theme/yak_color.dart';

/// Icon type for the optional header icon (colored circle with symbol).
enum YakModalIconType {
  info,
  success,
  warning,
  error,
}

/// Global theme for [YakModal]. Set via [ThemeData.extensions] to customize
/// all modals app-wide; each [YakModal] can override per property.
@immutable
class YakModalThemeData extends ThemeExtension<YakModalThemeData> {
  const YakModalThemeData({
    this.borderRadius = 12.0,
    this.elevation = 8.0,
    this.shadowColor,
    this.backgroundColor,
    this.padding = 24.0,
    this.headerIconSize = 48.0,
    this.titleDescriptionSpacing = 8.0,
    this.contentTopSpacing = 20.0,
    this.actionsTopSpacing = 24.0,
    this.actionsSpacing = 12.0,
  });

  final double borderRadius;
  final double elevation;
  final Color? shadowColor;
  final Color? backgroundColor;
  final double padding;
  final double headerIconSize;
  final double titleDescriptionSpacing;
  final double contentTopSpacing;
  final double actionsTopSpacing;
  final double actionsSpacing;

  @override
  YakModalThemeData copyWith({
    double? borderRadius,
    double? elevation,
    Color? shadowColor,
    Color? backgroundColor,
    double? padding,
    double? headerIconSize,
    double? titleDescriptionSpacing,
    double? contentTopSpacing,
    double? actionsTopSpacing,
    double? actionsSpacing,
  }) {
    return YakModalThemeData(
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      headerIconSize: headerIconSize ?? this.headerIconSize,
      titleDescriptionSpacing: titleDescriptionSpacing ?? this.titleDescriptionSpacing,
      contentTopSpacing: contentTopSpacing ?? this.contentTopSpacing,
      actionsTopSpacing: actionsTopSpacing ?? this.actionsTopSpacing,
      actionsSpacing: actionsSpacing ?? this.actionsSpacing,
    );
  }

  @override
  YakModalThemeData lerp(ThemeExtension<YakModalThemeData>? other, double t) {
    if (other is! YakModalThemeData) return this;
    return YakModalThemeData(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      padding: lerpDouble(padding, other.padding, t)!,
      headerIconSize: lerpDouble(headerIconSize, other.headerIconSize, t)!,
      titleDescriptionSpacing:
          lerpDouble(titleDescriptionSpacing, other.titleDescriptionSpacing, t)!,
      contentTopSpacing:
          lerpDouble(contentTopSpacing, other.contentTopSpacing, t)!,
      actionsTopSpacing:
          lerpDouble(actionsTopSpacing, other.actionsTopSpacing, t)!,
      actionsSpacing: lerpDouble(actionsSpacing, other.actionsSpacing, t)!,
    );
  }

  static YakModalThemeData get fallback => YakModalThemeData(
        borderRadius: 12.0,
        elevation: 8.0,
        shadowColor: const Color(0x1A000000),
        backgroundColor: YakColor.primitive.base.white,
        padding: 24.0,
        headerIconSize: 48.0,
        titleDescriptionSpacing: 8.0,
        contentTopSpacing: 20.0,
        actionsTopSpacing: 24.0,
        actionsSpacing: 12.0,
      );
}

Color _iconColorForType(YakModalIconType type) {
  switch (type) {
    case YakModalIconType.info:
      return YakColor.primitive.blue.blue500;
    case YakModalIconType.success:
      return YakColor.primitive.success.success500;
    case YakModalIconType.warning:
      return YakColor.primitive.warning.warning500;
    case YakModalIconType.error:
      return YakColor.primitive.danger.danger500;
  }
}

IconData _iconDataForType(YakModalIconType type) {
  switch (type) {
    case YakModalIconType.info:
      return Icons.info_outline;
    case YakModalIconType.success:
      return Icons.check;
    case YakModalIconType.warning:
      return Icons.warning_amber_rounded;
    case YakModalIconType.error:
      return Icons.error_outline;
  }
}

/// A centered modal dialog with optional header icon/image, title, description,
/// user-defined [child] content, and optional Cancel + Continue actions.
/// Use [YakModal.show] to display via [showDialog], or build [YakModal] as the
/// dialog content. Styling via [YakModalThemeData].
///
/// Example:
/// ```dart
/// YakModal.show(
///   context,
///   title: 'Photo',
///   description: 'Add a photo to your profile.',
///   child: Image.asset(...),
///   primaryLabel: 'Continue',
///   onPrimary: () => Navigator.pop(context),
///   cancelLabel: 'Cancel',
///   onCancel: () => Navigator.pop(context),
/// );
/// ```
class YakModal extends StatelessWidget {
  const YakModal({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.headerIcon,
    this.headerIconType,
    this.headerImage,
    this.cancelLabel,
    this.onCancel,
    this.primaryLabel,
    this.onPrimary,
    this.primaryIsDanger = false,
    this.onClose,
    this.backgroundColor,
    this.borderRadius,
    this.theme,
  });

  /// Main content; add any widgets (forms, images, checkboxes, toggles, etc.).
  final Widget child;

  /// Optional title below header icon/image.
  final String? title;

  /// Optional description below title.
  final String? description;

  /// Optional custom header widget (e.g. custom icon). If [headerIconType] is set, that is used instead.
  final Widget? headerIcon;

  /// Optional preset icon (colored circle with info/success/warning/error icon).
  final YakModalIconType? headerIconType;

  /// Optional image or widget at the very top (e.g. large image for "Photo" modal).
  final Widget? headerImage;

  /// Cancel button label (e.g. "Cancel"). If null, no cancel button.
  final String? cancelLabel;

  /// Called when cancel is pressed. Typically `Navigator.pop(context)`.
  final VoidCallback? onCancel;

  /// Primary button label (e.g. "Continue"). If null, no primary button.
  final String? primaryLabel;

  /// Called when primary is pressed. Typically `Navigator.pop(context)`.
  final VoidCallback? onPrimary;

  /// When true, primary button uses danger (red) style.
  final bool primaryIsDanger;

  /// Called when the close (X) button is pressed. Typically `Navigator.pop(context)`.
  final VoidCallback? onClose;

  final Color? backgroundColor;
  final double? borderRadius;
  final YakModalThemeData? theme;

  /// Shows a modal dialog with [YakModal] as content.
  ///
  /// [child] is the main content. Optionally set [title], [description],
  /// [headerIconType] or [headerImage], and [cancelLabel]/[primaryLabel] with callbacks.
  /// Returns a [Future] that completes when the dialog is closed.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? description,
    Widget? headerIcon,
    YakModalIconType? headerIconType,
    Widget? headerImage,
    String? cancelLabel,
    VoidCallback? onCancel,
    String? primaryLabel,
    VoidCallback? onPrimary,
    bool primaryIsDanger = false,
    VoidCallback? onClose,
    Color? backgroundColor,
    double? borderRadius,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => YakModal(
        title: title,
        description: description,
        headerIcon: headerIcon,
        headerIconType: headerIconType,
        headerImage: headerImage,
        cancelLabel: cancelLabel,
        onCancel: onCancel ?? () => Navigator.of(context).pop(),
        primaryLabel: primaryLabel,
        onPrimary: onPrimary ?? () => Navigator.of(context).pop(),
        primaryIsDanger: primaryIsDanger,
        onClose: onClose ?? () => Navigator.of(context).pop(),
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = theme ??
        Theme.of(context).extension<YakModalThemeData>() ??
        YakModalThemeData.fallback;
    final radius = borderRadius ?? t.borderRadius;
    final bg = backgroundColor ?? t.backgroundColor ?? YakColor.primitive.base.white;
    final padding = t.padding;

    Widget? leadingWidget;
    if (headerImage != null) {
      leadingWidget = headerImage;
    } else if (headerIcon != null) {
      leadingWidget = headerIcon;
    } else if (headerIconType != null) {
      final iconColor = _iconColorForType(headerIconType!);
      final iconData = _iconDataForType(headerIconType!);
      leadingWidget = Container(
        width: t.headerIconSize,
        height: t.headerIconSize,
        decoration: BoxDecoration(
          color: iconColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          color: YakColor.primitive.base.white,
          size: t.headerIconSize * 0.55,
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: t.elevation > 0
              ? [
                  BoxShadow(
                    color: t.shadowColor ?? const Color(0x1A000000),
                    blurRadius: t.elevation,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (leadingWidget != null) ...[
                    Center(child: leadingWidget),
                    SizedBox(height: t.titleDescriptionSpacing),
                  ],
                  if (title != null && title!.isNotEmpty) ...[
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: YakColor.primitive.gray.gray800,
                      ),
                    ),
                    if (description != null && description!.isNotEmpty) ...[
                      SizedBox(height: t.titleDescriptionSpacing),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: YakColor.primitive.gray.gray500,
                        ),
                      ),
                    ],
                    SizedBox(height: t.contentTopSpacing),
                  ] else if (description != null && description!.isNotEmpty) ...[
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: YakColor.primitive.gray.gray500,
                      ),
                    ),
                    SizedBox(height: t.contentTopSpacing),
                  ] else if (leadingWidget != null)
                    SizedBox(height: t.contentTopSpacing),
                  child,
                  if (cancelLabel != null || primaryLabel != null) ...[
                    SizedBox(height: t.actionsTopSpacing),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: t.actionsSpacing,
                      runSpacing: t.actionsSpacing,
                      children: [
                        if (cancelLabel != null)
                          YakButton(
                            text: cancelLabel!,
                            variant: YakButtonVariant.secondary,
                            onPressed: onCancel,
                          ),
                        if (primaryLabel != null)
                          YakButton(
                            text: primaryLabel!,
                            variant: YakButtonVariant.primary,
                            backgroundColor: primaryIsDanger
                                ? YakColor.primitive.danger.danger500
                                : null,
                            textColor: primaryIsDanger
                                ? YakColor.primitive.base.white
                                : null,
                            onPressed: onPrimary,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                onPressed: onClose,
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: YakColor.primitive.gray.gray700,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
