import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///This [PlexScrollBehaviour] will help use touch, mouse and trackpad device gestures to work
class PlexScrollBehavior extends MaterialScrollBehavior {

  const PlexScrollBehavior({this.showScrollbar = true, this.scrollPhysics});

  final bool showScrollbar;
  final ScrollPhysics? scrollPhysics;

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return !showScrollbar ? child : super.buildScrollbar(context, child, details);
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return scrollPhysics != null ? scrollPhysics! : super.getScrollPhysics(context);
  }
}

