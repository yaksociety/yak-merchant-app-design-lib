import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Multi-line text area for the Yak design system.
///
/// Matches the address field design:
/// - Label with optional red `*` when required
/// - Rounded corners, light grey border, white background
/// - Taller than single-line input for multi-line content
class YakTextArea extends StatefulWidget {
  /// Optional label shown above the field.
  ///
  /// If null or empty, no label is rendered.
  final String? label;

  /// Whether to show a red `*` after the label.
  final bool isRequired;

  /// Placeholder / hint text inside the field.
  final String? placeholder;

  /// Optional external controller. If null, an internal controller is used.
  final TextEditingController? controller;

  /// Optional current error message. If null or empty, no error is shown.
  final String? errorMessage;

  /// Text style for the input text.
  ///
  /// If null, defaults to the design system body style.
  final TextStyle? textStyle;

  /// Callback triggered whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Minimum number of visible lines. Defaults to 4.
  final int minLines;

  /// Maximum number of lines (null = unbounded).
  final int? maxLines;

  /// Maximum character count (null = unbounded).
  final int? maxLength;

  /// Whether the field is enabled.
  final bool enabled;

  const YakTextArea({
    super.key,
    this.label,
    this.isRequired = false,
    this.placeholder,
    this.controller,
    this.errorMessage,
    this.textStyle,
    this.onChanged,
    this.minLines = 4,
    this.maxLines,
    this.maxLength,
    this.enabled = true,
  });

  @override
  State<YakTextArea> createState() => _YakTextAreaState();
}

class _YakTextAreaState extends State<YakTextArea> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsController = false;

  bool get _hasLabel => (widget.label ?? '').trim().isNotEmpty;
  bool get _hasError => (widget.errorMessage ?? '').trim().isNotEmpty;

  static const double _borderWidth = 1.5;
  static const double _radius = 16; // more rounded to match Figma

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownsController = true;
      _controller = TextEditingController();
    } else {
      _controller = widget.controller!;
    }
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant YakTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      if (widget.controller == null) {
        _ownsController = true;
        _controller = TextEditingController(text: _controller.text);
      } else {
        _ownsController = false;
        _controller = widget.controller!;
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _hasError;
    final bool isFocused = _isFocused && widget.enabled;

    final Color borderColor = hasError
        ? YakColor.primitive.danger.danger600
        : (isFocused
              ? YakColor.primitive.primary.primary500
              : YakColor.primitive.neutral.neutral700);
    final Color labelColor = hasError
        ? YakColor.primitive.danger.danger600
        : YakColor.semantic.textAndIcons.baseMain;
    final Color fillColor = widget.enabled
        ? YakColor.semantic.background.baseMain
        : YakColor.primitive.neutral.neutral50;
    final Color textColor = widget.enabled
        ? YakColor.semantic.textAndIcons.baseMain
        : YakColor.semantic.textAndIcons.disabled;
    final Color placeholderColor = YakColor.semantic.textAndIcons.baseSecond;

    final TextStyle effectiveTextStyle =
        (widget.textStyle ?? YakTypography.semantic.textM.regular).copyWith(
      color: textColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: widget.label!,
                style: YakTypography.semantic.textS.regular.copyWith(
                  color: labelColor,
                ),
                children: widget.isRequired
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
        DecoratedBox(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(
              color: borderColor,
              width: _borderWidth,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              enabled: widget.enabled,
              style: effectiveTextStyle,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              expands: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: widget.placeholder,
                hintStyle: YakTypography.semantic.textM.regular.copyWith(
                  color: placeholderColor,
                ),
                contentPadding: EdgeInsets.zero,
                counterText: '',
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorMessage!,
            style: YakTypography.semantic.textXS.regular.copyWith(
              color: YakColor.primitive.danger.danger600,
            ),
          ),
        ],
      ],
    );
  }
}
