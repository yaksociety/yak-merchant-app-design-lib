import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// PIN input: previous digits show as dots (•); the current (focused) digit and the
/// most recently entered digit both show the actual number.
///
/// Rounded boxes, gold border on the active box, light gray on others. Same behavior as
/// [YakOtpInput] for focus, backspace, and completion.
class YakPinInput extends StatefulWidget {
  /// Number of digits in the PIN.
  final int length;

  /// Error message shown below the boxes. When non-empty, shows red borders and message.
  final String? errorMessage;

  /// Callback when any digit changes. Returns the full current value.
  final ValueChanged<String>? onChanged;

  /// Callback when all digits are filled.
  final ValueChanged<String>? onCompleted;

  /// Size of each box (width and height).
  final double boxSize;

  /// Spacing between boxes.
  final double spacing;

  /// Text style for digits (and dots).
  final TextStyle? textStyle;

  /// Whether the input is enabled.
  final bool enabled;

  const YakPinInput({
    super.key,
    this.length = 6,
    this.errorMessage,
    this.onChanged,
    this.onCompleted,
    this.boxSize = 48,
    this.spacing = 12,
    this.textStyle,
    this.enabled = true,
  }) : assert(length > 0, 'length must be greater than 0');

  @override
  State<YakPinInput> createState() => _YakPinInputState();
}

class _YakPinInputState extends State<YakPinInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  /// Index of the most recently entered digit (stays visible as number until next action).
  int _lastEnteredIndex = -1;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
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
          _lastEnteredIndex = index >= 2 ? index - 2 : -1;
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
      value = value.substring(value.length - 1);
      _controllers[index].text = value;
      _controllers[index].selection =
          TextSelection.collapsed(offset: _controllers[index].text.length);
    }

    if (value.isNotEmpty) {
      _lastEnteredIndex = index;
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      _lastEnteredIndex = index > 0 ? index - 1 : -1;
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);

    if (_controllers.every((c) => c.text.isNotEmpty)) {
      widget.onCompleted?.call(code);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color borderDefault = Color(0xFFE0E0E0);
    const Color borderFocused = Color(0xFFF4C430);
    const Color borderError = Color(0xFFE53935);
    const Color fillDisabled = Color(0xFFF5F5F5);

    final TextStyle effectiveStyle = widget.textStyle ??
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool hasError =
            widget.errorMessage != null &&
            widget.errorMessage!.trim().isNotEmpty;

        double boxSize = widget.boxSize;
        if (maxWidth.isFinite) {
          final double totalSpacing =
              widget.spacing * (widget.length - 1).clamp(0, widget.length - 1);
          final double availableForBoxes = maxWidth - totalSpacing;
          if (availableForBoxes > 0) {
            final double candidate = availableForBoxes / widget.length;
            if (candidate < boxSize) boxSize = candidate;
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
                final String text = _controllers[index].text;

                final Color borderColor = !isEnabled
                    ? borderDefault
                    : hasError
                        ? borderError
                        : isFocused
                            ? borderFocused
                            : borderDefault;

                final Color fillColor =
                    !isEnabled ? fillDisabled : Colors.white;

                // Show digit if focused or is the latest entered; otherwise dot when filled
                final bool showAsNumber = isFocused || index == _lastEnteredIndex;
                final String visibleChar =
                    showAsNumber ? text : (text.isEmpty ? '' : '•');

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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            enabled: widget.enabled,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: effectiveStyle.copyWith(
                              color: Colors.transparent,
                              decoration: TextDecoration.none,
                              decorationColor: Colors.transparent,
                            ),
                            cursorColor: effectiveStyle.color,
                            maxLength: 1,
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) => _handleChange(index, value),
                          ),
                          IgnorePointer(
                            child: Center(
                              child: Text(
                                visibleChar,
                                style: effectiveStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (hasError) ...[
              const SizedBox(height: 8),
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
