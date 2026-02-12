import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../theme/yak_color.dart';

/// Global theme for [YakCard]. Set via [ThemeData.extensions] to customize
/// all cards app-wide; each [YakCard] can override per property.
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       YakCardThemeData(
///         borderRadius: 12,
///         color: Colors.white,
///         elevation: 2,
///         padding: EdgeInsets.all(16),
///       ),
///     ],
///   ),
/// );
/// ```
@immutable
class YakCardThemeData extends ThemeExtension<YakCardThemeData> {
  const YakCardThemeData({
    this.borderRadius = 12.0,
    this.color,
    this.elevation = 0.0,
    this.shadowColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.padding,
    this.clipBehavior = Clip.none,
  });

  /// Corner radius of the card.
  final double borderRadius;

  /// Background color.
  final Color? color;

  /// Elevation (shadow depth). 0 means no shadow.
  final double elevation;

  /// Shadow color when [elevation] > 0.
  final Color? shadowColor;

  /// Border color when [borderWidth] > 0.
  final Color? borderColor;

  /// Border width; 0 means no border.
  final double borderWidth;

  /// Default padding around [YakCard.child].
  final EdgeInsetsGeometry? padding;

  /// Clip behavior for the card content.
  final Clip clipBehavior;

  @override
  YakCardThemeData copyWith({
    double? borderRadius,
    Color? color,
    double? elevation,
    Color? shadowColor,
    Color? borderColor,
    double? borderWidth,
    EdgeInsetsGeometry? padding,
    Clip? clipBehavior,
  }) {
    return YakCardThemeData(
      borderRadius: borderRadius ?? this.borderRadius,
      color: color ?? this.color,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  YakCardThemeData lerp(ThemeExtension<YakCardThemeData>? other, double t) {
    if (other is! YakCardThemeData) return this;
    return YakCardThemeData(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      color: Color.lerp(color, other.color, t),
      elevation: lerpDouble(elevation, other.elevation, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  static YakCardThemeData get fallback {
    return YakCardThemeData(
      borderRadius: 12.0,
      color: YakColor.primitive.base.white,
      elevation: 0.0,
      borderWidth: 0.0,
      padding: const EdgeInsets.all(16),
    );
  }
}

/// A universal card that wraps [child] with optional decoration, padding, and tap.
///
/// Styling can be set globally via [YakCardThemeData] in [ThemeData.extensions];
/// each [YakCard] can override theme values per property. Use [child] for any
/// content (text, images, lists, custom layouts).
///
/// Examples:
/// - Simple content: `YakCard(child: Text('Hello'))`
/// - Image + overlay: `YakCard(child: Stack(children: [Image(...), Positioned(...)])`
/// - List tile: `YakCard(child: ListTile(...))`
class YakCard extends StatelessWidget {
  const YakCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.borderColor,
    this.borderWidth,
    this.width,
    this.height,
    this.clipBehavior,
  });

  /// Card content. Any widget (text, image, list, custom layout).
  final Widget child;

  /// Called when the card is tapped. If null, the card is not tappable.
  final VoidCallback? onTap;

  /// Padding around [child]. Overrides theme padding when set.
  final EdgeInsetsGeometry? padding;

  /// Background color. Overrides theme color when set.
  final Color? color;

  /// Corner radius. Overrides theme when set.
  final double? borderRadius;

  /// Shadow depth. Overrides theme when set.
  final double? elevation;

  /// Shadow color when elevation > 0. Overrides theme when set.
  final Color? shadowColor;

  /// Border color when [borderWidth] > 0. Overrides theme when set.
  final Color? borderColor;

  /// Border width; 0 means no border. Overrides theme when set.
  final double? borderWidth;

  /// Optional width constraint.
  final double? width;

  /// Optional height constraint.
  final double? height;

  /// Clip behavior. Overrides theme when set.
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<YakCardThemeData>() ??
        YakCardThemeData.fallback;

    final radius = borderRadius ?? theme.borderRadius;
    final effectiveColor =
        color ?? theme.color ?? YakColor.primitive.base.white;
    final effectiveElevation = elevation ?? theme.elevation;
    final effectiveShadowColor =
        shadowColor ?? theme.shadowColor ?? Colors.black;
    final borderW = borderWidth ?? theme.borderWidth;
    final borderC =
        borderColor ??
        theme.borderColor ??
        YakColor.primitive.neutral.neutral700;
    final effectivePadding = padding ?? theme.padding ?? EdgeInsets.zero;
    final clip = clipBehavior ?? theme.clipBehavior;

    final decoration = BoxDecoration(
      color: effectiveColor,
      borderRadius: BorderRadius.circular(radius),
      border: borderW > 0 ? Border.all(color: borderC, width: borderW) : null,
      boxShadow: effectiveElevation > 0
          ? [
              BoxShadow(
                color: (effectiveShadowColor).withValues(alpha: 0.08),
                blurRadius: effectiveElevation * 2,
                offset: Offset(0, effectiveElevation),
              ),
            ]
          : null,
    );

    final content = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      decoration: decoration,
      clipBehavior: clip,
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      );
    }
    return content;
  }
}
