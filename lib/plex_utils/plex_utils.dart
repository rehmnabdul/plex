import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PlexPlatform { web, android, iOS, fuchsia, linux, macOS, windows, unknown }

PlexPlatform getPlatform() {
  if (kIsWeb) {
    return PlexPlatform.web;
  } else {
    if (Platform.isAndroid) {
      return PlexPlatform.android;
    } else if (Platform.isIOS) {
      return PlexPlatform.iOS;
    } else if (Platform.isFuchsia) {
      return PlexPlatform.fuchsia;
    } else if (Platform.isLinux) {
      return PlexPlatform.linux;
    } else if (Platform.isMacOS) {
      return PlexPlatform.macOS;
    } else if (Platform.isWindows) {
      return PlexPlatform.windows;
    } else {
      return PlexPlatform.unknown;
    }
  }
}


double get _widthRatio {
  return WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width / WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
}

isLargeScreen(BuildContext context) {
  // return _widthRatio >= 900;
  return MediaQuery.of(context).size.width >= 900;
}

isMediumScreen(BuildContext context) {
  // return _widthRatio >= 600 && _widthRatio < 900;
  return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;
}

isSmallScreen(BuildContext context) {
  // return _widthRatio < 600;
  return MediaQuery.of(context).size.width < 600;
}
