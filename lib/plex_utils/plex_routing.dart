import 'package:get/get.dart';

class Plex {
  Plex._();

  static Future<T?>? to<T>(
    dynamic to, {
    dynamic arguments,
  }) {
    return Get.to(to, arguments: arguments);
  }

  static Future<T?>? toNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return Get.toNamed<T>(path, arguments: arguments, parameters: parameters);
  }

  static Future<T?>? offAndToNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return Get.offAndToNamed<T>(path, arguments: arguments, parameters: parameters);
  }

  static void back({dynamic result}) {
    Get.back(result: result);
  }
}
