import 'package:flutter/foundation.dart';

console(String message, {bool printInRelease = false}) {
  if (kDebugMode || printInRelease) {
    // ignore: avoid_print
    print("Console: \t\t\t\t$message");
  }
}

doWork<T>(T Function() callBack) => callBack();

T createWidget<T>(T Function() callBack) => callBack.call();

dynamic delay(dynamic Function() callBack, {int delayMillis = 500}) async => (await Future.delayed(Duration(milliseconds: delayMillis), callBack));

dynamic runAsync(dynamic Function() callBack) async => (await Future(() => callBack.call()));
