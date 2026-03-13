import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Date input field for the Yak design system.
///
/// Displays a tappable field with a calendar icon, label, and formatted date.
/// This is the "closed" state — tapping triggers [onTap] which should open
/// a calendar picker (to be wired up separately).
///
/// Matches the design: rounded border, calendar icon on the left,
/// date formatted as DD/MM/YYYY, optional label with red asterisk when required.
class YakDateInput extends StatelessWidget {
  /// Optional label shown above the field.
  final String? label;

  /// Whether to show a red `*` after the label.
  final bool isRequired;

  /// Currently selected date. If null, [placeholder] is shown.
  final DateTime? value;

  /// Placeholder text when no date is selected.
  final String? placeholder;

  /// Optional error message shown below the field.
  final String? errorMessage;

  /// Whether the field is enabled.
  final bool enabled;

  /// Callback when the field is tapped (should open a calendar).
  final VoidCallback? onTap;

  /// Custom date format function. If null, defaults to DD/MM/YYYY.
  final String Function(DateTime date)? dateFormat;

  const YakDateInput({
    super.key,
    this.label,
    this.isRequired = false,
    this.value,
    this.placeholder,
    this.errorMessage,
    this.enabled = true,
    this.onTap,
    this.dateFormat,
  });

  bool get _hasLabel => (label ?? '').trim().isNotEmpty;
  bool get _hasError => (errorMessage ?? '').trim().isNotEmpty;

  String _formatDate(DateTime date) {
    if (dateFormat != null) return dateFormat!(date);
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _hasError;
    final bool hasValue = value != null;

    final Color borderColor = hasError
        ? YakColor.primitive.danger.danger600
        : YakColor.primitive.neutral.neutral700;
    final Color labelColor = hasError
        ? YakColor.primitive.danger.danger600
        : YakColor.semantic.textAndIcons.baseMain;
    final Color fillColor = enabled
        ? YakColor.semantic.background.baseMain
        : YakColor.primitive.neutral.neutral50;
    final Color textColor = enabled
        ? YakColor.semantic.textAndIcons.baseMain
        : YakColor.semantic.textAndIcons.disabled;
    final Color placeholderColor = YakColor.semantic.textAndIcons.baseSecond;
    final Color iconColor = enabled
        ? YakColor.semantic.textAndIcons.baseSecond
        : YakColor.semantic.textAndIcons.disabled;

    final String displayText =
        hasValue ? _formatDate(value!) : (placeholder ?? 'DD/MM/YYYY');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_hasLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: label!,
                style: YakTypography.semantic.textS.regular.copyWith(
                  color: labelColor,
                ),
                children: isRequired
                    ? [
                        TextSpan(
                          text: ' *',
                          style: YakTypography.semantic.textS.semibold.copyWith(
                            color: YakColor.primitive.danger.danger500,
                          ),
                        ),
                      ]
                    : const [],
              ),
            ),
          ),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: iconColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      displayText,
                      style: YakTypography.semantic.textM.regular.copyWith(
                        color: hasValue ? textColor : placeholderColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorMessage!,
              style: YakTypography.semantic.textXS.regular.copyWith(
                color: YakColor.primitive.danger.danger600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
