import 'package:flutter/material.dart';

/// Represents a single option in [YakSelect].
///
/// Supports optional [icon] (e.g. flag) displayed before the [label].
class YakSelectItem<T> {
  /// The value returned when this item is selected.
  final T value;

  /// The text displayed for this option.
  final String label;

  /// Optional icon (e.g. flag) shown before the label.
  final Widget? icon;

  const YakSelectItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Select / dropdown widget for the Yak design system.
///
/// Matches the provided designs:
/// - Optional label above with red `*` when required
/// - Rounded corners, light grey border, white/light background
/// - Gold border when focused
/// - Chevron icon (hidden when only 1 item)
/// - Supports icon per item (e.g. flag)
class YakSelect<T> extends StatefulWidget {
  /// Optional label shown above the field.
  final String? label;

  /// Whether to show a red `*` after the label.
  final bool isRequired;

  /// Placeholder text when nothing is selected.
  final String? placeholder;

  /// List of selectable items.
  final List<YakSelectItem<T>> items;

  /// Currently selected value. If null, placeholder is shown.
  final T? value;

  /// Callback when selection changes.
  final ValueChanged<T?>? onChanged;

  /// Optional error message shown below the field.
  final String? errorMessage;

  /// Whether the field is enabled.
  final bool enabled;

  const YakSelect({
    super.key,
    this.label,
    this.isRequired = false,
    this.placeholder,
    required this.items,
    this.value,
    this.onChanged,
    this.errorMessage,
    this.enabled = true,
  });

  @override
  State<YakSelect<T>> createState() => _YakSelectState<T>();
}

class _YakSelectState<T> extends State<YakSelect<T>> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isFocused = false;

  bool get _hasLabel => (widget.label ?? '').trim().isNotEmpty;
  bool get _hasError => (widget.errorMessage ?? '').trim().isNotEmpty;
  bool get _showChevron => widget.items.length > 1 && widget.enabled;
  bool get _hasSelection =>
      widget.value != null &&
      widget.items.any((item) => item.value == widget.value);

  YakSelectItem<T>? get _selectedItem {
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (!widget.enabled || widget.items.isEmpty) return;

    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    if (widget.items.length == 1) {
      widget.onChanged?.call(widget.items.first.value);
      return;
    }

    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _SelectOverlay<T>(
        layerLink: _layerLink,
        size: size,
        items: widget.items,
        value: widget.value,
        onSelected: (value) {
          _removeOverlay();
          widget.onChanged?.call(value);
          _focusNode.unfocus();
        },
        onTapOutside: () {
          _removeOverlay();
          _focusNode.unfocus();
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
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
    final bool isOpen = _overlayEntry != null;
    final bool isFocused = (_isFocused || isOpen) && widget.enabled;

    final Color effectiveBorderColor =
        hasError ? borderError : (isFocused ? borderFocused : borderDefault);
    final Color effectiveLabelColor = hasError ? labelError : labelDefault;
    const Color fillColor = Colors.white;

    final String displayText =
        _selectedItem?.label ?? (widget.placeholder ?? 'Dropdown');
    final bool isPlaceholder = !_hasSelection;
    final YakSelectItem<T>? selectedItem = _selectedItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                          style: TextStyle(color: Color(0xFFEB5757)),
                        ),
                      ]
                    : const [],
              ),
            ),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Focus(
              focusNode: _focusNode,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      if (selectedItem?.icon != null) ...[
                        selectedItem!.icon!,
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          displayText,
                          style: TextStyle(
                            fontSize: 16,
                            color: isPlaceholder ? placeholderColor : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_showChevron)
                        Icon(
                          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey[700],
                          size: 24,
                        ),
                    ],
                  ),
                ),
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

class _SelectOverlay<T> extends StatelessWidget {
  final LayerLink layerLink;
  final Size size;
  final List<YakSelectItem<T>> items;
  final T? value;
  final ValueChanged<T?> onSelected;
  final VoidCallback onTapOutside;

  const _SelectOverlay({
    required this.layerLink,
    required this.size,
    required this.items,
    required this.value,
    required this.onSelected,
    required this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownContent = Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item.value == value;
            return InkWell(
              onTap: () => onSelected(item.value),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      item.icon!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.black
                              : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    return Stack(
      children: [
        GestureDetector(
          onTap: onTapOutside,
          behavior: HitTestBehavior.opaque,
          child: Container(color: Colors.transparent),
        ),
        Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              color: Colors.transparent,
              child: dropdownContent,
            ),
          ),
        ),
      ],
    );
  }
}

