import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:plex/plex_sp.dart';

disablePlexAnimations(){
  PlexSp.instance.setBool("plex_animations", false);
}

enablePlexAnimations(){
  PlexSp.instance.setBool("plex_animations", true);
}

isPlexAnimationsEnable(){
  if(!PlexSp.instance.hasKey('plex_animations')) return true;
  return PlexSp.instance.getBool("plex_animations");
}

extension WidgetsUtils on Widget {
  Widget scaleAnim({int durationMillis = 500}) => isPlexAnimationsEnable() ? animate().scale(duration: Duration(milliseconds: durationMillis)) : this;
}
