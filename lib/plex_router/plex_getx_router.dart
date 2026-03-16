import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:plex/plex_router/plex_router.dart';

/// GetX-based implementation of [PlexRouter]. Default router for PlexApp.
class PlexGetXRouter implements PlexRouter {
  @override
  Widget buildApp(PlexRouterConfig config) {
    return GetMaterialApp(
      title: config.title,
      theme: config.theme,
      darkTheme: config.darkTheme,
      themeMode: config.themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: config.scrollBehavior,
      enableLog: false,
      initialRoute: config.initialRoute,
      unknownRoute: GetPage(
        name: config.unknownRouteName,
        page: () => config.unknownRouteBuilder(Get.context!),
      ),
      routes: config.routes,
      localizationsDelegates: config.localizationsDelegates,
      supportedLocales: config.supportedLocales,
      builder: config.builder,
    );
  }

  @override
  Future<T?>? to<T>(dynamic widget, {dynamic arguments}) {
    return Get.to<T>(widget, arguments: arguments);
  }

  @override
  Future<T?>? toNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return Get.toNamed<T>(path, arguments: arguments, parameters: parameters);
  }

  @override
  Future<T?>? offAndToNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return Get.offAndToNamed<T>(path, arguments: arguments, parameters: parameters);
  }

  @override
  void back({dynamic result}) {
    Get.back(result: result);
  }
}
