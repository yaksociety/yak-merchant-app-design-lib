import 'package:flutter/material.dart';

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
    const Color primaryBackground = Color(0xFFF4C430);
    const Color primaryText = Colors.black;
    const Color disabledText = Color(0xFF9E9E9E);
    const Color ghostTextDefault = Color(0xFFF4C430);

    // Base text style from design system.
    const TextStyle baseTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    );

    final Color effectiveTextColor = textColor ??
        textStyle?.color ??
        (variant == YakButtonVariant.ghost ? ghostTextDefault : primaryText);
    
    // Tone down text color when disabled
    final Color finalTextColor = _isDisabled 
        ? _getDisabledColor(effectiveTextColor) 
        : effectiveTextColor;

    final TextStyle effectiveTextStyle =
        baseTextStyle.merge(textStyle).copyWith(color: finalTextColor);

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
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
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
                color: Colors.red,
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
    const Color ghostTextDefault = Color(0xFFF4C430);
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
        final Color disabledBg = _isDisabled 
            ? _getDisabledColor(buttonBackground) 
            : buttonBackground;
        final Color disabledTextColor = _getDisabledColor(effectiveTextColor);
        style = ElevatedButton.styleFrom(
          backgroundColor: buttonBackground,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: disabledTextColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: primaryStroke,
          ),
          padding: effectivePadding,
        );
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: _isDisabled || isLoading ? null : onPressed,
            style: style,
            child: content,
          ),
        );
      case YakButtonVariant.secondary:
        final Color strokeColor = _isDisabled 
            ? _getDisabledColor(effectiveTextColor) 
            : effectiveTextColor;
        final BorderSide effectiveSecondaryStroke = stroke ??
            BorderSide(
              color: strokeColor,
              width: 1.5,
            );
        final Color disabledTextColor = _getDisabledColor(effectiveTextColor);
        style = OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: disabledTextColor,
          side: effectiveSecondaryStroke,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: effectivePadding,
        );
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: _isDisabled || isLoading ? null : onPressed,
            style: style,
            child: content,
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
      child: Material(
        color: buttonBackground,
        shape: isCircularIcon
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
        child: InkWell(
          onTap: _isDisabled || isLoading ? null : onPressed,
          customBorder: isCircularIcon
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
          child: Center(child: child),
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

