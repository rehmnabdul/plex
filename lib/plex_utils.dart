import 'package:flutter/foundation.dart';
import 'package:plex/plex_utils/plex_logger.dart';

/// Legacy console helper. Prefer [PlexLogger] for new code.
void console(String message, {bool printInRelease = false}) {
  if (kDebugMode || printInRelease) {
    PlexLogger.d('Console', message);
  }
}

doWork<T>(T Function() callBack) => callBack();

T createWidget<T>(T Function() callBack) => callBack.call();

dynamic delay(dynamic Function() callBack, {int delayMillis = 500}) async => (await Future.delayed(Duration(milliseconds: delayMillis), callBack));

dynamic runAsync(dynamic Function() callBack) async => (await Future(() => callBack.call()));
