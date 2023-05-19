import 'package:flutter/cupertino.dart';

class Dim {
  static const zero = 0.0;
  static const half = 0.5;
  static const mini = 2.0;
  static const smallest = 4.0;
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 32.0;
  static const extraLarge = 64.0;

  static const fontSmall = 12.0;
  static const fontMedium = 14.0;
  static const fontLarge = 16.0;
  static const fontExtraLarge = 25.0;
}

spaceSmall() => const SizedBox(height: Dim.small, width: Dim.small);

spaceMedium() => const SizedBox(height: Dim.medium, width: Dim.medium);
