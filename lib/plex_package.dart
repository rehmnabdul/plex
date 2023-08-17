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
  ///This color will be used to generate app theme
  final Color themeFromColor;
  var imageColorScheme = const ColorScheme.light();

  ///This image will be used to generate app theme
  final ImageProvider? themeFromImage;

  ///This [appLogo] widget will be show as Application Logo
  final Widget appLogo;

  ///This [appLogoDark] widget will be show as Application Logo in Dark mode
  final Widget? appLogoDark;

  ///This [title] will be show ass Application title
  final String title;

  ///This [initialRoute] will be treated as initial route for screen Application
  final String initialRoute;

  ///This [pages] list will contains all the pages routes information for Application
  final List<PlexRoute>? pages;

  ///This [unknownRoute] will contains [Error404] or [NotFound] screen for Application
  final PlexRoute? unknownRoute;

  //Authorization
  ///Use this [trigger] to enable authorization in the applicaiton
  final bool useAuthorization;
  final bool useDashboard;

  ///If [useAuthorization] is enable set the required inputs by initializing loginConfig
  final PlexLoginConfig? loginConfig;
  final PlexDashboardConfig? dashboardConfig;

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
    this.appLogoDark,
    required this.title,
    required this.initialRoute,
    this.useDashboard = false,
    this.dashboardConfig,
    this.pages,
    this.themeFromColor = const Color(0xFF007AD7),
    this.themeFromImage,
    this.unknownRoute,
    this.useAuthorization = false,
    this.customDrawerHeader,
    this.generateDrawerNavigationButton,
    this.loginConfig,
  }) {
    if (dashboardConfig == null && pages == null) {
      throw Exception("Either \"DashboardConfig\" or \"Pages\" must not be null and empty");
    }

    if (dashboardConfig?.dashboardScreens.isEmpty == true && pages == null) {
      throw Exception("\"DashboardConfig.DashboardScreens\" can't be empty");
    }

    if (pages?.isEmpty == true && dashboardConfig == null) {
      throw Exception("\"Routes\" can't be empty");
    }

    if (dashboardConfig!.dashboardScreens!.firstWhereOrNull((e) => e.route == initialRoute) == null && pages == null) {
      throw Exception("\"DashboardConfig.DashboardScreens\" doesn't contain \"initialRoute\"");
    }

    if (pages!.firstWhereOrNull((e) => e.route == initialRoute) == null && dashboardConfig == null) {
      throw Exception("\"Pages\" doesn't contain \"initialRoute\"");
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
  ///Get AppLogo Based on Brightness Mode of Theme
  Widget getLogo() {
    return (PlexTheme.isDarkMode() ? appLogoDark : appLogo) ?? appLogo;
  }

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

  @override
  void initState() {
    super.initState();
    Future(
          () async {
        WidgetsFlutterBinding.ensureInitialized();
        await PlexDb.instance.initialize();
        if (widget.themeFromImage != null) {
          widget.imageColorScheme = await ColorScheme.fromImageProvider(provider: widget.themeFromImage!);
        }
        useMaterial3 = PlexTheme.isMaterial3();
        themeMode = PlexTheme.isDarkMode() ? ThemeMode.dark : ThemeMode.light;
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
        debugShowCheckedModeBanner: false,
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
      theme: PlexTheme.getThemeByBrightness(Brightness.light),
      darkTheme: PlexTheme.getThemeByBrightness(Brightness.dark),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: PlexScrollBehavior(),
      initialRoute: widget.useAuthorization ? PlexRoutesPaths.loginPath : widget.dashboardConfig != null ? PlexRoutesPaths.homePath : widget.initialRoute,
      unknownRoute: GetPage(
        name: widget.unknownRoute?.route ?? "/NotFound",
        page: () => widget.unknownRoute?.screen.call(context) ?? const Center(child: Text("Page not found: 404")),
      ),
      routes: {
        if (widget.useAuthorization) ...{
          PlexRoutesPaths.loginPath: (_) => PlexLoginScreen(loginConfig: widget.loginConfig!, nextRoute: widget.initialRoute),
        },
        if (widget.dashboardConfig != null) ...{
          PlexRoutesPaths.homePath: (_) => PlexDashboardScreen(handleBrightnessChange, handleMaterialVersionChange),
        },
        if (widget.pages?.isNotEmpty == true) ...{
          for (var page in widget.pages!) ...{
            page.route: (_) => page.screen.call(context),
          },
        },
      },
    );
  }
}
