import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/theme/yak_color.dart';
import 'package:yak_merchant_app_design_lib/theme/yak_typography.dart';

/// Search input that behaves like [YakTextInput] but uses
/// Text S/Regular for input and placeholder (Google Sans, 400, 150% line height).
class YakSearchInput extends StatefulWidget {
  /// Optional label shown above the field.
  final String? label;

  /// Whether to show a red `*` after the label.
  final bool isRequired;

  /// Placeholder / hint text inside the field.
  final String? placeholder;

  /// Optional external controller. If null, an internal controller is used.
  final TextEditingController? controller;

  /// Optional focus node. If null, an internal focus node is used.
  final FocusNode? focusNode;

  /// Optional current error message. If null or empty, no error is shown.
  final String? errorMessage;

  /// Callback triggered whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Keyboard type for the input.
  final TextInputType keyboardType;

  /// Whether the field is enabled.
  final bool enabled;

  const YakSearchInput({
    super.key,
    this.label,
    this.isRequired = false,
    this.placeholder,
    this.controller,
    this.focusNode,
    this.errorMessage,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
  });

  @override
  State<YakSearchInput> createState() => _YakSearchInputState();
}

class _YakSearchInputState extends State<YakSearchInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  bool get _hasLabel => (widget.label ?? '').trim().isNotEmpty;
  bool get _hasError => (widget.errorMessage ?? '').trim().isNotEmpty;

  /// Text S/Regular: design token for size, 150% line height, Base-Main color.
  static TextStyle get _textStyle => YakTypography.semantic.textS.medium
      .copyWith(color: YakColor.semantic.textAndIcons.baseMain, height: 1.5);

  static TextStyle get _hintStyle => YakTypography.semantic.textXS.regular
      .copyWith(color: YakColor.semantic.textAndIcons.baseSecond, height: 1.5);

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownsController = true;
      _controller = TextEditingController();
    } else {
      _controller = widget.controller!;
    }
    if (widget.focusNode == null) {
      _ownsFocusNode = true;
      _focusNode = FocusNode();
    } else {
      _focusNode = widget.focusNode!;
    }
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant YakSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) _controller.dispose();
      if (widget.controller == null) {
        _ownsController = true;
        _controller = TextEditingController(text: _controller.text);
      } else {
        _ownsController = false;
        _controller = widget.controller!;
      }
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      if (_ownsFocusNode) _focusNode.dispose();
      if (widget.focusNode == null) {
        _ownsFocusNode = true;
        _focusNode = FocusNode();
      } else {
        _ownsFocusNode = false;
        _focusNode = widget.focusNode!;
      }
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _hasError;
    final bool isFocused = _isFocused && widget.enabled;
    final Color effectiveBorderColor = hasError
        ? YakColor.semantic.textAndIcons.danger
        : (isFocused
              ? YakColor.semantic.stroke.primary
              : YakColor.semantic.stroke.base);
    final Color effectiveLabelColor = hasError
        ? YakColor.semantic.textAndIcons.danger
        : YakColor.semantic.textAndIcons.baseMain;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
                          style: YakTypography.semantic.textS.medium.copyWith(
                            color: YakColor.semantic.textAndIcons.danger,
                          ),
                        ),
                      ]
                    : const [],
              ),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: effectiveBorderColor, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              style: _textStyle.copyWith(
                color: widget.enabled
                    ? YakColor.semantic.textAndIcons.baseMain
                    : YakColor.semantic.textAndIcons.baseSecond,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: widget.placeholder,
                hintStyle: _hintStyle,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorMessage!,
            style: YakTypography.semantic.textXS.regular.copyWith(
              color: YakColor.semantic.textAndIcons.danger,
            ),
          ),
        ],
      ],
    );
  }
}
