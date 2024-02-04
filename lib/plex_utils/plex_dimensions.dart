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
}

Widget space(double value) => SizedBox(width: value, height: value);

Widget spaceMini() => const SizedBox(width: Dim.mini, height: Dim.mini);

Widget spaceSmallest() =>
    const SizedBox(width: Dim.smallest, height: Dim.smallest);

Widget spaceSmall() => const SizedBox(width: Dim.small, height: Dim.small);

Widget spaceMedium() => const SizedBox(width: Dim.medium, height: Dim.medium);
