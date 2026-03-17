import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Text input field for the Yak design system.
///
/// Matches the provided designs:
/// - Normal: grey border, placeholder text
/// - Error: red label, red border, error message below
/// - Focused: gold border highlight (background stays white)
class YakTextInput extends StatefulWidget {
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

  /// Keyboard type for the input.
  final TextInputType keyboardType;

  /// Whether to obscure the text (e.g. for passwords).
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  const YakTextInput({
    super.key,
    this.label,
    this.isRequired = false,
    this.placeholder,
    this.controller,
    this.errorMessage,
    this.textStyle,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  State<YakTextInput> createState() => _YakTextInputState();
}

class _YakTextInputState extends State<YakTextInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsController = false;

  bool get _hasLabel => (widget.label ?? '').trim().isNotEmpty;
  bool get _hasError => (widget.errorMessage ?? '').trim().isNotEmpty;

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
  void didUpdateWidget(covariant YakTextInput oldWidget) {
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

    final Color effectiveBorderColor = hasError
        ? YakColor.primitive.danger.danger600
        : (isFocused
            ? YakColor.primitive.primary.primary500
            : YakColor.primitive.neutral.neutral700);
    final Color effectiveLabelColor =
        hasError ? YakColor.primitive.danger.danger600 : YakColor.semantic.textAndIcons.baseMain;
    final Color effectiveFillColor = widget.enabled
        ? YakColor.semantic.background.baseMain
        : YakColor.primitive.neutral.neutral50;

    final TextStyle effectiveTextStyle =
        (widget.textStyle ?? YakTypography.semantic.textM.regular).copyWith(
      color: widget.enabled
          ? (widget.textStyle?.color ?? YakColor.semantic.textAndIcons.baseMain)
          : YakColor.semantic.textAndIcons.disabled,
    );
    final TextStyle hintStyle = YakTypography.semantic.textM.regular.copyWith(
      color: YakColor.semantic.textAndIcons.baseSecond,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RichText(
              text: TextSpan(
                text: widget.label!,
                style: YakTypography.semantic.textS.medium.copyWith(
                  color: effectiveLabelColor,
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
            color: effectiveFillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: effectiveBorderColor,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              enabled: widget.enabled,
              style: effectiveTextStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: widget.placeholder,
                hintStyle: hintStyle,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14), // matches visual
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

