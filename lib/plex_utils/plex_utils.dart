import 'dart:io';

import 'package:flutter/foundation.dart';

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
