library plex_package;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex_package/plex_db.dart';
import 'package:plex_package/plex_route.dart';
import 'package:plex_package/plex_screens/plex_login_screen.dart';
import 'package:plex_package/plex_scrollview.dart';
import 'package:plex_package/plex_theme.dart';
import 'package:plex_package/plex_user.dart';
import 'package:plex_package/plex_utils/plex_dimensions.dart';

class PlexApp extends StatefulWidget {
  final Widget appLogo;
  final String title;
  final String _initialRoute;
  final List<PlexRoute> _routes;
  final PlexRoute? _unknownRoute;

  //Authorization
  final bool _useAuthorization;
  final Future<PlexUser?> Function(String email, String password)? _onLogin;

  static late PlexApp app;

  PlexApp({
    super.key,
    required this.appLogo,
    required this.title,
    required String initialRoute,
    required List<PlexRoute> routes,
    PlexRoute? unknownRoute,
    bool useAuthorization = false,
    Future<PlexUser?> Function(String, String)? onLogin,
  })
      : _onLogin = onLogin,
        _useAuthorization = useAuthorization,
        _unknownRoute = unknownRoute,
        _routes = routes,
        _initialRoute = initialRoute {
    if (_routes.isEmpty) {
      throw Exception("\"Routes\" can't be empty");
    }

    if (!_routes.any((e) => e.route == _initialRoute)) {
      throw Exception("\"Routes\" doesn't contain \"initialRoute\"");
    }

    if (_useAuthorization && _onLogin == null) {
      throw Exception("\"onLogin\" should be unimplemented");
    }
    app = this;
  }

  @override
  State<PlexApp> createState() => _PlexAppState();
}

class _PlexAppState extends State<PlexApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    Future(
          () async {
        await WidgetsFlutterBinding.ensureInitialized();
        await PlexDb.instance.initialize();
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          _initialized = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Theme(
        data: customTheme,
        child: MaterialApp(
          title: widget.title,
          debugShowCheckedModeBanner: false,
          scrollBehavior: PlexScrollBehavior(),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(Dim.medium),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: widget.appLogo,
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("Loading Components..."),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Theme(
      data: customTheme,
      child: GetMaterialApp(
        title: widget.title,
        debugShowCheckedModeBanner: false,
        scrollBehavior: PlexScrollBehavior(),
        initialRoute: widget._useAuthorization ? "Login" : widget._initialRoute,
        unknownRoute: widget._unknownRoute != null ? GetPage(name: widget._unknownRoute!.route, page: () => widget._unknownRoute!.screen) : null,
        routes: {
          if (widget._useAuthorization) ...{
            "Login": (_) => PlexLoginScreen(onLogin: widget._onLogin!, logo: widget.appLogo, nextRoute: widget._initialRoute),
          },
          for (var appRoute in widget._routes) ...{
            appRoute.route: (_) => appRoute.screen,
          }
        },
      ),
    );
  }
}
