import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///This [PlexScrollBehaviour] will help use touch, mouse and trackpad device gestures to work
class PlexScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
