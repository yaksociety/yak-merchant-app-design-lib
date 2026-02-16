import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../theme/yak_color.dart';

/// Global theme for [YakSheet]. Set via [ThemeData.extensions] to customize
/// all sheets app-wide; each [YakSheet] can override per property.
@immutable
class YakSheetThemeData extends ThemeExtension<YakSheetThemeData> {
  const YakSheetThemeData({
    this.borderRadius = 24.0,
    this.backgroundColor,
    this.dragHandleColor,
    this.dragHandleWidth = 40.0,
    this.dragHandleHeight = 4.0,
    this.padding,
    this.showDragHandle = true,
  });

  /// Corner radius of the top corners of the sheet.
  final double borderRadius;

  /// Background color of the sheet.
  final Color? backgroundColor;

  /// Color of the drag handle bar.
  final Color? dragHandleColor;

  /// Width of the drag handle.
  final double dragHandleWidth;

  /// Height (thickness) of the drag handle.
  final double dragHandleHeight;

  /// Padding around the sheet content (excluding the drag handle area).
  final EdgeInsetsGeometry? padding;

  /// Whether to show the drag handle at the top.
  final bool showDragHandle;

  @override
  YakSheetThemeData copyWith({
    double? borderRadius,
    Color? backgroundColor,
    Color? dragHandleColor,
    double? dragHandleWidth,
    double? dragHandleHeight,
    EdgeInsetsGeometry? padding,
    bool? showDragHandle,
  }) {
    return YakSheetThemeData(
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      dragHandleWidth: dragHandleWidth ?? this.dragHandleWidth,
      dragHandleHeight: dragHandleHeight ?? this.dragHandleHeight,
      padding: padding ?? this.padding,
      showDragHandle: showDragHandle ?? this.showDragHandle,
    );
  }

  @override
  YakSheetThemeData lerp(ThemeExtension<YakSheetThemeData>? other, double t) {
    if (other is! YakSheetThemeData) return this;
    return YakSheetThemeData(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      dragHandleColor: Color.lerp(dragHandleColor, other.dragHandleColor, t),
      dragHandleWidth: lerpDouble(dragHandleWidth, other.dragHandleWidth, t)!,
      dragHandleHeight: lerpDouble(
        dragHandleHeight,
        other.dragHandleHeight,
        t,
      )!,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      showDragHandle: t < 0.5 ? showDragHandle : other.showDragHandle,
    );
  }

  static YakSheetThemeData get fallback {
    return YakSheetThemeData(
      borderRadius: 24.0,
      backgroundColor: YakColor.primitive.base.white,
      dragHandleColor: YakColor.primitive.neutral.neutral700,
      dragHandleWidth: 40.0,
      dragHandleHeight: 4.0,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      showDragHandle: true,
    );
  }
}

/// A bottom sheet widget with optional drag handle, title, and themed styling.
///
/// Use [YakSheet] as the [builder] content for [showModalBottomSheet], or call
/// [YakSheet.show] to display a modal sheet with default behavior.
///
/// Styling can be set globally via [YakSheetThemeData] in [ThemeData.extensions];
/// each [YakSheet] can override theme values per property.
///
/// Example:
/// ```dart
/// YakSheet.show(
///   context,
///   child: Column(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Text('Sheet content'),
///     ],
///   ),
/// );
/// ```
class YakSheet extends StatelessWidget {
  const YakSheet({
    super.key,
    required this.child,
    this.title,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.showDragHandle,
    this.dragHandleColor,
    this.dragHandleWidth,
    this.dragHandleHeight,
    this.isScrollControlled = true,
  });

  /// Sheet content.
  final Widget child;

  /// Optional title shown below the drag handle.
  final Widget? title;

  /// Background color. Overrides theme when set.
  final Color? backgroundColor;

  /// Top corner radius. Overrides theme when set.
  final double? borderRadius;

  /// Padding around content. Overrides theme when set.
  final EdgeInsetsGeometry? padding;

  /// Whether to show the drag handle. Overrides theme when set.
  final bool? showDragHandle;

  /// Drag handle color. Overrides theme when set.
  final Color? dragHandleColor;

  /// Drag handle width. Overrides theme when set.
  final double? dragHandleWidth;

  /// Drag handle height. Overrides theme when set.
  final double? dragHandleHeight;

  /// Whether the sheet should expand to full height when content is large.
  /// Passed through when using [YakSheet.show].
  final bool isScrollControlled;

  /// Shows a modal bottom sheet with [YakSheet] as content.
  ///
  /// [context] is used to find the navigator and theme. [child] is the sheet
  /// body. Optional [title] is shown below the drag handle. [backgroundColor],
  /// [barrierColor], and [shape] can override defaults. Pass [showDragHandle],
  /// [borderRadius], [padding] to override theme for this sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    Widget? title,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? shape,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    final theme =
        Theme.of(context).extension<YakSheetThemeData>() ??
        YakSheetThemeData.fallback;
    final radius = borderRadius ?? theme.borderRadius;
    final effectiveBg =
        backgroundColor ??
        theme.backgroundColor ??
        YakColor.primitive.base.white;

    final topRadius = BorderRadius.vertical(top: Radius.circular(radius));

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? Colors.black54,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: topRadius),
      builder: (context) => ClipRRect(
        borderRadius: topRadius,
        child: Container(
          color: effectiveBg,
          child: YakSheet(
            title: title,
            backgroundColor: effectiveBg,
            borderRadius: radius,
            padding: padding ?? theme.padding,
            showDragHandle: showDragHandle ?? theme.showDragHandle,
            dragHandleColor: theme.dragHandleColor,
            dragHandleWidth: theme.dragHandleWidth,
            dragHandleHeight: theme.dragHandleHeight,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<YakSheetThemeData>() ??
        YakSheetThemeData.fallback;

    final radius = borderRadius ?? theme.borderRadius;
    final effectiveColor =
        backgroundColor ??
        theme.backgroundColor ??
        YakColor.primitive.base.white;
    final effectivePadding = padding ?? theme.padding ?? EdgeInsets.zero;
    final showHandle = showDragHandle ?? theme.showDragHandle;
    final handleColor =
        dragHandleColor ??
        theme.dragHandleColor ??
        YakColor.primitive.neutral.neutral700;
    final handleWidth = dragHandleWidth ?? theme.dragHandleWidth;
    final handleHeight = dragHandleHeight ?? theme.dragHandleHeight;

    return Container(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            SizedBox(height: 12),
            Center(
              child: Container(
                width: handleWidth,
                height: handleHeight,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(handleHeight / 2),
                ),
              ),
            ),
            if (title != null) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: title,
              ),
              SizedBox(height: 16),
            ] else
              SizedBox(height: 16),
          ] else if (title != null) ...[
            Padding(padding: EdgeInsets.fromLTRB(24, 24, 24, 0), child: title),
            SizedBox(height: 16),
          ],
          SingleChildScrollView(padding: effectivePadding, child: child),
        ],
      ),
    );
  }
}
