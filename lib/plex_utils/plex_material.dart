import 'package:flutter/material.dart';

const double narrowScreenWidthThreshold = 450;
const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;
const double transitionLength = 500;

extension ColorUtils on Color {
  getColorState() => MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return withOpacity(0.5);
          }
          return this;
        },
      );
}

extension TextStyleUtils on TextStyle {
  MaterialStateProperty<TextStyle> getState() => MaterialStateProperty.resolveWith<TextStyle>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return copyWith(color: Colors.grey);
          }
          return this;
        },
      );
}
