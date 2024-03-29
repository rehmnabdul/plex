import 'package:flutter/foundation.dart';

console(String message, {bool printInRelease = false}) {
  if (kDebugMode || printInRelease) {
    // ignore: avoid_print
    print("Console: \t\t\t\t$message");
  }
}

T createWidget<T>(T Function() callBack) {
  return callBack.call();
}

dynamic delay(dynamic Function() callBack, {int delayMillis = 500}) async {
  return (await Future.delayed(Duration(milliseconds: delayMillis), callBack));
}

dynamic runAsync(dynamic Function() callBack) async {
  return (await Future(
    () => callBack.call(),
  ));
}
