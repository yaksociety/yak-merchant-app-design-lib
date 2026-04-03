import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

enum YakRadioSize { s, m, l }

/// Outer ring diameter (default / unselected circle).
double _outlineDiameter(YakRadioSize size) {
  switch (size) {
    case YakRadioSize.s:
      return 16;
    case YakRadioSize.m:
      return 20;
    case YakRadioSize.l:
      return 22;
  }
}

/// Selected inner dot diameter.
double _innerDotDiameter(YakRadioSize size) {
  switch (size) {
    case YakRadioSize.s:
      return 8;
    case YakRadioSize.m:
      return 12;
    case YakRadioSize.l:
      return 14;
  }
}

double _strokeWidth(YakRadioSize size) {
  switch (size) {
    case YakRadioSize.s:
      return 1.5;
    case YakRadioSize.m:
    case YakRadioSize.l:
      return 2;
  }
}

/// Wraps a group of [YakRadioButton]s in a [RadioGroup] and optional helper text below.
///
/// Pass [groupValue] and [onChanged] here; [YakRadioButton] children need only [value] and [label].
/// Use [helperText] for group-level description. [helperStyle] defaults to dark gray, 14px.
///
/// Example:
/// ```dart
/// YakRadioGroup<String>(
///   groupValue: _value,
///   onChanged: (v) => setState(() => _value = v),
///   children: [
///     YakRadioButton<String>(value: 'yes', label: 'ใช่'),
///     YakRadioButton<String>(value: 'no', label: 'ไม่ใช่', helperText: '...'),
///   ],
/// )
/// ```
class YakRadioGroup<T> extends StatelessWidget {
  /// Currently selected value for the group.
  final T? groupValue;

  /// Called when selection changes.
  final ValueChanged<T?> onChanged;

  /// Radio options (e.g. [YakRadioButton] widgets). Do not pass groupValue/onChanged to them.
  final List<Widget> children;

  /// Optional description shown below the group.
  final String? helperText;

  /// Called when the user taps the close button on the helper. When set, a close icon is shown.
  final VoidCallback? onHelperClose;

  /// Style for [helperText]. Defaults to dark gray (gray700), 14px.
  final TextStyle? helperStyle;

  /// Padding around the helper text. Defaults to top: 8, left: 48 to align with radio labels.
  final EdgeInsetsGeometry? helperPadding;

  /// Top padding above the first radio. Default 0.
  final double? paddingTop;

  /// Bottom padding below helper text (or below children if no helper). Default 0.
  final double? paddingBottom;

  const YakRadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.children,
    this.helperText,
    this.onHelperClose,
    this.helperStyle,
    this.helperPadding,
    this.paddingTop,
    this.paddingBottom,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveHelperStyle =
        helperStyle ??
        YakTypography.semantic.textS.regular.copyWith(
          color: YakColor.semantic.textAndIcons.baseMain,
          height: 1.4,
        );
    final EdgeInsetsGeometry effectiveHelperPadding =
        helperPadding ?? const EdgeInsets.only(top: 0, left: 40);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (paddingTop != null && paddingTop! > 0) SizedBox(height: paddingTop),
        RadioGroup<T>(
          groupValue: groupValue,
          onChanged: onChanged,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        if (helperText != null && helperText!.isNotEmpty) ...[
          Padding(
            padding: effectiveHelperPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(helperText!, style: effectiveHelperStyle)),
                if (onHelperClose != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onHelperClose,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(32, 32),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: YakColor.semantic.textAndIcons.baseMain,
                    ),
                  ),
              ],
            ),
          ),
        ],
        if (paddingBottom != null && paddingBottom! > 0)
          SizedBox(height: paddingBottom),
      ],
    );
  }
}

/// A single radio option for the Yak design system.
///
/// Use with a common [groupValue] so only one option in the group is selected.
/// The whole row (label + subtitle) is tappable. Styled with [YakColor]:
/// primary when selected, gray when unselected.
///
/// Real-case use: delivery method, payment method, size (S/M/L), etc.
///
/// Each option can have its own [helperText] shown directly below that option,
/// indented to align with the label (layout like Yes/No with description under "No").
///
/// When used inside [YakRadioGroup], omit [groupValue] and [onChanged] (the group provides them).
/// When used standalone, pass [groupValue] and [onChanged].
class YakRadioButton<T> extends StatelessWidget {
  /// Value this option represents.
  final T value;

  /// Currently selected value for the group. Omit when inside [YakRadioGroup].
  final T? groupValue;

  /// Called when this option is selected. Omit when inside [YakRadioGroup].
  final ValueChanged<T?>? onChanged;

  /// Main label shown next to the radio.
  final String label;

  /// Optional secondary text below [label] (inside the tile).
  final String? subtitle;

  /// Style for [label]. Defaults to semantic text S medium.
  final TextStyle? labelStyle;

  /// Style for [subtitle]. Defaults to semantic text S regular.
  final TextStyle? subtitleStyle;

  /// Optional helper text shown below this option only, indented to align with the label.
  /// Use for per-option description (e.g. tax note under "No").
  final String? helperText;

  /// Style for [helperText]. Defaults to gray, 14px.
  final TextStyle? helperStyle;

  /// Called when the user taps close on this option's helper. When set, a close icon is shown.
  final VoidCallback? onHelperClose;

  /// Main color for the control (selected border/fill).
  ///
  /// Defaults to `YakColor.semantic.textAndIcons.primary`.
  final Color? color;

  /// Checkmark color when selected.
  ///
  /// Defaults to `YakColor.semantic.textAndIcons.onColor` (white).
  final Color? checkColor;

  /// Color for unselected border/circle. Defaults to [YakColor.primitive.gray.gray300].
  final Color? inactiveColor;

  /// Size of the control.
  final YakRadioSize size;

  const YakRadioButton({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    required this.label,
    this.subtitle,
    this.labelStyle,
    this.subtitleStyle,
    this.helperText,
    this.helperStyle,
    this.onHelperClose,
    this.color,
    this.checkColor,
    this.inactiveColor,
    this.size = YakRadioSize.m,
  });

  @override
  Widget build(BuildContext context) {
    final Color active = color ?? YakColor.semantic.textAndIcons.primary;
    final Color inactive =
        inactiveColor ?? YakColor.semantic.textAndIcons.baseSecond;

    final RadioGroup<T>? group = context
        .findAncestorWidgetOfExactType<RadioGroup<T>>();
    final bool inRadioGroup = group != null;
    final bool enabled = inRadioGroup || onChanged != null;

    final T? effectiveGroupValue = group?.groupValue ?? groupValue;
    final ValueChanged<T?>? effectiveOnChanged = group?.onChanged ?? onChanged;
    final bool selected =
        effectiveGroupValue != null && effectiveGroupValue == value;

    final Color effectiveInactive = enabled
        ? inactive
        : YakColor.semantic.textAndIcons.disabled;
    final Color effectiveActive = enabled
        ? active
        : YakColor.semantic.textAndIcons.disabled;

    final Color effectiveDotColor = enabled
        ? (color != null ? effectiveActive : (checkColor ?? effectiveActive))
        : YakColor.semantic.textAndIcons.disabled;

    final double outlineSize = _outlineDiameter(size);
    final double innerDotSize = _innerDotDiameter(size);
    final double borderWidth = _strokeWidth(size);

    Widget indicator({required bool focused}) {
      final Color borderColor = focused
          ? effectiveActive
          : (selected ? effectiveActive : effectiveInactive);
      final Color fillColor = focused
          ? effectiveActive.withValues(alpha: selected ? 0.12 : 0.14)
          : (selected
                ? YakColor.semantic.background.baseMain
                : Colors.transparent);

      // Focused state in the reference shows a soft glow.
      final List<BoxShadow> glow = focused && enabled
          ? [
              BoxShadow(
                color: effectiveActive.withValues(alpha: 0.22),
                blurRadius: 7,
                spreadRadius: 1,
              ),
            ]
          : const [];

      return AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        width: outlineSize,
        height: outlineSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fillColor,
          boxShadow: glow,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: selected
            ? Center(
                child: Container(
                  width: innerDotSize,
                  height: innerDotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: effectiveDotColor,
                  ),
                ),
              )
            : null,
      );
    }

    final TextStyle effectiveLabelStyle =
        (this.labelStyle ?? YakTypography.semantic.textS.medium).copyWith(
          color: enabled
              ? YakColor.semantic.textAndIcons.baseMain
              : YakColor.semantic.textAndIcons.disabled,
        );
    final TextStyle effectiveSubtitleStyle =
        (this.subtitleStyle ?? YakTypography.semantic.textS.regular).copyWith(
          color: enabled
              ? YakColor.semantic.textAndIcons.baseSecond
              : YakColor.semantic.textAndIcons.disabled,
        );

    final Widget tile = Focus(
      canRequestFocus: enabled,
      child: Builder(
        builder: (context) {
          final bool focused = Focus.of(context).hasFocus;
          final bool hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
          return InkWell(
            onTap: enabled ? () => effectiveOnChanged?.call(value) : null,
            borderRadius: BorderRadius.circular(12),
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: hasSubtitle
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    child: Align(
                      alignment: hasSubtitle
                          ? Alignment.topLeft
                          : Alignment.centerLeft,
                      child: indicator(focused: focused),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: effectiveLabelStyle),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
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

    final bool hasHelper = helperText != null && helperText!.isNotEmpty;
    if (!hasHelper) return tile;

    final TextStyle effectiveHelperStyle =
        helperStyle ??
        YakTypography.semantic.textS.regular.copyWith(
          color: YakColor.semantic.textAndIcons.baseSecond,
          height: 1.4,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tile,
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(helperText!, style: effectiveHelperStyle)),
              if (onHelperClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onHelperClose,
                  style: IconButton.styleFrom(
                    minimumSize: const Size(24, 24),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: YakColor.semantic.textAndIcons.baseSecond,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
