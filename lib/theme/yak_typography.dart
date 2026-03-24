import 'package:flutter/material.dart';

/// Default font family for Yak typography.
///
/// Google Sans is bundled in this package; apps that depend on
/// [yak_merchant_app_design_lib] get the font automatically.
const String yakFontFamily = 'GoogleSans';
const List<String> yakFontFallback = <String>['NotoSansThai'];
const String yakTypographyPackage = 'yak_merchant_app_design_lib';

/// Yak design system typography.
///
/// Mirrors [TypographyStyle] from the Android merchant app.
class YakTypography {
  YakTypography._();

  /// Primitive typography tokens (font sizes, weights, letter spacing)
  static const YakTypographyPrimitive primitive = YakTypographyPrimitive();

  /// Semantic text styles (headings, body, labels)
  static const YakTypographySemantic semantic = YakTypographySemantic();

  /// [TextTheme] with Yak semantic styles. Use with [ThemeData.textTheme].
  static TextTheme get textTheme => TextTheme(
        displayLarge: semantic.heading1.semibold,
        displayMedium: semantic.heading2.semibold,
        displaySmall: semantic.heading3.semibold,
        headlineLarge: semantic.heading1.semibold,
        headlineMedium: semantic.heading2.semibold,
        headlineSmall: semantic.heading3.semibold,
        titleLarge: semantic.textL.medium,
        titleMedium: semantic.textM.medium,
        titleSmall: semantic.textS.medium,
        bodyLarge: semantic.textL.regular,
        bodyMedium: semantic.textM.regular,
        bodySmall: semantic.textS.regular,
        labelLarge: semantic.textM.medium,
        labelMedium: semantic.textS.medium,
        labelSmall: semantic.textXS.medium,
      );

  /// [Typography] using Yak text theme for both light and dark.
  /// Use with [ThemeData.typography].
  static Typography get materialTypography => Typography(
        black: textTheme,
        white: textTheme,
      );
}

/// Primitive typography tokens
class YakTypographyPrimitive {
  const YakTypographyPrimitive();

  YakTypographyFontSize get fontSize => const YakTypographyFontSize();
  YakTypographyFontWeight get fontWeight => const YakTypographyFontWeight();
  YakTypographyLetterSpacing get letterSpacing =>
      const YakTypographyLetterSpacing();
}

class YakTypographyFontSize {
  const YakTypographyFontSize();

  double get unit8 => 8;
  double get unit10 => 10;
  double get unit12 => 12;
  double get unit14 => 14;
  double get unit16 => 16;
  double get unit18 => 18;
  double get unit20 => 20;
  double get unit22 => 22;
  double get unit24 => 24;
  double get unit26 => 26;
  double get unit28 => 28;
  double get unit32 => 32;
  double get unit36 => 36;
  double get unit40 => 40;
  double get unit48 => 48;
  double get unit64 => 64;
  double get unit72 => 72;
  double get unit96 => 96;
}

class YakTypographyFontWeight {
  const YakTypographyFontWeight();

  FontWeight get regular => FontWeight.w400;
  FontWeight get medium => FontWeight.w500;
  FontWeight get semibold => FontWeight.w600;
  FontWeight get bold => FontWeight.w700;
}

class YakTypographyLetterSpacing {
  const YakTypographyLetterSpacing();

  double get tighter => -2;
  double get light => -1;
  double get normal => 0;
  double get wide => 1;
  double get wider => 2;
}

/// Semantic typography styles
class YakTypographySemantic {
  const YakTypographySemantic();

  YakTypographyHeading get heading1 => const YakTypographyHeading(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );
  YakTypographyHeading get heading2 => const YakTypographyHeading(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );
  YakTypographyHeading get heading3 => const YakTypographyHeading(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  YakTypographyTextSize get textL => const YakTypographyTextSize(fontSize: 18);
  YakTypographyTextSize get textM => const YakTypographyTextSize(fontSize: 16);
  YakTypographyTextSize get textS => const YakTypographyTextSize(fontSize: 14);
  YakTypographyTextSize get textXS => const YakTypographyTextSize(fontSize: 12);
  YakTypographyTextSize get textXXS => const YakTypographyTextSize(fontSize: 10);
}

class YakTypographyHeading {
  const YakTypographyHeading({
    required this.fontSize,
    required this.fontWeight,
    this.letterSpacing = 0,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  TextStyle get semibold => TextStyle(
        fontFamily: yakFontFamily,
        fontFamilyFallback: yakFontFallback,
        package: yakTypographyPackage,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
}

class YakTypographyTextSize {
  const YakTypographyTextSize({
    required this.fontSize,
    this.letterSpacing = 0,
  });

  final double fontSize;
  final double letterSpacing;

  TextStyle get regular => TextStyle(
        fontFamily: yakFontFamily,
        fontFamilyFallback: yakFontFallback,
        package: yakTypographyPackage,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        letterSpacing: letterSpacing,
      );

  TextStyle get medium => TextStyle(
        fontFamily: yakFontFamily,
        fontFamilyFallback: yakFontFallback,
        package: yakTypographyPackage,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        letterSpacing: letterSpacing,
      );

  TextStyle get semibold => TextStyle(
        fontFamily: yakFontFamily,
        fontFamilyFallback: yakFontFallback,
        package: yakTypographyPackage,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: letterSpacing,
      );
}
