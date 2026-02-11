import 'package:flutter/material.dart';

/// Toggle Button Widget
///
/// A simple, design-system aligned wrapper around [Switch].
class YakToggleButton extends StatelessWidget {
  /// Whether the toggle is on.
  final bool value;

  /// Callback when the toggle changes.
  final ValueChanged<bool>? onChanged;

  /// Width of the toggle.
  final double width;

  /// Height of the toggle.
  final double height;

  /// Track color when toggle is on.
  final Color? activeColor;

  /// Track color when toggle is off.
  final Color? inactiveColor;

  const YakToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 51.0,
    this.height = 31.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onChanged == null;
    final Color activeTrack = activeColor ?? const Color(0xFF4CAF50);
    final Color inactiveTrack = inactiveColor ?? const Color(0xFFE0E0E0);

    return SizedBox(
      width: width,
      height: height,
      child: Switch(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        activeColor: Colors.white,
        activeTrackColor: activeTrack,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: inactiveTrack,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

