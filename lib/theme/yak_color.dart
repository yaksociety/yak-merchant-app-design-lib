import 'package:flutter/material.dart';

/// Yak design system color palette.
///
/// Mirrors [ColorStyle] from the Android merchant app.
class YakColor {
  YakColor._();

  /// Primitive color tokens
  static const YakColorPrimitive primitive = YakColorPrimitive();

  /// Semantic color tokens for backgrounds, text, icons, and strokes
  static const YakColorSemantic semantic = YakColorSemantic();
}

/// Primitive color palette
class YakColorPrimitive {
  const YakColorPrimitive();

  YakColorPrimary get primary => const YakColorPrimary();
  YakColorBase get base => const YakColorBase();
  YakColorNeutral get neutral => const YakColorNeutral();
  YakColorGray get gray => const YakColorGray();
  YakColorDanger get danger => const YakColorDanger();
  YakColorSuccess get success => const YakColorSuccess();
  YakColorWarning get warning => const YakColorWarning();
  YakColorBlue get blue => const YakColorBlue();
}

class YakColorPrimary {
  const YakColorPrimary();

  Color get primary25 => const Color(0xFFFFFDF5);
  Color get primary50 => const Color(0xFFFFFAE8);
  Color get primary100 => const Color(0xFFFFF1B8);
  Color get primary200 => const Color(0xFFFFEA95);
  Color get primary300 => const Color(0xFFFFE065);
  Color get primary400 => const Color(0xFFFFDA47);
  Color get primary500 => const Color(0xFFFFD119);
  Color get primary600 => const Color(0xFFE8BE17);
  Color get primary700 => const Color(0xFFB59412);
  Color get primary800 => const Color(0xFF8C730E);
  Color get primary900 => const Color(0xFF6B580B);
}

class YakColorBase {
  const YakColorBase();

  Color get white => const Color(0xFFFFFFFF);
  Color get black => const Color(0xFF000000);
}

class YakColorNeutral {
  const YakColorNeutral();

  Color get neutral25 => const Color(0xFFFCFCFD);
  Color get neutral50 => const Color(0xFFFAFBFC);
  Color get neutral100 => const Color(0xFFF8F9FB);
  Color get neutral200 => const Color(0xFFF9F9F9);
  Color get neutral300 => const Color(0xFFF7F7F8);
  Color get neutral400 => const Color(0xFFF5F5F5);
  Color get neutral500 => const Color(0xFFEFEFF1);
  Color get neutral600 => const Color(0xFFEAEBF0);
  Color get neutral700 => const Color(0xFFE5E5E7);
  Color get neutral800 => const Color(0xFFC1C3C7);
  Color get neutral900 => const Color(0xFFA1A4AC);
}

class YakColorGray {
  const YakColorGray();

  Color get gray25 => const Color(0xFFC4C6D0);
  Color get gray50 => const Color(0xFFC9CACE);
  Color get gray100 => const Color(0xFFBEBFC2);
  Color get gray200 => const Color(0xFFA2A3A8);
  Color get gray300 => const Color(0xFF787A80);
  Color get gray400 => const Color(0xFF5D6067);
  Color get gray500 => const Color(0xFF353841);
  Color get gray600 => const Color(0xFF30333B);
  Color get gray700 => const Color(0xFF26282E);
  Color get gray800 => const Color(0xFF1D1F24);
  Color get gray900 => const Color(0xFF16181B);
}

class YakColorDanger {
  const YakColorDanger();

  Color get danger25 => const Color(0xFFFFF7F6);
  Color get danger50 => const Color(0xFFFFECEB);
  Color get danger100 => const Color(0xFFFFC5C1);
  Color get danger200 => const Color(0xFFFFA9A3);
  Color get danger300 => const Color(0xFFFF827A);
  Color get danger400 => const Color(0xFFFF6A60);
  Color get danger500 => const Color(0xFFFF4538);
  Color get danger600 => const Color(0xFFE83F33);
  Color get danger700 => const Color(0xFFB53128);
  Color get danger800 => const Color(0xFF8C261F);
  Color get danger900 => const Color(0xFF6B1D18);
}

class YakColorSuccess {
  const YakColorSuccess();

  Color get success25 => const Color(0xFFF6FFFB);
  Color get success50 => const Color(0xFFEBFBF4);
  Color get success100 => const Color(0xFFC2F3DC);
  Color get success200 => const Color(0xFFA4EDCB);
  Color get success300 => const Color(0xFF7BE5B3);
  Color get success400 => const Color(0xFF61E0A5);
  Color get success500 => const Color(0xFF3AD88E);
  Color get success600 => const Color(0xFF35C581);
  Color get success700 => const Color(0xFF299965);
  Color get success800 => const Color(0xFF20774E);
  Color get success900 => const Color(0xFF185B3C);
}

class YakColorWarning {
  const YakColorWarning();

  Color get warning25 => const Color(0xFFFFF9F1);
  Color get warning50 => const Color(0xFFFEF5E7);
  Color get warning100 => const Color(0xFFFDE1B4);
  Color get warning200 => const Color(0xFFFCD290);
  Color get warning300 => const Color(0xFFFBBD5E);
  Color get warning400 => const Color(0xFFFAB13E);
  Color get warning500 => const Color(0xFFF99D0E);
  Color get warning600 => const Color(0xFFE38F0D);
  Color get warning700 => const Color(0xFFB16F0A);
  Color get warning800 => const Color(0xFF895608);
  Color get warning900 => const Color(0xFF694206);
}

class YakColorBlue {
  const YakColorBlue();

  Color get blue25 => const Color(0xFFF3FAFF);
  Color get blue50 => const Color(0xFFE6F4FF);
  Color get blue100 => const Color(0xFFB0DCFF);
  Color get blue200 => const Color(0xFF8ACBFF);
  Color get blue300 => const Color(0xFF54B3FF);
  Color get blue400 => const Color(0xFF33A4FF);
  Color get blue500 => const Color(0xFF008DFF);
  Color get blue600 => const Color(0xFF0080E8);
  Color get blue700 => const Color(0xFF0064B5);
  Color get blue800 => const Color(0xFF004E8C);
  Color get blue900 => const Color(0xFF003B6B);
}

/// Semantic colors for backgrounds, text/icons, and strokes
class YakColorSemantic {
  const YakColorSemantic();

  YakColorSemanticBackground get background => const YakColorSemanticBackground();
  YakColorSemanticTextAndIcons get textAndIcons =>
      const YakColorSemanticTextAndIcons();
  YakColorSemanticStroke get stroke => const YakColorSemanticStroke();
}

class YakColorSemanticBackground {
  const YakColorSemanticBackground();

  Color get baseMain => YakColor.primitive.base.white;
  Color get baseSecond => YakColor.primitive.neutral.neutral100;
  Color get primaryMain => YakColor.primitive.primary.primary500;
  Color get primarySecond => YakColor.primitive.primary.primary50;
  Color get primaryThird => YakColor.primitive.primary.primary25;
  Color get successMain => YakColor.primitive.success.success500;
  Color get successSecond => YakColor.primitive.success.success50;
  Color get dangerMain => YakColor.primitive.danger.danger500;
  Color get dangerSecond => YakColor.primitive.danger.danger50;
  Color get warningMain => YakColor.primitive.warning.warning500;
  Color get warningSecond => YakColor.primitive.warning.warning50;
  Color get blueMain => YakColor.primitive.blue.blue500;
  Color get blueSecond => YakColor.primitive.blue.blue50;
  Color get disabled => YakColor.primitive.neutral.neutral700;
  Color get baseDarkMain => YakColor.primitive.gray.gray900;
  Color get baseDarkSecond => YakColor.primitive.gray.gray800;
}

class YakColorSemanticTextAndIcons {
  const YakColorSemanticTextAndIcons();

  Color get baseMain => YakColor.primitive.gray.gray700;
  Color get baseSecond => YakColor.primitive.gray.gray200;
  Color get onColor => YakColor.primitive.base.white;
  Color get disabled => YakColor.primitive.neutral.neutral800;
  Color get primary => YakColor.primitive.primary.primary600;
  Color get success => YakColor.primitive.success.success600;
  Color get danger => YakColor.primitive.danger.danger600;
  Color get warning => YakColor.primitive.warning.warning600;
  Color get blue => YakColor.primitive.blue.blue600;
}

class YakColorSemanticStroke {
  const YakColorSemanticStroke();

  Color get base => YakColor.primitive.neutral.neutral700;
  Color get baseDark => YakColor.primitive.gray.gray700;
  Color get primary => YakColor.primitive.primary.primary600;
  Color get success => YakColor.primitive.success.success600;
  Color get danger => YakColor.primitive.danger.danger600;
  Color get warning => YakColor.primitive.warning.warning600;
  Color get blue => YakColor.primitive.blue.blue600;
}
