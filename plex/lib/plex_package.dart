library plex;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_db.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_dashboard_screen.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_scrollview.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';

class PlexRoutesPaths {
  PlexRoutesPaths._();

  static const loginPath = "/Login";
  static const homePath = "/Home";
}

///PlexApp is the main app widget that will hold all your app
class PlexApp extends StatefulWidget {
  ///This is scaffold key to be used by widgets to access scaffold state
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ///This color will be used to generate app theme
  final Color themeFromColor;

  ///This image will be used to generate app theme
  final ImageProvider? themeFromImage;

  ///This [appLogo] widget will be show ass Application Logo
  final Widget appLogo;

  ///This [title] will be show ass Application title
  final String title;

  ///This [initialRoute] will be treated as initial route for screen Application
  final String initialRoute;

  ///This [routes] list will contains all the routes information for Application
  final List<PlexRoute> routes;

  ///This [unknownRoute] will contains [Error404] or [NotFound] screen for Application
  final PlexRoute? unknownRoute;

  //Authorization
  ///Use this [trigger] to enable authorization in the applicaiton
  final bool useAuthorization;

  ///If [useAuthorization] is enable set the required inputs by initializing loginConfig
  final PlexLoginConfig? loginConfig;

  //App Widgets
  ///Use this widget to create custom drawer header
  final Widget? customDrawerHeader;

  //Widget Callbacks
  ///Use this callback to create custom drawer navigation buttons
  ///- Don't override or handle the [onClick] event. It will be automatically handle by the [plex]".
  ///- To see the ripple effect [onTap] use Material Widgets like [Card] etc.
  final Widget Function(PlexRoute plexRoute)? generateDrawerNavigationButton;

  ///This is a the app instance to access public variable of app anywhere in the applicaiton.
  static late PlexApp app;

  PlexApp({
    super.key,
    required this.appLogo,
    required this.title,
    required this.initialRoute,
    required this.routes,
    this.themeFromColor = const Color(0xFF007AD7),
    this.themeFromImage,
    this.unknownRoute,
    this.useAuthorization = false,
    this.customDrawerHeader,
    this.generateDrawerNavigationButton,
    this.loginConfig,
  }) {
    if (routes.isEmpty) {
      throw Exception("\"Routes\" can't be empty");
    }

    if (!routes.any((e) => e.route == initialRoute)) {
      throw Exception("\"Routes\" doesn't contain \"initialRoute\"");
    }

    if (useAuthorization && loginConfig == null) {
      throw Exception("\"loginConfig\" should be unimplemented");
    }

    if (themeFromColor.value != const Color(0xFF007AD7).value && themeFromImage != null) {
      throw Exception("Use either \"themeFromColor\" or \"themeFromImage\"");
    }

    app = this;
  }

  @override
  State<PlexApp> createState() => _PlexAppState();

  //Public Methods and Variables

  ///Check the user is logged into the app or not
  isLogin() {
    return PlexDb.instance.hasKey(PlexDb.loggedInUser);
  }


  ///Logout the user and move user to the signin screen
  logout() {
    PlexDb.instance.setString(PlexDb.loggedInUser, null);
    Plex.offAndToNamed(PlexRoutesPaths.loginPath);
  }
}

class _PlexAppState extends State<PlexApp> {
  bool _initialized = false;
  bool useMaterial3 = false;
  var themeMode = ThemeMode.light;
  ColorScheme? imageColorScheme = const ColorScheme.light();

  ///This method will use bool to switch between light and dark mode
  void handleBrightnessChange(bool useDarkMode) {
    setState(() {
      PlexTheme.setDarkMode(useDarkMode);
      themeMode = useDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  ///This method will use to switch between Material 2 and Material 3
  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
      PlexTheme.setMaterial3(useMaterial3);
    });
  }

  ///Initial theme data for the app
  ThemeData _getTheme(Brightness brightness) => ThemeData(
        colorSchemeSeed: brightness == Brightness.dark
            ? widget.themeFromColor
            : widget.themeFromImage == null
                ? widget.themeFromColor
                : null,
        colorScheme: brightness == Brightness.dark
            ? null
            : widget.themeFromImage == null
                ? null
                : imageColorScheme,
        useMaterial3: useMaterial3,
        brightness: brightness,
      );

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await PlexDb.instance.initialize();
        if (widget.themeFromImage != null) {
          imageColorScheme = await ColorScheme.fromImageProvider(provider: widget.themeFromImage!);
        }
        useMaterial3 = PlexTheme.isMaterial3();
        themeMode = PlexTheme.isDarkMode() ? ThemeMode.dark : ThemeMode.light;
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _initialized = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        title: widget.title,
        theme: _getTheme(Brightness.light),
        darkTheme: _getTheme(Brightness.dark),
        themeMode: themeMode,
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
      );
    }
    return GetMaterialApp(
      title: widget.title,
      theme: _getTheme(Brightness.light),
      darkTheme: _getTheme(Brightness.dark),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: PlexScrollBehavior(),
      initialRoute: widget.useAuthorization ? PlexRoutesPaths.loginPath : widget.initialRoute,
      unknownRoute: widget.unknownRoute != null ? GetPage(name: widget.unknownRoute!.route, page: () => widget.unknownRoute!.screen.call(widget.scaffoldKey, context)) : null,
      routes: {
        if (widget.useAuthorization) ...{
          PlexRoutesPaths.loginPath: (_) => PlexLoginScreen(loginConfig: widget.loginConfig!, logo: widget.appLogo, nextRoute: widget.initialRoute),
        },
        PlexRoutesPaths.homePath: (_) => PlexDashboardScreen(handleBrightnessChange, handleMaterialVersionChange),
      },
    );
  }
}
