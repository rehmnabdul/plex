import 'package:flutter/material.dart';

/// Configuration passed to [PlexRouter.buildApp].
class PlexRouterConfig {
  const PlexRouterConfig({
    required this.title,
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
    required this.scrollBehavior,
    required this.initialRoute,
    required this.unknownRouteName,
    required this.unknownRouteBuilder,
    required this.routes,
    this.pathOverrides,
  });

  final String title;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final ScrollBehavior scrollBehavior;
  final String initialRoute;
  final String unknownRouteName;
  final Widget Function(BuildContext context) unknownRouteBuilder;
  final Map<String, WidgetBuilder> routes;

  /// For GoRouter: route name -> parameterized path (e.g. "/orders/:id").
  final Map<String, String>? pathOverrides;
}

/// Abstract router interface. Implementations wrap GetX, GoRouter, or other navigation backends.
abstract class PlexRouter {
  /// Builds the root app widget (e.g. GetMaterialApp or MaterialApp.router).
  Widget buildApp(PlexRouterConfig config);

  /// Push a widget onto the navigation stack.
  Future<T?>? to<T>(dynamic widget, {dynamic arguments});

  /// Navigate to a named route.
  Future<T?>? toNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  });

  /// Replace current route with a named route (e.g. login → home).
  Future<T?>? offAndToNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  });

  /// Pop the current route.
  void back({dynamic result});
}
