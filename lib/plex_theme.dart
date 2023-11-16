import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_utils/plex_material.dart';

///This class will hold theme related information
class PlexTheme {
  PlexTheme._();

  ///Check theme is Material 3 or not
  static bool isMaterial3() {
    return PlexSp.instance.getBool("UseMaterial3") ?? true;
  }

  ///Set theme to material 3
  static void setMaterial3(bool value) {
    PlexSp.instance.setBool("UseMaterial3", value);
  }

  ///Check theme is dark or light
  static bool isDarkMode() {
    return PlexSp.instance.getBool("UseDarkMode") ?? false;
  }

  ///Set theme to dark
  static void setDarkMode(bool value) {
    PlexSp.instance.setBool("UseDarkMode", value);
  }

  ///Initial theme data for the app
  static ThemeData getActiveTheme() => getThemeByBrightness(isDarkMode() ? Brightness.dark : Brightness.light);

  static TextTheme getTextTheme() => getActiveTheme().textTheme;

  static ThemeData getThemeByBrightness(Brightness brightness) {
    debugPrint("Brightness: ${brightness.name}, DarkMode: ${isDarkMode()}");

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
    return ThemeData(
        colorSchemeSeed: colorSchemeSeed,
        colorScheme: colorScheme,
        useMaterial3: isMaterial3(),
        navigationBarTheme: NavigationBarThemeData(labelTextStyle: const TextStyle(fontSize: 10).getState()),
        brightness: brightness);

    return ThemeData(
        colorSchemeSeed: isDarkMode()
            ? PlexApp.app.themeFromColor
            : PlexApp.app.themeFromImage == null
                ? PlexApp.app.themeFromColor
                : null,
        colorScheme: isDarkMode()
            ? null
            : PlexApp.app.themeFromImage == null
                ? null
                : PlexApp.app.imageColorScheme,
        useMaterial3: isMaterial3(),
        navigationBarTheme: NavigationBarThemeData(labelTextStyle: const TextStyle(fontSize: 10).getState()),
        brightness: brightness);
  }

  static Color randomColor() {
    var colorLimit = 225;
    return ColorScheme.fromSeed(seedColor: Color.fromARGB(255, Random().nextInt(colorLimit), Random().nextInt(colorLimit), Random().nextInt(colorLimit))).primary;
  }
}
