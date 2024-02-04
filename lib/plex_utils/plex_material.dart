import 'package:flutter/material.dart';

const double narrowScreenWidthThreshold = 450;
const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;
const double transitionLength = 500;

extension ColorUtils on Color {
  MaterialStateProperty<Color> getMaterialState() =>
      MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return withOpacity(0.5);
          }
          return this;
        },
      );

  MaterialColor getMaterialColor() {
    final int red = this.red;
    final int green = this.green;
    final int blue = this.blue;
    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(value, shades);
  }
}

extension DoubleUtils on double {
  getMaterialState() => MaterialStateProperty.resolveWith<double>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return 0;
          }
          return this;
        },
      );
}

extension TextStyleUtils on TextStyle {
  MaterialStateProperty<TextStyle> getState() =>
      MaterialStateProperty.resolveWith<TextStyle>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return copyWith(color: Colors.grey);
          }
          return this;
        },
      );
}
