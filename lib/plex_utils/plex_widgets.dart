import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plex/plex_sp.dart';

disablePlexAnimations() {
  PlexSp.instance.setBool("plex_animations", false);
}

enablePlexAnimations() {
  PlexSp.instance.setBool("plex_animations", true);
}

isPlexAnimationsEnable() {
  if (!PlexSp.instance.hasKey('plex_animations')) return true;
  return PlexSp.instance.getBool("plex_animations");
}

extension WidgetsUtils on Widget {
  Widget scaleAnim({int durationMillis = 500, bool repeat = false}) {
    return isPlexAnimationsEnable()
        ? animate(
            onPlay: (controller) {
              if (repeat) controller.repeat(reverse: true);
            },
          ).scale(duration: Duration(milliseconds: durationMillis))
        : this;
  }

  Widget scaleAnim2({int durationMillis = 500, bool repeat = false}) {
    return isPlexAnimationsEnable()
        ? animate(
            onPlay: (controller) {
              if (repeat) controller.repeat(reverse: true);
            },
          ).flip(duration: Duration(milliseconds: durationMillis))
        : this;
  }
}
