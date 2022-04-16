import 'package:flutter/material.dart';

class ColorPalettes {
  //Colors for theme
  static Color secondy = const Color(0xFF28EDDA); // Color(0xFF16E7FF);
  static Color lightPrimary = const Color(0xFF289EED);
  static Color darkPrimary = const Color(0xFF0C4271); //Color(0xFF041C32);
  static Color lightAccent = const Color(0xFF289EED);
  static Color darkAccent = const Color(0xFF0C4271); //Color(0xFF041C32);
  static Color lightBG = const Color(0xFFF0F3FF);
  static Color darkBG = const Color(0xFF222831); //Color(0xff212121);

  static Color white = const Color(0xffffffff);
  static Color whiteSemiTransparent = const Color(0xFFF7F6FD);
  static Color grey = Colors.grey;
  static Color greyBg = const Color(0xfff0f0f0);
  static Color greyDark = const Color(0xFF333333);
  static Color red = Colors.red;
  static Color redLight = const Color(0xFFFF5E5E);
  static Color yellow = Colors.yellow;
  static Color green = Colors.green;
  static Color setActive = Colors.grey[500] ?? const Color(0xFF9E9E9E);
  static Color blueGrey = Colors.blueGrey;
  static Color black = const Color(0xFF000000);
  static Color black12 = Colors.black12;
  static Color transparent = const Color(0x00000000);

  // static Color getColorCircleProgress(double s) {
  //   var r = ColorPalettes.red;
  //   if (s > 4.5 && s < 7) {
  //     r = ColorPalettes.yellow;
  //   } else if (s >= 7) {
  //     r = ColorPalettes.green;
  //   }
  //   return r;
  // }
}
