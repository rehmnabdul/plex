import 'package:flutter/material.dart';

const primaryColor = Colors.blue;
const backgroundColor = Color(0xFFD9E5F8);
const accentColor = Color(0xFFFF6A26);

const customTextTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
  displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  bodyLarge: TextStyle(fontSize: 16.0),
  bodyMedium: TextStyle(fontSize: 14.0),
);

final customTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    }),
    backgroundColor: backgroundColor,
    accentColor: accentColor,
  ),
  textTheme: customTextTheme,
);
