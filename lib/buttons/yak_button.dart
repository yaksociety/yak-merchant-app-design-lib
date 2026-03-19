import 'package:flutter/material.dart';

import '../theme/yak_color.dart';
import '../theme/yak_typography.dart';

/// Visual variants for [YakButton].
///
/// - [YakButtonVariant.primary]   → Regular primary button
/// - [YakButtonVariant.secondary] → Outlined secondary button
/// - [YakButtonVariant.ghost]     → Transparent ghost button
/// - [YakButtonVariant.icon]      → Icon-only button
/// - [YakButtonVariant.floating]  → Floating action button (FAB)
enum YakButtonVariant { primary, secondary, ghost, icon, floating }

/// Alignment behavior for text/icon content inside a full-width button.
enum YakButtonContentAlignment { start, center }

class _YakOuterFocusRing extends StatefulWidget {
  final bool enabled;
  final double borderRadius;
  final Color idleBorderColor;
  final Color activeBorderColor;
  final double borderWidth;
  final Color? idleFillColor;
  final Color? activeFillColor;
  final Color? disabledFillColor;
  final Widget child;

  const _YakOuterFocusRing({
    required this.enabled,
    required this.borderRadius,
    required this.idleBorderColor,
    required this.activeBorderColor,
    required this.borderWidth,
    this.idleFillColor,
    this.activeFillColor,
    this.disabledFillColor,
    required this.child,
  });

  @override
  State<_YakOuterFocusRing> createState() => _YakOuterFocusRingState();
}

class _YakOuterFocusRingState extends State<_YakOuterFocusRing> {
  bool _showFocus = false;
  bool _showHover = false;
  bool _pressed = false;
  int _pressSeq = 0;

  bool get _active => widget.enabled && (_showFocus || _showHover || _pressed);

  void _schedulePressRelease() {
    final int seq = ++_pressSeq;
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      if (seq != _pressSeq) return;
      setState(() => _pressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool show = _active;
    final Color? fill = widget.enabled
        ? (show ? widget.activeFillColor : widget.idleFillColor)
        : widget.disabledFillColor;
    final Color borderColor = show ? widget.activeBorderColor : widget.idleBorderColor;

    return FocusableActionDetector(
      onShowFocusHighlight: (v) => setState(() => _showFocus = v),
      onShowHoverHighlight: (v) => setState(() => _showHover = v),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: widget.enabled
            ? (_) {
                _pressSeq++;
                setState(() => _pressed = true);
              }
            : null,
        onTapUp: widget.enabled ? (_) => _schedulePressRelease() : null,
        onTapCancel: widget.enabled ? _schedulePressRelease : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (fill != null)
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: fill,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
              ),
            widget.child,
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: borderColor,
                      width: widget.borderWidth,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Core button for the design system.
///
/// Use [variant] to select the style you want instead of different widgets.
class YakButton extends StatelessWidget {
  static const double _disabledOpacity = 0.45;

  /// Text label of the button.
  ///
  /// For [YakButtonVariant.icon] you can leave this empty.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// When true, the button is visually and interactively disabled.
  /// Use this instead of relying on [onPressed] being null.
  final bool disabled;

  /// Optional icon before the text (primary/secondary/ghost only).
  final Widget? leftIcon;

  /// Optional icon after the text (primary/secondary/ghost only).
  final Widget? rightIcon;

  /// Leading icon (primary/secondary/ghost). Rendered with [iconSize] and text color.
  /// Ignored if [leftIcon] is set.
  final IconData? leadingIcon;

  /// Trailing icon (primary/secondary/ghost). Rendered with [iconSize] and text color.
  /// Ignored if [rightIcon] is set.
  final IconData? trailingIcon;

  /// Size of [leadingIcon] and [trailingIcon]. Default 20.
  final double iconSize;

  /// Icon data for [YakButtonVariant.icon] and [YakButtonVariant.floating].
  final IconData? icon;

  /// Hero tag for the floating action button variant.
  ///
  /// Defaults to `null` to disable the Hero wrapper, preventing
  /// "multiple heroes share the same tag" when multiple FABs exist on a page.
  /// Set a custom tag to re-enable Hero transitions.
  final Object? heroTag;

  /// Whether icon-style buttons should be circular.
  ///
  /// Only used when [variant] is [YakButtonVariant.icon].
  final bool isCircularIcon;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Explicit width; if null the button sizes to its content.
  final double? width;

  /// Height / size of the button.
  ///
  /// For icon and floating variants this is treated as the diameter/size.
  final double height;

  /// Button style variant.
  final YakButtonVariant variant;

  /// Background color override (mainly for primary and icon/floating).
  final Color? backgroundColor;

  /// Text and icon color override.
  final Color? textColor;

  /// Text style override. If [textColor] is also provided, it wins.
  final TextStyle? textStyle;

  /// Custom border/stroke. When set, overrides default outline for secondary and
  /// adds a border to primary/ghost. Disabled state uses a muted color when [stroke] is null.
  final BorderSide? stroke;

  /// Corner radius for the button shape. Default 8. Ignored for circular icon variant.
  final double? borderRadius;

  /// Optional label shown above the button (e.g. form field label).
  final String? label;

  /// When true, shows a red asterisk after [label]. Use for required fields.
  final bool isRequired;

  /// Text style for [label]. Defaults to dark grey, 14–16px.
  final TextStyle? labelStyle;

  /// Inner padding of the button (primary/secondary/ghost). When null, uses 24 horizontal, 12 vertical.
  final EdgeInsetsGeometry? padding;

  /// Controls how content is aligned when [width] is set (full-width buttons).
  ///
  /// - [YakButtonContentAlignment.center] (default): centered content (current behavior).
  /// - [YakButtonContentAlignment.start]: left-aligned content (useful for "field-style" buttons without a trailing icon).
  final YakButtonContentAlignment contentAlignment;

  const YakButton({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.leftIcon,
    this.rightIcon,
    this.leadingIcon,
    this.trailingIcon,
    this.iconSize = 20.0,
    this.icon,
    this.heroTag,
    this.isCircularIcon = true,
    this.isLoading = false,
    this.width,
    this.height = 48.0,
    this.variant = YakButtonVariant.primary,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.stroke,
    this.borderRadius,
    this.label,
    this.isRequired = false,
    this.labelStyle,
    this.padding,
    this.contentAlignment = YakButtonContentAlignment.center,
  });

  bool get _isDisabled => disabled;

  @override
  Widget build(BuildContext context) {
    final Color primaryBackground =
        backgroundColor ?? YakColor.primitive.primary.primary500;
    final Color primaryText = YakColor.semantic.textAndIcons.baseMain;
    final Color disabledText = YakColor.semantic.textAndIcons.disabled;
    final Color ghostTextDefault = YakColor.primitive.primary.primary500;

    final TextStyle baseTextStyle =
        (variant == YakButtonVariant.primary
                ? YakTypography.semantic.textS.semibold
                : YakTypography.semantic.textS.regular)
            .merge(textStyle);

    final Color effectiveTextColor =
        textColor ??
        textStyle?.color ??
        (variant == YakButtonVariant.ghost ? ghostTextDefault : primaryText);

    final TextStyle effectiveTextStyle = baseTextStyle.copyWith(
      color: effectiveTextColor,
    );

    final Widget buttonWidget;
    switch (variant) {
      case YakButtonVariant.icon:
        buttonWidget = _buildIconButton(
          background: backgroundColor ?? primaryBackground,
          iconColor: effectiveTextColor,
        );
        break;
      case YakButtonVariant.floating:
        buttonWidget = _buildFloatingButton(
          background: backgroundColor ?? primaryBackground,
          iconColor: effectiveTextColor,
        );
        break;
      case YakButtonVariant.primary:
      case YakButtonVariant.secondary:
      case YakButtonVariant.ghost:
        buttonWidget = _buildTextualButton(
          primaryBackground: primaryBackground,
          disabledText: disabledText,
          effectiveTextStyle: effectiveTextStyle,
          effectiveTextColor: effectiveTextColor,
        );
        break;
    }

    final Widget fadedButton = Opacity(
      opacity: _isDisabled ? _disabledOpacity : 1,
      child: buttonWidget,
    );

    if (label != null && label!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [_buildLabelRow(), const SizedBox(height: 8), fadedButton],
      );
    }
    return fadedButton;
  }

  /// Label row with optional red asterisk for required fields.
  Widget _buildLabelRow() {
    final TextStyle base =
        labelStyle ??
        YakTypography.semantic.textS.medium.copyWith(
          color: YakColor.semantic.textAndIcons.baseMain,
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: base),
        if (isRequired)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              '*',
              style: base.copyWith(
                color: YakColor.semantic.textAndIcons.danger,
              ),
            ),
          ),
      ],
    );
  }

  /// Primary / Secondary / Ghost – text-based buttons with optional icons.
  Widget _buildTextualButton({
    required Color primaryBackground,
    required Color disabledText,
    required TextStyle effectiveTextStyle,
    required Color effectiveTextColor,
  }) {
    final Color ghostTextDefault = YakColor.primitive.primary.primary500;
    final double radius = borderRadius ?? 12;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    final bool shouldExpand = width != null;
    final BorderSide ghostStroke = stroke ?? BorderSide.none;

    final Color finalTextColor = effectiveTextColor;
    final Color iconColor = effectiveTextColor;

    final Widget? leading =
        leftIcon ??
        (leadingIcon != null
            ? Icon(leadingIcon, size: iconSize, color: iconColor)
            : null);
    final Widget? trailing =
        rightIcon ??
        (trailingIcon != null
            ? Icon(trailingIcon, size: iconSize, color: iconColor)
            : null);

    final Widget content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == YakButtonVariant.ghost
                    ? ghostTextDefault
                    : finalTextColor,
              ),
            ),
          )
        : trailing != null
        ? Row(
            mainAxisSize: shouldExpand ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (shouldExpand)
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (leading != null) ...[
                        leading,
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          text,
                          style: effectiveTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null) ...[
                      leading,
                      const SizedBox(width: 12),
                    ],
                    Text(text, style: effectiveTextStyle),
                  ],
                ),
              trailing,
            ],
          )
        : Row(
            mainAxisSize: shouldExpand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: shouldExpand
                ? (contentAlignment == YakButtonContentAlignment.start
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center)
                : MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading, const SizedBox(width: 12)],
              if (shouldExpand)
                Flexible(
                  child: Text(
                    text,
                    style: effectiveTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                )
              else
                Text(text, style: effectiveTextStyle),
            ],
          );

    final ButtonStyle style;
    switch (variant) {
      case YakButtonVariant.primary:
        final Color buttonBackground = backgroundColor ?? primaryBackground;
        style = ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonBackground),
          foregroundColor: WidgetStateProperty.all(effectiveTextColor),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(effectivePadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          ),
          // Border is drawn by the wrapper so we don't get double borders.
          side: WidgetStateProperty.all(BorderSide.none),
        );
        return SizedBox(
          width: width,
          height: height,
          child: _YakOuterFocusRing(
            enabled: !(_isDisabled || isLoading),
            borderRadius: radius,
            // Primary buttons don't show an outline; keep border hidden even on focus/press.
            idleBorderColor: Colors.transparent,
            activeBorderColor: Colors.transparent,
            borderWidth: 0,
            child: ElevatedButton(
              onPressed: _isDisabled || isLoading ? null : onPressed,
              style: style,
              child: content,
            ),
          ),
        );
      case YakButtonVariant.secondary:
        final Color focusBorderColor = YakColor.semantic.stroke.primary;
        final BorderSide defaultStroke =
            stroke ??
            BorderSide(color: YakColor.semantic.stroke.base, width: 1);
        style = ButtonStyle(
          // Background is animated by the outer wrapper (keeps it smooth).
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(effectiveTextColor),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(effectivePadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          ),
          // Border is drawn by the wrapper so we don't get double borders.
          side: WidgetStateProperty.all(BorderSide.none),
        );
        return SizedBox(
          width: width,
          height: height,
          child: _YakOuterFocusRing(
            enabled: !(_isDisabled || isLoading),
            borderRadius: radius,
            idleBorderColor: defaultStroke.color,
            activeBorderColor: focusBorderColor,
            borderWidth: defaultStroke.width,
            idleFillColor: YakColor.semantic.background.baseMain,
            // Keep fill the same on focus/press; only the outer ring changes.
            activeFillColor: YakColor.semantic.background.baseMain,
            disabledFillColor: YakColor.semantic.background.baseMain,
            child: OutlinedButton(
              onPressed: _isDisabled || isLoading ? null : onPressed,
              style: style,
              child: content,
            ),
          ),
        );
      case YakButtonVariant.ghost:
        style = TextButton.styleFrom(
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: effectiveTextColor,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: ghostStroke,
          ),
          padding: effectivePadding,
        );
        return SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: _isDisabled || isLoading ? null : onPressed,
            style: style,
            child: content,
          ),
        );
      case YakButtonVariant.icon:
      case YakButtonVariant.floating:
        // Handled by other builders.
        return const SizedBox.shrink();
    }
  }

  /// Icon-only button variant.
  Widget _buildIconButton({
    required Color background,
    required Color iconColor,
  }) {
    final double size = height;
    final double radius = borderRadius ?? 12;
    final double ringRadius = isCircularIcon ? size / 2 : radius;
    final Color ringColor = YakColor.semantic.textAndIcons.primary;
    final Color buttonBackground = background;
    final Color effectiveIconColor = iconColor;

    final Widget child = isLoading
        ? SizedBox(
            width: size / 2,
            height: size / 2,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
            ),
          )
        : Icon(icon ?? Icons.circle, size: size / 2, color: effectiveIconColor);

    return SizedBox(
      width: size,
      height: size,
      child: _YakOuterFocusRing(
        enabled: !(_isDisabled || isLoading),
        borderRadius: ringRadius,
        idleBorderColor: Colors.transparent,
        activeBorderColor: ringColor,
        borderWidth: 1,
        child: Material(
          color: buttonBackground,
          shape: isCircularIcon
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
          child: InkWell(
            onTap: _isDisabled || isLoading ? null : onPressed,
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            customBorder: isCircularIcon
                ? const CircleBorder()
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  /// Floating action button variant.
  Widget _buildFloatingButton({
    required Color background,
    required Color iconColor,
  }) {
    final bool hasLabel = text.isNotEmpty;
    final Color effectiveIconColor = iconColor;
    final Widget? fabIcon = icon != null
        ? Icon(icon, color: effectiveIconColor, size: 24)
        : null;
    final Color buttonBackground = background;

    if (hasLabel) {
      return FloatingActionButton.extended(
        onPressed: _isDisabled || isLoading ? null : onPressed,
        heroTag: heroTag,
        backgroundColor: buttonBackground,
        foregroundColor: effectiveIconColor,
        elevation: 6,
        icon: fabIcon,
        label: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                  color: effectiveIconColor,
                ),
              ),
      );
    }

    final double size = height;
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: _isDisabled || isLoading ? null : onPressed,
        heroTag: heroTag,
        backgroundColor: buttonBackground,
        foregroundColor: effectiveIconColor,
        elevation: 6,
        child: isLoading
            ? SizedBox(
                width: size / 2,
                height: size / 2,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
                ),
              )
            : fabIcon,
      ),
    );
  }
}
