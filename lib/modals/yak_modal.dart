import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../theme/yak_color.dart';

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
    this.gap = 16.0,
  });

  final double borderRadius;
  final double elevation;
  final Color? shadowColor;
  final Color? backgroundColor;
  final double padding;
  final double gap;

  @override
  YakModalThemeData copyWith({
    double? borderRadius,
    double? elevation,
    Color? shadowColor,
    Color? backgroundColor,
    double? padding,
    double? gap,
  }) {
    return YakModalThemeData(
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
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
      gap: lerpDouble(gap, other.gap, t)!,
    );
  }

  static YakModalThemeData get fallback => YakModalThemeData(
    borderRadius: 12.0,
    elevation: 8.0,
    shadowColor: const Color(0x1A000000),
    backgroundColor: YakColor.primitive.base.white,
    padding: 24.0,
    gap: 16.0,
  );
}

/// A centered modal container.
///
/// This widget does **not** impose any internal structure (no title/description/actions).
/// Provide all content yourself via [child].
///
/// Defaults:
/// - Rounded corners: 12
/// - Padding: 24
/// - Recommended vertical gap between elements: 16 (see [YakModal.gap])
class YakModal extends StatelessWidget {
  const YakModal({
    super.key,
    required this.child,
    this.onClose,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.theme,
  });

  /// Recommended gap between content blocks inside the modal.
  static const double gap = 16.0;

  /// Main content; provide your own layout (title, text, actions, etc.).
  final Widget child;

  /// Optional close callback for consumers to use in their own actions.
  ///
  /// Note: `YakModal` does not render a built-in close (X) button.
  final VoidCallback? onClose;

  final Color? backgroundColor;
  final double? borderRadius;
  final double? padding;
  final YakModalThemeData? theme;

  /// Shows a modal dialog with [YakModal] as content.
  ///
  /// [child] is the full modal content (title/description/actions are up to you).
  /// Returns a [Future] that completes when the dialog is closed.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    VoidCallback? onClose,
    Color? backgroundColor,
    double? borderRadius,
    double? padding,
    bool barrierDismissible = true,
  }) {
    final navigator = Navigator.of(context, rootNavigator: true);
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 240),
      transitionBuilder: (context, animation, secondaryAnimation, pageChild) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final scale = Tween<double>(begin: 0.98, end: 1.0).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: scale,
            child: pageChild,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Builder(
            builder: (context) => YakModal(
              onClose: onClose ?? () => navigator.pop(),
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              padding: padding,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t =
        theme ??
        Theme.of(context).extension<YakModalThemeData>() ??
        YakModalThemeData.fallback;
    final radius = borderRadius ?? t.borderRadius;
    final bg =
        backgroundColor ?? t.backgroundColor ?? YakColor.primitive.base.white;
    final contentPadding = padding ?? t.padding;

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
        child: Padding(padding: EdgeInsets.all(contentPadding), child: child),
      ),
    );
  }
}
