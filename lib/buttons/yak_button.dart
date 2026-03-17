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
enum YakButtonVariant {
  primary,
  secondary,
  ghost,
  icon,
  floating,
}

class _YakOuterFocusRing extends StatefulWidget {
  final bool enabled;
  final double borderRadius;
  final Color ringColor;
  final double ringWidth;
  final Color? idleFillColor;
  final Color? activeFillColor;
  final Color? disabledFillColor;
  final Widget child;

  const _YakOuterFocusRing({
    required this.enabled,
    required this.borderRadius,
    required this.ringColor,
    required this.ringWidth,
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
              left: -widget.ringWidth,
              right: -widget.ringWidth,
              top: -widget.ringWidth,
              bottom: -widget.ringWidth,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _active ? 1 : 0,
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius + widget.ringWidth,
                      ),
                      border: Border.all(
                        color: widget.ringColor,
                        width: widget.ringWidth,
                      ),
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
  });

  bool get _isDisabled => disabled;

  /// Desaturates and lightens a color for disabled state.
  /// Creates a toned-down version of the original color.
  Color _getDisabledColor(Color originalColor) {
    // Blend with white to lighten and desaturate
    return Color.lerp(originalColor, Colors.white, 0.6) ?? originalColor;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBackground =
        backgroundColor ?? YakColor.primitive.primary.primary500;
    final Color primaryText = YakColor.semantic.textAndIcons.baseMain;
    final Color disabledText = YakColor.semantic.textAndIcons.disabled;
    final Color ghostTextDefault = YakColor.primitive.primary.primary500;

    final TextStyle baseTextStyle =
        YakTypography.semantic.textM.semibold.merge(textStyle);

    final Color effectiveTextColor = textColor ??
        textStyle?.color ??
        (variant == YakButtonVariant.ghost ? ghostTextDefault : primaryText);

    final Color finalTextColor = _isDisabled
        ? _getDisabledColor(effectiveTextColor)
        : effectiveTextColor;

    final TextStyle effectiveTextStyle =
        baseTextStyle.copyWith(color: finalTextColor);

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

    if (label != null && label!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabelRow(),
          const SizedBox(height: 8),
          buttonWidget,
        ],
      );
    }
    return buttonWidget;
  }

  /// Label row with optional red asterisk for required fields.
  Widget _buildLabelRow() {
    final TextStyle base = labelStyle ??
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
                color: YakColor.primitive.danger.danger500,
                fontWeight: FontWeight.w600,
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
    final double radius = borderRadius ?? 8;
    final EdgeInsetsGeometry effectivePadding = padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    final BorderSide primaryStroke = stroke ?? BorderSide.none;
    final BorderSide ghostStroke = stroke ?? BorderSide.none;

    // Tone down text color when disabled
    final Color finalTextColor = _isDisabled 
        ? _getDisabledColor(effectiveTextColor) 
        : effectiveTextColor;
    
    final Color iconColor = _isDisabled 
        ? _getDisabledColor(effectiveTextColor) 
        : effectiveTextColor;
    
    final Widget? leading = leftIcon ?? (leadingIcon != null
        ? Icon(leadingIcon, size: iconSize, color: iconColor)
        : null);
    final Widget? trailing = rightIcon ?? (trailingIcon != null
        ? Icon(trailingIcon, size: iconSize, color: iconColor)
        : null);

    final Widget content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == YakButtonVariant.ghost 
                    ? (_isDisabled ? _getDisabledColor(ghostTextDefault) : ghostTextDefault)
                    : finalTextColor,
              ),
            ),
          )
        : trailing != null
            ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leading != null) ...[
                        leading,
                        const SizedBox(width: 8),
                      ],
                      Text(text, style: effectiveTextStyle),
                    ],
                  ),
                  trailing,
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[
                    leading,
                    const SizedBox(width: 8),
                  ],
                  Text(text, style: effectiveTextStyle),
                ],
              );

    final ButtonStyle style;
    switch (variant) {
      case YakButtonVariant.primary:
        final Color buttonBackground = backgroundColor ?? primaryBackground;
        final Color focusRingColor = YakColor.primitive.primary.primary100;
        style = ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _getDisabledColor(buttonBackground);
            }
            return buttonBackground;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _getDisabledColor(effectiveTextColor);
            }
            return effectiveTextColor;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(effectivePadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          // Keep the button face clean; the outer ring is drawn by a wrapper.
          side: WidgetStateProperty.all(primaryStroke),
        );
        return SizedBox(
          width: width,
          height: height,
          child: _YakOuterFocusRing(
            enabled: !(_isDisabled || isLoading),
            borderRadius: radius,
            ringColor: focusRingColor,
            ringWidth: 2,
            child: ElevatedButton(
              onPressed: _isDisabled || isLoading ? null : onPressed,
              style: style,
              child: content,
            ),
          ),
        );
      case YakButtonVariant.secondary:
        final Color focusRingColor = YakColor.primitive.primary.primary100;
        final BorderSide defaultStroke = stroke ??
            BorderSide(
              color: YakColor.primitive.primary.primary500,
              width: 2,
            );
        const BorderSide disabledStroke = BorderSide.none;
        style = ButtonStyle(
          // Background is animated by the outer wrapper (keeps it smooth).
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return YakColor.semantic.textAndIcons.disabled;
            }
            return effectiveTextColor;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(effectivePadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return disabledStroke;
            return defaultStroke;
          }),
        );
        return SizedBox(
          width: width,
          height: height,
          child: _YakOuterFocusRing(
            enabled: !(_isDisabled || isLoading),
            borderRadius: radius,
            ringColor: focusRingColor,
            ringWidth: 2,
            idleFillColor: YakColor.semantic.background.baseMain,
            activeFillColor: YakColor.primitive.primary.primary50,
            disabledFillColor: YakColor.primitive.primary.primary50,
            child: OutlinedButton(
              onPressed: _isDisabled || isLoading ? null : onPressed,
              style: style,
              child: content,
            ),
          ),
        );
      case YakButtonVariant.ghost:
        final Color disabledTextColor = _getDisabledColor(effectiveTextColor);
        style = TextButton.styleFrom(
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: disabledTextColor,
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
    final double radius = borderRadius ?? 8;
    final double ringRadius = isCircularIcon ? size / 2 : radius;
    final Color ringColor = YakColor.primitive.primary.primary100;
    final Color buttonBackground = _isDisabled 
        ? _getDisabledColor(background) 
        : background;
    final Color effectiveIconColor = _isDisabled 
        ? _getDisabledColor(iconColor) 
        : iconColor;

    final Widget child = isLoading
        ? SizedBox(
            width: size / 2,
            height: size / 2,
            child: CircularProgressIndicator(
              strokeWidth: 2,
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
        ringColor: ringColor,
        ringWidth: 2,
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
    final Color effectiveIconColor = _isDisabled 
        ? _getDisabledColor(iconColor) 
        : iconColor;
    final Widget? fabIcon =
        icon != null ? Icon(icon, color: effectiveIconColor, size: 24) : null;
    final Color buttonBackground = _isDisabled 
        ? _getDisabledColor(background) 
        : background;

    if (hasLabel) {
      return FloatingActionButton.extended(
        onPressed: _isDisabled || isLoading ? null : onPressed,
        backgroundColor: buttonBackground,
        foregroundColor: effectiveIconColor,
        elevation: 6,
        icon: fabIcon,
        label: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
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
        backgroundColor: buttonBackground,
        foregroundColor: effectiveIconColor,
        elevation: 6,
        child: isLoading
            ? SizedBox(
                width: size / 2,
                height: size / 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
                ),
              )
            : fabIcon,
      ),
    );
  }
}

