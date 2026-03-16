import 'package:plex/plex_router/plex_getx_router.dart';
import 'package:plex/plex_router/plex_router.dart';

class Plex {
  Plex._();

  static PlexRouter _router = PlexGetXRouter();

  /// Configure the router. Called by PlexApp on init.
  static void configure(PlexRouter router) {
    _router = router;
  }

  static Future<T?>? to<T>(
    dynamic to, {
    dynamic arguments,
  }) {
    return _router.to<T>(to, arguments: arguments);
  }

  static Future<T?>? toNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return _router.toNamed<T>(path, arguments: arguments, parameters: parameters);
  }

  static Future<T?>? offAndToNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return _router.offAndToNamed<T>(path, arguments: arguments, parameters: parameters);
  }

  static void back({dynamic result}) {
    _router.back(result: result);
  }
}
