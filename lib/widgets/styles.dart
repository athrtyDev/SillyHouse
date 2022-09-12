import 'package:flutter/material.dart';

class Styles {
  Styles._();
  static const Color baseColor1 = const Color(0xFFFFBE0B);
  static const Color baseColor2 = const Color(0xFFFB5607);
  static const Color baseColor3 = const Color(0xFFFF006E);
  static const Color baseColor4 = const Color(0xFF8338EC);
  static const Color baseColor5 = const Color(0xFF3A86FF);
  static const Color secondaryColor = const Color(0xff7ed2ff);
  static const Color textColor = const Color(0xFF355070);
  static Color textColor70 = textColor.withOpacity(0.7);
  static Color textColor50 = textColor.withOpacity(0.5);
  static Color textColor10 = textColor.withOpacity(0.10);
  static Color textColor05 = textColor.withOpacity(0.05);
  static const Color greenColor = const Color(0xFF8AC926);
  static const Color secondaryTextColor = const Color(0xFFB2B2B2);
  static const Color backgroundColor = const Color(0xFFF0F3F5);
  static const Color whiteColor = const Color(0xFFFFFFFF);
  static Color whiteColor70 = whiteColor.withOpacity(0.7);

  // gradient
  static Gradient baseGradient = LinearGradient(
    colors: [
      baseColor1,
      const Color(0xFF703ade),
    ],
    stops: [0.0, 1.0],
  );

  // FontWeight
  static const FontWeight wNormal = FontWeight.w300;
  static const FontWeight wSemiBold = FontWeight.w600;
  static const FontWeight wBold = FontWeight.w700;

  // FontSize
  // only use it with Responsive flutter
  static const double xlarge = 17;
  static const double large = 15;
  static const double medium = 13;
  static const double small = 11;
}
