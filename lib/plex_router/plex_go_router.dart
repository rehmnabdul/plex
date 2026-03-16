import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:plex/plex_router/plex_router.dart';

/// GoRouter-based implementation of [PlexRouter]. Supports deep linking and web URL sync.
class PlexGoRouter implements PlexRouter {
  PlexGoRouter();

  GoRouter? _goRouter;

  GoRouter _getRouter(PlexRouterConfig config) {
    _goRouter ??= _createGoRouter(config);
    return _goRouter!;
  }

  GoRouter _createGoRouter(PlexRouterConfig config) {
    final pathOverrides = config.pathOverrides ?? {};
    final routes = <RouteBase>[];

    for (final entry in config.routes.entries) {
      final path = pathOverrides[entry.key] ?? entry.key;
      routes.add(
        GoRoute(
          path: path.startsWith('/') ? path : '/$path',
          name: entry.key,
          builder: (context, state) => entry.value(context),
        ),
      );
    }

    if (config.initialRoute != '/') {
      routes.add(
        GoRoute(
          path: '/',
          redirect: (_, __) => config.initialRoute,
        ),
      );
    }

    return GoRouter(
      initialLocation: config.initialRoute,
      routes: routes,
      errorBuilder: (context, state) => config.unknownRouteBuilder(context),
    );
  }

  @override
  Widget buildApp(PlexRouterConfig config) {
    final router = _getRouter(config);
    return MaterialApp.router(
      title: config.title,
      theme: config.theme,
      darkTheme: config.darkTheme,
      themeMode: config.themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: config.scrollBehavior,
      routerConfig: router,
    );
  }

  @override
  Future<T?>? to<T>(dynamic widget, {dynamic arguments}) {
    throw UnsupportedError(
      'PlexGoRouter does not support Plex.to(widget). Use Plex.toNamed(path) instead.',
    );
  }

  @override
  Future<T?>? toNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    final location = _buildLocation(path, parameters);
    _goRouter?.push(location);
    return null;
  }

  @override
  Future<T?>? offAndToNamed<T>(
    String path, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    final location = _buildLocation(path, parameters);
    _goRouter?.go(location);
    return null;
  }

  @override
  void back({dynamic result}) {
    _goRouter?.pop(result);
  }

  String _buildLocation(String path, Map<String, String>? parameters) {
    if (parameters == null || parameters.isEmpty) return path;
    final query = parameters.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    return path.contains('?') ? '$path&$query' : '$path?$query';
  }
}
