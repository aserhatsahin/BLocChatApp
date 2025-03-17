import 'package:flutter/material.dart';

class AppStyles {
  // **Padding Değerleri**
  static const double paddingSmall = 10.0;
  static const double paddingMedium = 20.0;
  static const double paddingLarge = 30.0;
  static const double paddingXLarge = 50.0;

  //HEIGHT DEGERLERI
  static const double heightSmall = 5.0;
  static const double heightMedium = 10.0;
  static const double heightLarge = 20.0;
  static const double heightXLarge = 50.0;

  // **Margin Değerleri**
  static const double marginSmall = 10.0;
  static const double marginMedium = 20.0;
  static const double marginLarge = 30.0;
  static const double marginXLarge = 50.0;

  // **Text Boyutları**
  static const double textSmall = 14.0;
  static const double textMedium = 18.0;
  static const double textLarge = 24.0;
  static const double textExtraLarge = 32.0;

  // **Radius ve Border Değerleri**
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusXLarge = 50.0;

  // **Gölgelendirme**
  static const BoxShadow boxShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 8,
    offset: Offset(2, 2),
  );

  // **Başlık Stilleri**
  static const TextStyle headline = TextStyle(fontSize: textLarge, fontWeight: FontWeight.bold);

  static const TextStyle bodyText = TextStyle(fontSize: textMedium);

  static const TextStyle smallText = TextStyle(fontSize: textSmall, color: Colors.grey);
}
