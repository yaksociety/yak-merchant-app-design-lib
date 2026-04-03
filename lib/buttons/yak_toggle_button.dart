import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Toggle Button Widget
///
/// A simple, design-system aligned wrapper around [Switch].
///
/// When [label] is non-null and non-empty, the switch and label share one row
/// and taps on the label (and trailing space) toggle the value, matching
/// [YakCheckboxButton] behavior.
class YakToggleButton extends StatelessWidget {
  /// Whether the toggle is on.
  final bool value;

  /// Callback when the toggle changes.
  final ValueChanged<bool>? onChanged;

  /// Width of the toggle.
  final double width;

  /// Height of the toggle.
  final double height;

  /// Track color when the toggle is on.
  ///
  /// Takes precedence over [color] when both are set.
  final Color? activeColor;

  /// Track color when the toggle is off.
  final Color? inactiveColor;

  /// Shorthand for the “on” track color (same role as [activeColor] on checkbox/radio).
  ///
  /// Used when [activeColor] is null.
  final Color? color;

  /// Thumb (knob) color when the toggle is on.
  final Color? activeThumbColor;

  /// Thumb (knob) color when the toggle is off.
  final Color? inactiveThumbColor;

  /// Optional label beside the switch; when set, the label area is tappable.
  final String? label;

  /// Style for [label]. Defaults to semantic text S medium.
  final TextStyle? labelStyle;

  /// Horizontal gap between the switch and [label].
  final double labelSpacing;

  const YakToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 51.0,
    this.height = 31.0,
    this.activeColor,
    this.inactiveColor,
    this.color,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.label,
    this.labelStyle,
    this.labelSpacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onChanged == null;
    final bool enabled = !isDisabled;
    final Color activeTrack =
        activeColor ?? color ?? const Color(0xFF4CAF50);
    final Color inactiveTrack =
        inactiveColor ?? const Color(0xFFE0E0E0);
    final Color onThumb =
        activeThumbColor ?? YakColor.primitive.base.white;
    final Color offThumb =
        inactiveThumbColor ?? YakColor.primitive.base.white;

    final Widget switchWidget = SizedBox(
      width: width,
      height: height,
      child: Switch(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        activeThumbColor: onThumb,
        activeTrackColor: activeTrack,
        inactiveThumbColor: offThumb,
        inactiveTrackColor: inactiveTrack,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    final String? effectiveLabel = label;
    if (effectiveLabel == null || effectiveLabel.isEmpty) {
      return switchWidget;
    }

    final TextStyle effectiveLabelStyle = (labelStyle ??
            YakTypography.semantic.textS.medium)
        .copyWith(
      color: enabled
          ? YakColor.semantic.textAndIcons.baseMain
          : YakColor.semantic.textAndIcons.disabled,
    );

    return MergeSemantics(
      child: InkWell(
        onTap: enabled ? () => onChanged!(!value) : null,
        borderRadius: BorderRadius.circular(12),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              switchWidget,
              SizedBox(width: labelSpacing),
              Expanded(
                child: Text(effectiveLabel, style: effectiveLabelStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

