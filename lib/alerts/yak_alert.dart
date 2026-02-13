import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Inline SVG for alert icon (Material info symbol) so it works without package assets.
const String _kAlertIconSvg = r'''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -960 960 960">
  <path d="M440-280h80v-240h-80v240Zm68.5-331.5Q520-623 520-640t-11.5-28.5Q497-680 480-680t-28.5 11.5Q440-657 440-640t11.5 28.5Q463-600 480-600t28.5-11.5ZM480-80q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z"/>
</svg>
''';

/// Alert type: info, warning, error, or success (confirmation).
enum YakAlertType { info, warning, error, success }

/// Global theme for [YakAlert]. Set via [ThemeData.extensions] to customize
/// all alerts app-wide; each alert can override per property.
@immutable
class YakAlertThemeData extends ThemeExtension<YakAlertThemeData> {
  const YakAlertThemeData({
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.shadowColor,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 16.0,
    this.itemSpacing = 8.0,
    this.contentSpacing = 16.0,
    this.titleBodySpacing = 4.0,
    this.iconSize = 24.0,
  });

  final double borderRadius;
  final double elevation;
  final Color? shadowColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double itemSpacing;
  final double contentSpacing;
  final double titleBodySpacing;
  final double iconSize;

  @override
  YakAlertThemeData copyWith({
    double? borderRadius,
    double? elevation,
    Color? shadowColor,
    double? horizontalPadding,
    double? verticalPadding,
    double? itemSpacing,
    double? contentSpacing,
    double? titleBodySpacing,
    double? iconSize,
  }) {
    return YakAlertThemeData(
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      titleBodySpacing: titleBodySpacing ?? this.titleBodySpacing,
      iconSize: iconSize ?? this.iconSize,
    );
  }

  @override
  YakAlertThemeData lerp(ThemeExtension<YakAlertThemeData>? other, double t) {
    if (other is! YakAlertThemeData) return this;
    return YakAlertThemeData(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      horizontalPadding: lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      )!,
      verticalPadding: lerpDouble(verticalPadding, other.verticalPadding, t)!,
      itemSpacing: lerpDouble(itemSpacing, other.itemSpacing, t)!,
      contentSpacing: lerpDouble(contentSpacing, other.contentSpacing, t)!,
      titleBodySpacing: lerpDouble(
        titleBodySpacing,
        other.titleBodySpacing,
        t,
      )!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
    );
  }

  static YakAlertThemeData get fallback => const YakAlertThemeData(
    borderRadius: 12.0,
    elevation: 2.0,
    shadowColor: Color(0x1A000000),
    horizontalPadding: 16.0,
    verticalPadding: 16.0,
    itemSpacing: 8.0,
    contentSpacing: 16.0,
    titleBodySpacing: 4.0,
    iconSize: 24.0,
  );
}

/// Icon color per alert type (used for the SVG icon).
Color _iconColorForType(YakAlertType type) {
  switch (type) {
    case YakAlertType.info:
      return YakColor.primitive.blue.blue500;
    case YakAlertType.warning:
      return YakColor.primitive.warning.warning500;
    case YakAlertType.error:
      return YakColor.primitive.danger.danger500;
    case YakAlertType.success:
      return YakColor.primitive.success.success500;
  }
}

/// A banner alert that shows at the top of the screen with icon, title, message,
/// optional action link, and dismiss button. Use [YakAlert.show] to display
/// at the top of the screen, or place [YakAlert] in your layout.
///
/// Design: horizontal layout (icon | info container | close), 8px item spacing,
/// 16px padding, Headline/XS/Medium for title, Text/M/Regular for body,
/// optional "Show More →" link, drop shadow XSM.
class YakAlert extends StatelessWidget {
  const YakAlert({
    super.key,
    required this.title,
    required this.message,
    this.type = YakAlertType.info,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.backgroundColor,
    this.borderRadius,
    this.theme,
  });

  /// Alert title (e.g. "Some kind of alert!").
  final String title;

  /// Body message.
  final String message;

  /// Alert type: info, warning, error, success. Affects icon and optional background tint.
  final YakAlertType type;

  /// Optional action link label (e.g. "Show More →"). If null, no action is shown.
  final String? actionLabel;

  /// Called when the action link is tapped.
  final VoidCallback? onAction;

  /// Called when the close (X) button is tapped.
  final VoidCallback? onDismiss;

  /// Background color. Defaults to white; can be overridden for tint (e.g. warning25).
  final Color? backgroundColor;

  /// Corner radius. Overrides theme when set.
  final double? borderRadius;

  /// Theme. If null, [Theme.of(context).extension<YakAlertThemeData>()] is used.
  final YakAlertThemeData? theme;

  /// Shows an alert at the top of the screen (below status bar) as an overlay.
  /// Animates in (slide down + fade) and out (slide up + fade).
  ///
  /// [context] is used for overlay and theme. [title] and [message] are required.
  /// Optionally provide [actionLabel] and [onAction], and [onDismiss]. [duration]
  /// if non-null auto-dismisses after the duration.
  ///
  /// Returns a [Future] that completes when the alert is dismissed (by user or [duration]).
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    YakAlertType type = YakAlertType.info,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    Color? backgroundColor,
    Duration? duration,
  }) {
    final overlay = Overlay.of(context);
    final completer = Completer<void>();
    late OverlayEntry entry;

    void remove() {
      if (!completer.isCompleted) completer.complete();
      entry.remove();
    }

    entry = OverlayEntry(
      builder: (context) => _YakAlertOverlay(
        title: title,
        message: message,
        type: type,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: onDismiss,
        backgroundColor: backgroundColor,
        onRemove: remove,
        duration: duration,
      ),
    );

    overlay.insert(entry);

    return completer.future;
  }

  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final t =
        theme ??
        Theme.of(context).extension<YakAlertThemeData>() ??
        YakAlertThemeData.fallback;
    final radius = borderRadius ?? t.borderRadius;
    final bg = backgroundColor ?? YakColor.primitive.base.white;
    final iconColor = _iconColorForType(type);
    // Title: visibly larger, bold (Headline style)
    final titleStyle = TextStyle(
      fontSize: YakTypography.semantic.textL.semibold.fontSize,
      color: YakColor.semantic.textAndIcons.baseMain,
    );
    // Body: smaller than title, regular, lighter grey
    final bodyStyle = TextStyle(
      fontSize: YakTypography.semantic.textS.regular.fontSize,
      color: YakColor.semantic.textAndIcons.baseSecond,
    );
    // Show More: same or slightly smaller than body, bold
    final linkStyle = TextStyle(
      fontSize: YakTypography.semantic.textS.semibold.fontSize,
      color: YakColor.semantic.textAndIcons.baseMain,
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: t.horizontalPadding,
          vertical: t.verticalPadding,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: t.elevation > 0
              ? [
                  BoxShadow(
                    color: t.shadowColor ?? const Color(0x1A000000),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon (no background so the SVG stays visible)
            SizedBox(
              width: t.iconSize,
              height: t.iconSize,
              child: Center(
                child: SvgPicture.string(
                  _kAlertIconSvg,
                  width: t.iconSize,
                  height: t.iconSize,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(width: t.itemSpacing),
            // Info container
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle),
                  SizedBox(height: t.titleBodySpacing),
                  Text(
                    message,
                    style: bodyStyle,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (actionLabel != null && actionLabel!.isNotEmpty) ...[
                    SizedBox(height: t.contentSpacing),
                    GestureDetector(
                      onTap: onAction,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(actionLabel!, style: linkStyle),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: YakColor.primitive.gray.gray800,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: t.itemSpacing),
            // Close button
            IconButton(
              onPressed: onDismiss,
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
          ],
        ),
      ),
    );
  }
}

class _YakAlertOverlay extends StatefulWidget {
  const _YakAlertOverlay({
    required this.title,
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.backgroundColor,
    required this.onRemove,
    this.duration,
  });

  final String title;
  final String message;
  final YakAlertType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final Color? backgroundColor;
  final VoidCallback onRemove;
  final Duration? duration;

  @override
  State<_YakAlertOverlay> createState() => _YakAlertOverlayState();
}

class _YakAlertOverlayState extends State<_YakAlertOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: YakAlert._animationDuration,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.onRemove();
      }
    });

    if (widget.duration != null) {
      Future.delayed(widget.duration!, () {
        if (mounted && _controller.status == AnimationStatus.completed) {
          dismiss();
        }
      });
    }
  }

  void dismiss() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: YakAlert(
                title: widget.title,
                message: widget.message,
                type: widget.type,
                actionLabel: widget.actionLabel,
                onAction: widget.onAction != null
                    ? () {
                        widget.onAction!();
                        dismiss();
                      }
                    : null,
                onDismiss: () {
                  widget.onDismiss?.call();
                  dismiss();
                },
                backgroundColor: widget.backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
