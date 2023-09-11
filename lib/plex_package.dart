// ignore_for_file: must_be_immutable

library plex;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_dashboard_screen.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_scrollview.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';

class PlexAppInfo {
  PlexAppInfo({required this.title, required this.appLogo, required this.initialRoute, this.appLogoDark, this.versionCode, this.versionName});

  ///This [title] will be appear as Application Name
  final String title;

  ///This [initialRoute] will be treated as initial route for screen Application
  final String initialRoute;

  ///This [versionCode] will be use to display Application version info
  final int? versionCode;

  ///This [versionName] will be use to display Application version info
  final String? versionName;

  ///This [appLogo] widget will be show as Application Logo
  final Widget appLogo;

  ///This [appLogoDark] widget will be show as Application Logo in Dark mode
  final Widget? appLogoDark;
}

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

  ///This [appInfo] will be show ass Application title
  final PlexAppInfo appInfo;

  ///This [pages] list will contains all the pages routes information for Application
  final List<PlexRoute>? pages;

  ///This [unknownRoute] will contains [Error404] or [NotFound] screen for Application
  final PlexRoute? unknownRoute;

  //Authorization
  ///Use this [trigger] to enable authorization in the applicaiton
  final bool useAuthorization;

  ///If [useAuthorization] is enable set the required inputs by initializing loginConfig
  final PlexLoginConfig? loginConfig;
  final PlexDashboardConfig? dashboardConfig;

  //App Widgets
  ///Use this widget to create custom drawer header
  final Widget Function()? customDrawerHeader;

  //Widget Callbacks
  ///Use this callback to create custom drawer navigation buttons
  ///- Don't override or handle the [onClick] event. It will be automatically handle by the [plex]".
  ///- To see the ripple effect [onTap] use Material Widgets like [Card] etc.
  final Widget Function(PlexRoute plexRoute)? generateDrawerNavigationButton;

  ///When plex application is initialized this method will be called
  final Function()? onInitializationComplete;

  ///When plex user is logout this method will be called
  final Function()? onLogout;

  ///This is a the app instance to access public variable of app anywhere in the applicaiton.
  static late PlexApp app;

  PlexApp({
    super.key,
    required this.appInfo,
    this.dashboardConfig,
    this.pages,
    this.themeFromColor = const Color(0xFF007AD7),
    this.themeFromImage,
    this.unknownRoute,
    this.useAuthorization = false,
    this.customDrawerHeader,
    this.generateDrawerNavigationButton,
    this.loginConfig,
    this.onInitializationComplete,
    this.onLogout,
  }) {
    if (dashboardConfig == null && pages == null) {
      throw Exception("Either \"DashboardConfig\" or \"Pages\" must not be null and empty");
    }

    if (pages == null && dashboardConfig!.dashboardScreens.firstWhereOrNull((e) => e.route == appInfo.initialRoute) == null) {
      throw Exception("\"DashboardConfig.DashboardScreens\" doesn't contain initial route");
    }

    if (dashboardConfig == null && pages!.firstWhereOrNull((e) => appInfo.initialRoute == e.route) == null) {
      throw Exception("\"Pages\" doesn't contain initial route");
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
    return (PlexTheme.isDarkMode() ? appInfo.appLogoDark : appInfo.appLogo) ?? appInfo.appLogo;
  }

  ///Check the user is logged into the app or not
  PlexUser? getUser() {
    if (!PlexSp.instance.hasKey(PlexSp.loggedInUser)) return null;
    try {
      return loginConfig!.userFromJson(jsonDecode(PlexSp.instance.getString(PlexSp.loggedInUser)!));
    } catch (e) {
      logout();
    }
    return null;
  }

  void updateUser(PlexUser user) {
    if (!PlexSp.instance.hasKey(PlexSp.loggedInUser)) return;
    try {
      user.save();
    } catch (e) {
      logout();
    }
  }

  ///Logout the user and move user to the signin screen
  logout() {
    PlexSp.instance.setString(PlexSp.loggedInUser, null);
    Plex.offAndToNamed(PlexRoutesPaths.loginPath);
    onLogout?.call();
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
        await PlexSp.instance.initialize();
        if (widget.themeFromImage != null) {
          widget.imageColorScheme = await ColorScheme.fromImageProvider(provider: widget.themeFromImage!);
        }
        useMaterial3 = PlexTheme.isMaterial3();
        themeMode = PlexTheme.isDarkMode() ? ThemeMode.dark : ThemeMode.light;
        widget.onInitializationComplete?.call();
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
        title: widget.appInfo.title,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(Dim.medium),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: widget.appInfo.appLogo,
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
      title: widget.appInfo.title,
      theme: PlexTheme.getThemeByBrightness(Brightness.light),
      darkTheme: PlexTheme.getThemeByBrightness(Brightness.dark),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: PlexScrollBehavior(),
      initialRoute: widget.useAuthorization
          ? PlexRoutesPaths.loginPath
          : widget.dashboardConfig != null
              ? PlexRoutesPaths.homePath
              : widget.appInfo.initialRoute,
      unknownRoute: GetPage(
        name: widget.unknownRoute?.route ?? "/NotFound",
        page: () => widget.unknownRoute?.screen.call(context) ?? const Scaffold(body: Center(child: Text("Page not found: 404"))),
      ),
      routes: {
        "/": (_) => const Scaffold(body: Center(child: Text("Page not found: 404"))),
        if (widget.useAuthorization) ...{
          PlexRoutesPaths.loginPath: (_) => PlexLoginScreen(loginConfig: widget.loginConfig!, nextRoute: widget.appInfo.initialRoute),
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
