import 'package:flutter/material.dart';

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
    const Color borderDefault = Color(0xFFE0E0E0);
    const Color borderFocused = Color(0xFFF4C430);
    const Color borderError = Color(0xFFEB5757);
    const Color labelDefault = Color(0xFF000000);
    const Color labelError = Color(0xFFEB5757);
    const Color placeholderColor = Color(0xFFBDBDBD);

    final bool hasError = _hasError;
    final bool isFocused = _isFocused && widget.enabled;

    final Color effectiveBorderColor =
        hasError ? borderError : (isFocused ? borderFocused : borderDefault);
    final Color effectiveLabelColor = hasError ? labelError : labelDefault;
    // Background always stays white, only border changes on focus
    final Color effectiveFillColor = Colors.white;

    final TextStyle effectiveTextStyle = (widget.textStyle ??
            const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ))
        .copyWith(
      color: widget.enabled ? (widget.textStyle?.color ?? Colors.black) : Colors.grey,
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
                style: TextStyle(
                  fontSize: 14,
                  color: effectiveLabelColor,
                  fontWeight: FontWeight.w500,
                ),
                children: widget.isRequired
                    ? const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Color(0xFFEB5757),
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
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: placeholderColor,
                ),
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
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFEB5757),
            ),
          ),
        ],
      ],
    );
  }
}

