import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_utils/plex_material.dart';

///This class will hold theme related information
class PlexTheme {
  PlexTheme._();

  static const Color selectionColor = Color(0xFFACCEF7);

  static ThemeData? appTheme;
  static TextTheme? appTextTheme;

  ///Check theme is Material 3 or not
  static bool isMaterial3() {
    return PlexSp.instance.getBool("UseMaterial3") ?? true;
  }

  ///Set theme to material 3
  static void setMaterial3(bool value) {
    PlexSp.instance.setBool("UseMaterial3", value);
  }

  ///Check theme is dark or light
  static bool isDarkMode(BuildContext context) {
    var brightnessMode = getBrightnessMode();
    if (brightnessMode == ThemeMode.system) {
      brightnessMode =
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? ThemeMode.light
              : ThemeMode.dark;
    }
    return brightnessMode == ThemeMode.dark;
  }

  ///Check theme is brightness
  static ThemeMode getBrightnessMode() {
    var themeMode = PlexSp.instance.getInt("UseBrightnessMode") ?? 0;
    return themeMode == 0
        ? ThemeMode.system
        : themeMode == 1
            ? ThemeMode.light
            : ThemeMode.dark;
  }

  ///Set theme brightness
  static void setBrightnessMode(ThemeMode value) {
    PlexSp.instance.setInt(
        "UseBrightnessMode",
        value == ThemeMode.system
            ? 0
            : value == ThemeMode.light
                ? 1
                : 2);
  }

  ///Initial theme data for the app
  static ThemeData getActiveTheme(BuildContext context) => getThemeByBrightness(
      isDarkMode(context) ? Brightness.dark : Brightness.light);

  static TextTheme getTextTheme(BuildContext context) =>
      getActiveTheme(context).textTheme;

  static ThemeData getThemeByBrightness(Brightness brightness) {
    var colorSchemeSeed = brightness == Brightness.dark
        ? PlexApp.app.themeFromColor
        : PlexApp.app.themeFromImage == null
            ? PlexApp.app.themeFromColor
            : null;
    var colorScheme = brightness == Brightness.dark
        ? null
        : PlexApp.app.themeFromImage == null
            ? null
            : PlexApp.app.imageColorScheme;
    Color? textColor = Brightness.dark == brightness ? Colors.white : null;

    if (PlexTheme.appTheme != null) {
      return PlexTheme.appTheme!;
    }

    return ThemeData(
      colorSchemeSeed: colorSchemeSeed,
      colorScheme: colorScheme,
      useMaterial3: isMaterial3(),
      navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: const TextStyle(fontSize: 10).getState()),
      brightness: brightness,
      textTheme: PlexTheme.appTextTheme?.copyWith(
        displayLarge: TextStyle(color: textColor),
        displayMedium: TextStyle(color: textColor),
        displaySmall: TextStyle(color: textColor),
        headlineLarge: TextStyle(color: textColor),
        headlineMedium: TextStyle(color: textColor),
        headlineSmall: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
        titleMedium: TextStyle(color: textColor),
        titleSmall: TextStyle(color: textColor),
        labelLarge: TextStyle(color: textColor),
        labelMedium: TextStyle(color: textColor),
        labelSmall: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        bodyLarge: TextStyle(color: textColor),
        bodySmall: TextStyle(color: textColor),
      ),
    );
  }

  static Color randomColor() {
    var colorLimit = 225;
    return ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, Random().nextInt(colorLimit),
                Random().nextInt(colorLimit), Random().nextInt(colorLimit)))
        .primary;
  }
}
