import 'color_palettes.dart';
import 'package:flutter/material.dart';

class Themes {
  static bool isDark(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode;
  }

  static ThemeData get lightTheme {
    return _theme(Brightness.light, colorSchemeLight);
  }

  static ThemeData get darkTheme {
    return _theme(Brightness.dark, colorSchemeDark);
  }

  static ThemeData _theme(Brightness brightness, ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      fontFamily: 'JosefinSans',
      //
      // cardColor: ColorPalettes.white,
      drawerTheme: DrawerThemeData(
        backgroundColor: brightness == Brightness.light
            ? colorScheme.secondary
            : colorScheme.onSecondary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: colorScheme.onBackground,
        ),
      ),
      // iconTheme: IconThemeData(color: ColorPalettes.secondy),
    );
  }
}
