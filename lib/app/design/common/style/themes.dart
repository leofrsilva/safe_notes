import 'color_palettes.dart';
import 'package:flutter/material.dart';

class Themes {
  static bool isDark(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode;
  }

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'JosefinSans',
    // colorScheme: lightColorScheme,
    //
    backgroundColor: ColorPalettes.lightBG,
    primaryColor: ColorPalettes.lightPrimary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorPalettes.lightAccent,
    ),
    dividerColor: ColorPalettes.darkBG,
    scaffoldBackgroundColor: ColorPalettes.lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: ColorPalettes.lightBG,
      iconTheme: IconThemeData(
        color: ColorPalettes.lightPrimary,
      ),
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: ColorPalettes.lightPrimary,
      ),
    ),
    iconTheme: IconThemeData(color: ColorPalettes.secondy),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorPalettes.lightPrimary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'JosefinSans',
    // colorScheme: darkColorScheme,
    brightness: Brightness.dark,
    primaryColor: ColorPalettes.darkPrimary,
    // dividerColor: ColorPalettes.lightPrimary,
    // textSelectionTheme: TextSelectionThemeData(
    //   cursorColor: ColorPalettes.darkAccent,
    // ),
    scaffoldBackgroundColor: ColorPalettes.darkBG,
    backgroundColor: ColorPalettes.darkBG,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: ColorPalettes.darkBG,
      iconTheme: IconThemeData(
        color: ColorPalettes.white,
      ),
      toolbarTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: ColorPalettes.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorPalettes.lightPrimary,
    ),
    // iconTheme: IconThemeData(color: ColorPalettes.secondy),
  );
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF00639C),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFCCE5FF),
  onPrimaryContainer: Color(0xFF001D33),
  secondary: Color(0xFF006A60),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF43FBE8),
  onSecondaryContainer: Color(0xFF00201C),
  tertiary: Color(0xFF006684),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFBAE9FF),
  onTertiaryContainer: Color(0xFF001F2A),
  error: Color(0xFFB3261E),
  errorContainer: Color(0xFFF9DEDC),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410E0B),
  background: Color(0xFFFDFBFF),
  onBackground: Color(0xFF1B1B1E),
  surface: Color(0xFFFDFBFF),
  onSurface: Color(0xFF1B1B1E),
  surfaceVariant: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79747E),
  onInverseSurface: Color(0xFFF2F0F4),
  inverseSurface: Color(0xFF303033),
  inversePrimary: Color(0xFF94CCFF),
  shadow: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF94CCFF),
  onPrimary: Color(0xFF003354),
  primaryContainer: Color(0xFF004A77),
  onPrimaryContainer: Color(0xFFCCE5FF),
  secondary: Color(0xFF00DECC),
  onSecondary: Color(0xFF003731),
  secondaryContainer: Color(0xFF005048),
  onSecondaryContainer: Color(0xFF43FBE8),
  tertiary: Color(0xFF62D3FF),
  onTertiary: Color(0xFF003546),
  tertiaryContainer: Color(0xFF004D64),
  onTertiaryContainer: Color(0xFFBAE9FF),
  error: Color(0xFFF2B8B5),
  errorContainer: Color(0xFF8C1D18),
  onError: Color(0xFF601410),
  onErrorContainer: Color(0xFFF9DEDC),
  background: Color(0xFF1B1B1E),
  onBackground: Color(0xFFE4E2E6),
  surface: Color(0xFF1B1B1E),
  onSurface: Color(0xFFE4E2E6),
  surfaceVariant: Color(0xFF49454F),
  onSurfaceVariant: Color(0xFFCAC4D0),
  outline: Color(0xFF938F99),
  onInverseSurface: Color(0xFF1B1B1E),
  inverseSurface: Color(0xFFE4E2E6),
  inversePrimary: Color(0xFF00639C),
  shadow: Color(0xFF000000),
);
