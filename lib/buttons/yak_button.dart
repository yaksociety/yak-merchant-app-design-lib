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

  /// Optional icon before the text (primary/secondary/ghost only).
  final Widget? leftIcon;

  /// Optional icon after the text (primary/secondary/ghost only).
  final Widget? rightIcon;

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

  const YakButton({
    super.key,
    required this.text,
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.icon,
    this.isCircularIcon = true,
    this.isLoading = false,
    this.width,
    this.height = 48.0,
    this.variant = YakButtonVariant.primary,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
  });

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    const Color primaryBackground = Color(0xFFF4C430);
    const Color primaryText = Colors.black;
    const Color disabledBackground = Color(0xFFE0E0E0);
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

    final TextStyle effectiveTextStyle =
        baseTextStyle.merge(textStyle).copyWith(color: effectiveTextColor);

    switch (variant) {
      case YakButtonVariant.icon:
        return _buildIconButton(
          background: backgroundColor ?? primaryBackground,
          iconColor: effectiveTextColor,
        );
      case YakButtonVariant.floating:
        return _buildFloatingButton(
          background: backgroundColor ?? primaryBackground,
          iconColor: effectiveTextColor,
        );
      case YakButtonVariant.primary:
      case YakButtonVariant.secondary:
      case YakButtonVariant.ghost:
        return _buildTextualButton(
          primaryBackground: primaryBackground,
          disabledBackground: disabledBackground,
          disabledText: disabledText,
          effectiveTextStyle: effectiveTextStyle,
          effectiveTextColor: effectiveTextColor,
        );
    }
  }

  /// Primary / Secondary / Ghost – text-based buttons with optional icons.
  Widget _buildTextualButton({
    required Color primaryBackground,
    required Color disabledBackground,
    required Color disabledText,
    required TextStyle effectiveTextStyle,
    required Color effectiveTextColor,
  }) {
    const Color ghostTextDefault = Color(0xFFF4C430);

    final Widget content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == YakButtonVariant.ghost ? ghostTextDefault : effectiveTextColor,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leftIcon != null) ...[
                leftIcon!,
                const SizedBox(width: 8),
              ],
              Text(text, style: effectiveTextStyle),
              if (rightIcon != null) ...[
                const SizedBox(width: 8),
                rightIcon!,
              ],
            ],
          );

    final ButtonStyle style;
    switch (variant) {
      case YakButtonVariant.primary:
        style = ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? primaryBackground,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: disabledBackground,
          disabledForegroundColor: disabledText,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
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
        style = OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: disabledText,
          side: BorderSide(
            color: _isDisabled ? disabledBackground : effectiveTextColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
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
        style = TextButton.styleFrom(
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: disabledText,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
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

    final Widget child = isLoading
        ? SizedBox(
            width: size / 2,
            height: size / 2,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          )
        : Icon(icon ?? Icons.circle, size: size / 2, color: iconColor);

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: _isDisabled ? const Color(0xFFE0E0E0) : background,
        shape: isCircularIcon
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: InkWell(
          onTap: _isDisabled || isLoading ? null : onPressed,
          customBorder: isCircularIcon
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
    final Widget? fabIcon =
        icon != null ? Icon(icon, color: iconColor, size: 24) : null;

    if (hasLabel) {
      return FloatingActionButton.extended(
        onPressed: _isDisabled || isLoading ? null : onPressed,
        backgroundColor: background,
        foregroundColor: iconColor,
        elevation: 6,
        icon: fabIcon,
        label: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
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
        backgroundColor: background,
        foregroundColor: iconColor,
        elevation: 6,
        child: isLoading
            ? SizedBox(
                width: size / 2,
                height: size / 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                ),
              )
            : fabIcon,
      ),
    );
  }
}

