import 'package:flutter/material.dart';
import 'package:sixpack30/Text/font.dart';

/// Figma: ekran başlıkları (Hedef & Odak, Vücut, Vücudunuzu Bilin)
/// width: 194, height: 24
/// font-family: Montserrat, font-weight: 600, font-size: 20px
/// line-height: 100%, letter-spacing: 0px, color: #100F0F
/// Figma: ekran başlıkları altındaki sorular (Cinsiyetiniz nedir? vb.)
/// width: 343, height: 22
/// font-family: Montserrat, font-weight: 700, font-size: 18px
/// line-height: 100%, letter-spacing: 0px, color: #000000
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle screenHeader = TextStyle(
    fontFamily: AppFont.montserrat,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.0,
    letterSpacing: 0,
    color: Color(0xFF100F0F),
  );

  static const TextStyle questionTitle = TextStyle(
    fontFamily: AppFont.montserrat,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.0,
    letterSpacing: 0,
    color: Color(0xFF000000),
  );
}
