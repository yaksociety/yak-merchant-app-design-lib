import 'package:flutter/material.dart';

import '../theme/yak_color.dart';

/// Style variant for [YakSelect], matching DropdownClass from the Android design.
enum YakSelectStyle {
  /// Minimal padding, compact design.
  compact,

  /// Minimal styling with subtle border.
  minimal,

  /// Standard styling with full border and padding (default).
  normal,
}

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

  const YakSelectItem({required this.value, required this.label, this.icon});
}

/// Select / dropdown widget for the Yak design system.
///
/// Aligned with DropdownStyle from the Android app:
/// - Optional label with red `*` when [isRequired]; label uses error color when [errorMessage] is set
/// - Border: error → danger, expanded → primary, default → neutral; border width 1, radius 12
/// - Background: disabled → neutral50, else white; padding 16 horizontal, 12 vertical
/// - Chevron (size 20) only when items.length > 1; rotates when open
/// - Dropdown menu: max height 200, rounded 12; selected item shows check icon (primary)
/// - [YakSelectStyle] for compact / minimal / normal (affects text and icon size)
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

  /// Style variant: compact, minimal, or normal (default).
  final YakSelectStyle style;

  /// When true, show item [YakSelectItem.icon] in the selector and in the dropdown list.
  final bool visibleIcon;

  /// Optional override for the selector button text/placeholder color.
  final Color? buttonTextColor;

  /// Corner radius for the selector and dropdown. When null, uses style default (compact: 8, minimal: 10, normal: 12).
  final double? borderRadius;

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
    this.style = YakSelectStyle.normal,
    this.visibleIcon = true,
    this.buttonTextColor,
    this.borderRadius,
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
  bool get _showIconInSelector =>
      widget.visibleIcon && _selectedItem?.icon != null;

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
        style: widget.style,
        visibleIcon: widget.visibleIcon,
        borderRadius: _radius,
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

  static const double _borderWidth = 1;

  double get _radius {
    if (widget.borderRadius != null) return widget.borderRadius!;
    switch (widget.style) {
      case YakSelectStyle.compact:
        return 8;
      case YakSelectStyle.minimal:
        return 10;
      case YakSelectStyle.normal:
        return 12;
    }
  }

  EdgeInsets get _padding {
    switch (widget.style) {
      case YakSelectStyle.compact:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
      case YakSelectStyle.minimal:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case YakSelectStyle.normal:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  double get _selectorIconSize {
    switch (widget.style) {
      case YakSelectStyle.compact:
        return 16;
      case YakSelectStyle.minimal:
        return 18;
      case YakSelectStyle.normal:
        return 20;
    }
  }

  double get _chevronSize => _selectorIconSize;

  /// Compact style uses fixed height 34 (language selector). Others size by content.
  double? get _fixedHeight =>
      widget.style == YakSelectStyle.compact ? 34 : null;

  TextStyle _selectorTextStyle() {
    switch (widget.style) {
      case YakSelectStyle.compact:
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        );
      case YakSelectStyle.minimal:
      case YakSelectStyle.normal:
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        );
    }
  }

  /// Icon in selector; compact style gets rounded clip.
  Widget _buildIconInSelector(Widget icon) {
    const double iconRadius = 6;
    final child = ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: _selectorIconSize,
        height: _selectorIconSize,
      ),
      child: icon,
    );
    if (widget.style == YakSelectStyle.compact) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(iconRadius),
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _hasError;
    final bool isOpen = _overlayEntry != null;
    final bool isFocused = (_isFocused || isOpen) && widget.enabled;

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
    final Color textColor =
        widget.buttonTextColor ??
        (widget.enabled
            ? YakColor.semantic.textAndIcons.baseMain
            : YakColor.semantic.textAndIcons.disabled);
    final Color placeholderColor = YakColor.semantic.textAndIcons.baseMain;
    final Color chevronColor = widget.enabled
        ? YakColor.semantic.textAndIcons.baseMain
        : YakColor.semantic.textAndIcons.disabled;

    final String displayText =
        _selectedItem?.label ?? (widget.placeholder ?? 'Select an option');
    final bool isPlaceholder = !_hasSelection;
    final YakSelectItem<T>? selectedItem = _selectedItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_hasLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: widget.label!,
                style: TextStyle(
                  fontSize: 14,
                  color: labelColor,
                  fontWeight: FontWeight.w400,
                ),
                children: widget.isRequired
                    ? [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: YakColor.primitive.danger.danger500,
                            fontWeight: FontWeight.w600,
                          ),
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
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(color: borderColor, width: _borderWidth),
                ),
                child: _fixedHeight != null
                    ? SizedBox(
                        height: _fixedHeight!,
                        child: Padding(
                          padding: _padding,
                          child: Row(
                            children: [
                              if (_showIconInSelector) ...[
                                _buildIconInSelector(selectedItem!.icon!),
                                SizedBox(
                                  width: widget.style == YakSelectStyle.compact
                                      ? 6
                                      : 8,
                                ),
                              ],
                              Expanded(
                                child: Text(
                                  displayText,
                                  style: _selectorTextStyle().copyWith(
                                    color: isPlaceholder
                                        ? placeholderColor
                                        : textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              if (_showChevron)
                                Transform.rotate(
                                  angle: isOpen ? 3.14159 : 0,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: chevronColor,
                                    size: _chevronSize,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: _padding,
                        child: Row(
                          children: [
                            if (_showIconInSelector) ...[
                              _buildIconInSelector(selectedItem!.icon!),
                              SizedBox(
                                width: widget.style == YakSelectStyle.compact
                                    ? 6
                                    : 8,
                              ),
                            ],
                            Expanded(
                              child: Text(
                                displayText,
                                style: _selectorTextStyle().copyWith(
                                  color: isPlaceholder
                                      ? placeholderColor
                                      : textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            if (_showChevron)
                              Transform.rotate(
                                angle: isOpen ? 3.14159 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: chevronColor,
                                  size: _chevronSize,
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              widget.errorMessage!,
              style: TextStyle(
                fontSize: 12,
                color: YakColor.primitive.danger.danger600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SelectOverlay<T> extends StatefulWidget {
  final LayerLink layerLink;
  final Size size;
  final List<YakSelectItem<T>> items;
  final T? value;
  final YakSelectStyle style;
  final bool visibleIcon;
  final double borderRadius;
  final ValueChanged<T?> onSelected;
  final VoidCallback onTapOutside;

  const _SelectOverlay({
    required this.layerLink,
    required this.size,
    required this.items,
    required this.value,
    required this.style,
    required this.visibleIcon,
    required this.borderRadius,
    required this.onSelected,
    required this.onTapOutside,
  });

  @override
  State<_SelectOverlay<T>> createState() => _SelectOverlayState<T>();
}

class _SelectOverlayState<T> extends State<_SelectOverlay<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const double _itemIconSize = 16;
  static const double _checkSize = 12;
  static const double _dropdownMaxHeight = 200;

  Widget _buildOverlayIcon(Widget icon) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: _itemIconSize,
        height: _itemIconSize,
      ),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownContent = Container(
      width: widget.size.width,
      decoration: BoxDecoration(
        color: YakColor.semantic.background.baseMain,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: YakColor.primitive.neutral.neutral700),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: _dropdownMaxHeight),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 4),
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final isSelected = item.value == widget.value;
            return InkWell(
              onTap: () => widget.onSelected(item.value),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    if (widget.visibleIcon && item.icon != null) ...[
                      _buildOverlayIcon(item.icon!),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: YakColor.semantic.textAndIcons.baseMain,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        size: _checkSize,
                        color: YakColor.primitive.primary.primary500,
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
          onTap: widget.onTapOutside,
          behavior: HitTestBehavior.opaque,
          child: Container(color: Colors.transparent),
        ),
        Positioned(
          width: widget.size.width,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, widget.size.height - 2),
            child: Material(
              color: Colors.transparent,
              child: FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: _animation.drive(Tween<double>(begin: 0.98, end: 1.0)),
                  alignment: Alignment.topCenter,
                  child: dropdownContent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
