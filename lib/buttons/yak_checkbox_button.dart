import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

enum YakCheckboxSize { s, m, l }

enum YakCheckboxShape { circle, roundedSquare }

/// Visual style for the selected state:
/// - stroke: outline + check (no fill)
/// - fill: filled + check
enum YakCheckboxVariant { stroke, fill }

double _indicatorSize(YakCheckboxSize size) {
  switch (size) {
    case YakCheckboxSize.s:
      return 16;
    case YakCheckboxSize.m:
      return 20;
    case YakCheckboxSize.l:
      return 24;
  }
}

double _strokeWidth(YakCheckboxSize size) {
  switch (size) {
    case YakCheckboxSize.s:
      return 1.5;
    case YakCheckboxSize.m:
    case YakCheckboxSize.l:
      return 2;
  }
}

double _squareRadius(YakCheckboxSize size) {
  switch (size) {
    case YakCheckboxSize.s:
      return 4;
    case YakCheckboxSize.m:
      return 5;
    case YakCheckboxSize.l:
      return 6;
  }
}

/// Checkbox option for the Yak design system.
///
/// Renders a custom checkbox indicator (circle or rounded-square) with
/// stroke/fill variants and a focused glow, matching the design reference.
class YakCheckboxButton extends StatelessWidget {
  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the checkbox is toggled.
  ///
  /// When null, the control is disabled.
  final ValueChanged<bool>? onChanged;

  /// Main label shown next to the checkbox.
  final String label;

  /// Optional secondary text below [label].
  final String? subtitle;

  /// Style for [label]. Defaults to semantic text S medium.
  final TextStyle? labelStyle;

  /// Style for [subtitle]. Defaults to semantic text S regular.
  final TextStyle? subtitleStyle;

  /// Main color for the control (selected border/fill).
  ///
  /// Defaults to `YakColor.semantic.textAndIcons.primary`.
  final Color? color;

  /// Checkmark color when selected.
  ///
  /// Defaults to:
  /// - [YakColor.semantic.textAndIcons.onColor] for [YakCheckboxVariant.fill]
  /// - [color] (same as ring) for [YakCheckboxVariant.stroke]
  final Color? checkColor;

  /// Color for unselected border. Defaults to `YakColor.semantic.stroke.base`.
  final Color? inactiveColor;

  /// Size of the control.
  final YakCheckboxSize size;

  /// Shape of the control.
  final YakCheckboxShape shape;

  /// Selected-state style variant.
  final YakCheckboxVariant variant;

  const YakCheckboxButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.subtitle,
    this.labelStyle,
    this.subtitleStyle,
    this.color,
    this.checkColor,
    this.inactiveColor,
    this.size = YakCheckboxSize.m,
    this.shape = YakCheckboxShape.circle,
    this.variant = YakCheckboxVariant.fill,
  });

  bool get _enabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final Color active = color ?? YakColor.semantic.textAndIcons.primary;
    final Color inactive = inactiveColor ?? YakColor.semantic.stroke.base;

    final Color effectiveInactive =
        _enabled ? inactive : YakColor.semantic.textAndIcons.disabled;
    final Color effectiveActive =
        _enabled ? active : YakColor.semantic.textAndIcons.disabled;

    final double indicatorSize = _indicatorSize(size);
    final double borderWidth = _strokeWidth(size);
    final double squareRadius = _squareRadius(size);

    final Color defaultCheck = variant == YakCheckboxVariant.fill
        ? YakColor.semantic.textAndIcons.onColor
        : effectiveActive;
    final Color effectiveCheckColor =
        _enabled ? (checkColor ?? defaultCheck) : YakColor.semantic.textAndIcons.disabled;

    final TextStyle effectiveLabelStyle = (labelStyle ??
            YakTypography.semantic.textS.medium)
        .copyWith(
      color: _enabled
          ? YakColor.semantic.textAndIcons.baseMain
          : YakColor.semantic.textAndIcons.disabled,
    );
    final TextStyle effectiveSubtitleStyle = (subtitleStyle ??
            YakTypography.semantic.textS.regular)
        .copyWith(
      color: _enabled
          ? YakColor.semantic.textAndIcons.baseSecond
          : YakColor.semantic.textAndIcons.disabled,
    );

    return Focus(
      canRequestFocus: _enabled,
      child: Builder(
        builder: (context) {
          final bool focused = Focus.of(context).hasFocus;
          final bool hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

          Color borderColor() {
            if (focused) return effectiveActive;
            return value ? effectiveActive : effectiveInactive;
          }

          Color fillColor() {
            if (focused) {
              // Focused state in the reference shows a soft glow and a subtle tint.
              // - Fill + checked: keep solid fill
              // - Stroke + checked: light tint (still reads as stroke style)
              // - Unchecked: very light tint
              if (value && variant == YakCheckboxVariant.fill) {
                return effectiveActive;
              }
              if (value && variant == YakCheckboxVariant.stroke) {
                return effectiveActive.withValues(alpha: 0.12);
              }
              return effectiveActive.withValues(alpha: 0.08);
            }
            if (!value) return Colors.transparent;
            return variant == YakCheckboxVariant.fill
                ? effectiveActive
                : YakColor.semantic.background.baseMain;
          }

          final List<BoxShadow> glow = focused && _enabled
              ? [
                  BoxShadow(
                    color: effectiveActive.withValues(alpha: 0.22),
                    blurRadius: 7,
                    spreadRadius: 1,
                  ),
                ]
              : const [];

          final BoxDecoration decoration = shape == YakCheckboxShape.circle
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: fillColor(),
                  boxShadow: glow,
                  border: Border.all(color: borderColor(), width: borderWidth),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(squareRadius),
                  color: fillColor(),
                  boxShadow: glow,
                  border: Border.all(color: borderColor(), width: borderWidth),
                );

          final Widget indicator = AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            width: indicatorSize,
            height: indicatorSize,
            decoration: decoration,
            child: value
                ? Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: indicatorSize * 0.68,
                      color: effectiveCheckColor,
                    ),
                  )
                : null,
          );

          return InkWell(
            onTap: _enabled ? () => onChanged!.call(!value) : null,
            borderRadius: BorderRadius.circular(12),
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment:
                    hasSubtitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    child: Align(
                      alignment: hasSubtitle
                          ? Alignment.topLeft
                          : Alignment.centerLeft,
                      child: indicator,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: effectiveLabelStyle),
                        if (hasSubtitle) ...[
                          const SizedBox(height: 4),
                          Text(subtitle!, style: effectiveSubtitleStyle),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

