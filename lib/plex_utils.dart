import 'package:flutter/foundation.dart';

console(String message, {bool printInRelease = false}) {
  if (kDebugMode || printInRelease) {
    // ignore: avoid_print
    print("Console: \t\t\t\t$message");
  }
}

dynamic delay(dynamic Function() callBack) async {
  return (await Future.delayed(const Duration(milliseconds: 500), callBack));
}

dynamic runAsync(dynamic Function() callBack) async {
  return (await Future(
    () => callBack.call(),
  ));
}
