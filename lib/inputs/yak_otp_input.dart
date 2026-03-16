import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// OTP / PIN input composed of multiple boxes.
///
/// Designed to match the screenshot: evenly spaced rounded boxes,
/// with a highlighted (gold) border & background for the active box.
class YakOtpInput extends StatefulWidget {
  /// Number of digits in the OTP.
  final int length;

  /// Error message shown below the boxes.
  ///
  /// When provided (non-empty), the input shows an error state (red borders).
  final String? errorMessage;

  /// Callback when any digit changes. Returns the full current value.
  final ValueChanged<String>? onChanged;

  /// Callback when all digits are filled.
  final ValueChanged<String>? onCompleted;

  /// Size of each box (width and height).
  final double boxSize;

  /// Spacing between boxes.
  final double spacing;

  /// Text style for digits.
  final TextStyle? textStyle;

  /// Whether to obscure the digits (e.g. show • instead of numbers).
  final bool obscureText;

  /// Whether to autofocus the first digit box when the widget is built.
  final bool autofocus;

  /// Whether the input is enabled.
  final bool enabled;

  const YakOtpInput({
    super.key,
    this.length = 6,
    this.errorMessage,
    this.onChanged,
    this.onCompleted,
    this.boxSize = 48,
    this.spacing = 12,
    this.textStyle,
    this.autofocus = false,
    this.obscureText = false,
    this.enabled = true,
  }) : assert(length > 0, 'length must be greater than 0');

  @override
  State<YakOtpInput> createState() => _YakOtpInputState();
}

class _YakOtpInputState extends State<YakOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    for (var i = 0; i < _focusNodes.length; i++) {
      final node = _focusNodes[i];
      final index = i;
      node.addListener(_onFocusChange);
      node.onKeyEvent = (_, KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _controllers[index].text.isEmpty &&
            index > 0) {
          _controllers[index - 1].clear();
          _focusNodes[index - 1].requestFocus();
          final code = _controllers.map((c) => c.text).join();
          widget.onChanged?.call(code);
          setState(() {});
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.removeListener(_onFocusChange);
      node.onKeyEvent = null;
    }
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _handleChange(int index, String value) {
    if (value.length > 1) {
      // Take only the last character typed (e.g. paste).
      value = value.substring(value.length - 1);
      _controllers[index].text = value;
      _controllers[index].selection = TextSelection.collapsed(
        offset: _controllers[index].text.length,
      );
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    // When user deletes (backspace): move focus to previous box so they can keep deleting.
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);

    final bool isComplete = _controllers.every((c) => c.text.isNotEmpty);
    if (isComplete) {
      widget.onCompleted?.call(code);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color borderDefault = Color(0xFFE0E0E0);
    const Color borderFocused = Color(0xFFF4C430);
    const Color fillFocused = Colors.white;
    const Color borderError = Color(0xFFE53935);
    const Color fillError = Colors.white;
    const Color fillDisabled = Colors.grey;

    final TextStyle effectiveStyle =
        widget.textStyle ??
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        );

    // Use LayoutBuilder so boxes can shrink on small screens instead of overflowing.
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool hasError =
            widget.errorMessage != null &&
            widget.errorMessage!.trim().isNotEmpty;

        // Default to the configured boxSize.
        double boxSize = widget.boxSize;

        if (maxWidth.isFinite) {
          final double totalSpacing =
              widget.spacing * (widget.length - 1).clamp(0, widget.length - 1);
          final double availableForBoxes = maxWidth - totalSpacing;

          if (availableForBoxes > 0) {
            final double candidate = availableForBoxes / widget.length;
            if (candidate < boxSize) {
              boxSize = candidate;
            }
          }
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.length, (index) {
                final bool isFocused = _focusNodes[index].hasFocus;
                final bool isEnabled = widget.enabled;

                final Color borderColor = !isEnabled
                    ? borderDefault
                    : hasError
                    ? borderError
                    : isFocused
                    ? borderFocused
                    : borderDefault;

                final Color fillColor = !isEnabled
                    ? fillDisabled
                    : hasError
                    ? fillError
                    : isFocused
                    ? fillFocused
                    : Colors.white;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == widget.length - 1 ? 0 : widget.spacing,
                  ),
                  child: SizedBox(
                    width: boxSize,
                    height: boxSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          autofocus: widget.autofocus && index == 0,
                          enabled: widget.enabled,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: effectiveStyle,
                          obscureText: widget.obscureText,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) => _handleChange(index, value),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (hasError) ...[
              const SizedBox(height: 32),
              Text(
                widget.errorMessage!.trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: borderError,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
