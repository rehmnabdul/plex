import 'package:flutter/cupertino.dart';

class PlexDim {
  PlexDim._();
  static const _adjustment = 0;
  static const zero = 0.0 + _adjustment;
  static const half = 0.5 + _adjustment;
  static const mini = 2.0 + _adjustment;
  static const smallest = 4.0 + _adjustment;
  static const small = 8.0 + _adjustment;
  static const medium = 16.0 + _adjustment;
  static const large = 32.0 + _adjustment;
  static const extraLarge = 64.0 + _adjustment;
}

class PlexFontSize {
  PlexFontSize._();
  static const _adjustment = 0;
  static const smallest = 9.0 + _adjustment;
  static const small = 11.5 + _adjustment;
  static const normal = 13.5 + _adjustment;
  static const medium = 15.0 + _adjustment;
  static const large = 18.0 + _adjustment;
  static const extraLarge = 24.0 + _adjustment;
}

Widget space(double value) => SizedBox(width: value, height: value);

Widget spaceMini() => const SizedBox(width: PlexDim.mini, height: PlexDim.mini);

Widget spaceSmallest() =>
    const SizedBox(width: PlexDim.smallest, height: PlexDim.smallest);

Widget spaceSmall() => const SizedBox(width: PlexDim.small, height: PlexDim.small);

Widget spaceMedium() => const SizedBox(width: PlexDim.medium, height: PlexDim.medium);
