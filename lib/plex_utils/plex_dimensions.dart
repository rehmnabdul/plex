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

  /// 4px-grid steps that were missing from the original scale.
  /// Existing fields above keep their historic values.
  static const smallMedium = 12.0 + _adjustment;
  static const mediumPlus = 20.0 + _adjustment;
  static const largeMinus = 24.0 + _adjustment;
  static const largePlus = 40.0 + _adjustment;
  static const extraLargeMinus = 48.0 + _adjustment;
  static const huge = 80.0 + _adjustment;
  static const extraHuge = 96.0 + _adjustment;
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

  /// Additional type-scale steps. Existing fields above keep historic values.
  static const caption = 12.0 + _adjustment;
  static const body = 14.0 + _adjustment;
  static const bodyLarge = 16.0 + _adjustment;
  static const title = 20.0 + _adjustment;
  static const displaySmall = 30.0 + _adjustment;
  static const displayMedium = 38.0 + _adjustment;
  static const displayLarge = 48.0 + _adjustment;
  static const displayExtraLarge = 60.0 + _adjustment;
}

/// Corner radii (px).
class PlexRadius {
  PlexRadius._();
  static const xs = 4.0;
  static const sm = 6.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const xl = 16.0;
  static const xxl = 24.0;
  static const pill = 999.0;
}

/// Material elevation steps (dp).
class PlexElevation {
  PlexElevation._();
  static const xs = 1.0;
  static const sm = 2.0;
  static const md = 4.0;
  static const lg = 8.0;
  static const xl = 16.0;
}

/// Motion durations and easing.
class PlexMotion {
  PlexMotion._();
  static const durFast = Duration(milliseconds: 120);
  static const durNormal = Duration(milliseconds: 200);
  static const durSlow = Duration(milliseconds: 320);

  static const Curve easeStandard = Cubic(0.4, 0, 0.2, 1);
  static const Curve easeOut = Cubic(0.0, 0, 0.2, 1);
  static const Curve easeIn = Cubic(0.4, 0, 1, 1);
}

/// Layout constants. Rail *widgets* still use 90/260; 76/264 are optional tokens.
/// [PlexNavigationRail] reads [railCollapsed] / [railExpanded] so widget
/// defaults stay 90 / 260 and do not snap to [sidebarCollapsed] / [sidebarExpanded].
class PlexLayout {
  PlexLayout._();

  /// Optional collapsed sidebar token for later phases.
  static const sidebarCollapsed = 76.0;

  /// Optional expanded sidebar token for later phases.
  static const sidebarExpanded = 264.0;

  /// Current [PlexNavigationRail] collapsed width — do not change widget usage.
  static const railCollapsed = 90.0;

  /// Current [PlexNavigationRail] expanded width — do not change widget usage.
  static const railExpanded = 260.0;

  static const topbarHeight = 64.0;
  static const containerMax = 1320.0;
}

/// Stacking order tokens.
class PlexZIndex {
  PlexZIndex._();
  static const base = 1;
  static const sticky = 100;
  static const sidebar = 200;
  static const topbar = 300;
  static const dropdown = 800;
  static const overlay = 900;
  static const modal = 1000;
  static const toast = 1100;
}

Widget space(double value) => SizedBox(width: value, height: value);

Widget spaceMini() => const SizedBox(width: PlexDim.mini, height: PlexDim.mini);

Widget spaceSmallest() =>
    const SizedBox(width: PlexDim.smallest, height: PlexDim.smallest);

Widget spaceSmall() =>
    const SizedBox(width: PlexDim.small, height: PlexDim.small);

Widget spaceMedium() =>
    const SizedBox(width: PlexDim.medium, height: PlexDim.medium);
