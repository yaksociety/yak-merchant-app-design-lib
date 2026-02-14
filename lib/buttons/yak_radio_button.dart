import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

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

  /// Optional helper text shown below this option only, indented to align with the label.
  /// Use for per-option description (e.g. tax note under "No").
  final String? helperText;

  /// Style for [helperText]. Defaults to gray, 14px.
  final TextStyle? helperStyle;

  /// Called when the user taps close on this option's helper. When set, a close icon is shown.
  final VoidCallback? onHelperClose;

  /// Color when selected. Defaults to [YakColor.primitive.primary.primary500].
  /// Use e.g. [YakColor.primitive.blue.blue600] for dark blue.
  final Color? activeColor;

  /// Color for unselected border/circle. Defaults to [YakColor.primitive.gray.gray300].
  final Color? inactiveColor;

  const YakRadioButton({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    required this.label,
    this.subtitle,
    this.helperText,
    this.helperStyle,
    this.onHelperClose,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color active = activeColor ?? YakColor.semantic.textAndIcons.primary;
    final Color inactive =
        inactiveColor ?? YakColor.semantic.textAndIcons.baseSecond;

    final RadioThemeData radioTheme = RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) return active;
        return inactive;
      }),
    );

    final bool inRadioGroup = RadioGroup.maybeOf(context) != null;
    final bool enabled = inRadioGroup || onChanged != null;

    final ThemeData theme = Theme.of(context);
    final ThemeData tileTheme = theme.copyWith(
      radioTheme: radioTheme,
      listTileTheme: theme.listTileTheme.copyWith(horizontalTitleGap: 0),
    );

    final Widget tile = Theme(
      data: tileTheme,
      child: inRadioGroup
          ? RadioListTile<T>(
              value: value,
              title: Text(
                label,
                style: YakTypography.semantic.textM.medium.copyWith(
                  color: YakColor.semantic.textAndIcons.baseMain,
                ),
              ),
              subtitle: subtitle != null && subtitle!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: YakTypography.semantic.textS.regular.copyWith(
                          color: YakColor.semantic.textAndIcons.baseSecond,
                        ),
                      ),
                    )
                  : null,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              enabled: enabled,
            )
          : RadioListTile<T>(
              value: value,
              groupValue: groupValue, // ignore: deprecated_member_use
              // ignore: deprecated_member_use -- standalone use without RadioGroup
              onChanged: enabled ? (T? v) => onChanged?.call(v) : null,
              title: Text(
                label,
                style: YakTypography.semantic.textM.medium.copyWith(
                  color: YakColor.semantic.textAndIcons.baseMain,
                ),
              ),
              subtitle: subtitle != null && subtitle!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: YakTypography.semantic.textS.regular.copyWith(
                          color: YakColor.semantic.textAndIcons.baseSecond,
                        ),
                      ),
                    )
                  : null,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
