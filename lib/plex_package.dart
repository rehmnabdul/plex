// ignore_for_file: must_be_immutable, use_build_context_synchronously

library plex;

import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_scrollview.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_pair.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_utils/plex_widgets.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_card.dart';
import 'package:plex/plex_widgets/plex_navigation_rail.dart';
import 'package:toastification/toastification.dart';

part 'plex_screens/plex_dashboard_screen.dart';

class PlexNotification {
  int? notificationId;
  String title;
  String details;
  Icon? leadingIcon;
  int? notificationType;

  PlexNotification(
    this.title,
    this.details, {
    this.notificationId,
    this.leadingIcon,
    this.notificationType,
  });
}

class PlexAppInfo {
  PlexAppInfo({
    required this.title,
    required this.appLogo,
    required this.initialRoute,
    this.legalese,
    this.appLogoDark,
    this.versionCode,
    this.versionName,
    this.aboutDialogWidgets,
  });

  ///This [title] will be appear as Application Name
  final String title;
  final String? legalese;

  ///These [aboutDialogWidgets] will be displayed on about dialog
  ///Note: It will only work when [versionName] is available
  ///You can view this on [PlexDashboardScreen] appbar actions list
  final List<Widget>? aboutDialogWidgets;

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

  ///[forceMaterial3] will force app theme to use material3
  final bool forceMaterial3;

  ///[scrollBehaviour] will force app to use provided scroll behaviour
  final PlexScrollBehavior? scrollBehaviour;

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

  Function(bool isLoading)? _loadingDelegate;
  bool Function()? _isLoadingDelegate;

  ///Notifications List for Plex Application
  var _notifications = List<PlexNotification>.empty();
  Function()? _notificationDelegate;

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
    this.forceMaterial3 = false,
    this.scrollBehaviour,
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

    if (PlexTheme.appTheme == null && themeFromColor.value != const Color(0xFF007AD7).value && themeFromImage != null) {
      throw Exception("Use either \"themeFromColor\" or \"themeFromImage\"");
    }

    app = this;
  }

  @override
  State<PlexApp> createState() {
    return _PlexAppState();
  }

  //Public Methods and Variables
  ///Get AppLogo Based on Brightness Mode of Theme
  Widget getLogo(BuildContext context) {
    return (PlexTheme.isDarkMode(context) ? appInfo.appLogoDark : appInfo.appLogo) ?? appInfo.appLogo;
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

  ///Logout the user and move user to the sign-in screen
  logout() {
    PlexSp.instance.setString(PlexSp.loggedInUser, null);
    Plex.offAndToNamed(PlexRoutesPaths.loginPath);
    onLogout?.call();
  }

  ///Check Dashboard Screen Is Loading if Available and Visible
  bool isDashboardLoading() => _isLoadingDelegate?.call() ?? false;

  ///Show loading on Dashboard Screen If Available and Visible
  showDashboardLoading() {
    _loadingDelegate?.call(true);
  }

  ///Hide loading on Dashboard Screen If Available and Visible
  hideDashboardLoading() {
    _loadingDelegate?.call(false);
  }

  void showAboutDialogue(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: SizedBox(width: 50, height: 50, child: PlexApp.app.getLogo(context)),
      applicationName: PlexApp.app.appInfo.title,
      applicationVersion: PlexApp.app.appInfo.versionName,
      routeSettings: const RouteSettings(name: "/about"),
      applicationLegalese: PlexApp.app.appInfo.legalese,
      children: PlexApp.app.appInfo.aboutDialogWidgets,
    );
  }

  void updateDashboardUIAlert(Widget? widget) {
    dashboardConfig?.dashboardAlertUiController.setValue(widget);
  }

  void setNotifications(List<PlexNotification> notifications) {
    _notifications = notifications;
    _notificationDelegate?.call();
  }

  List<PlexNotification> getNotifications() {
    return _notifications;
  }

  String getInitialPath() {
    if (useAuthorization) {
      return getUser()?.getInitialPath() ?? appInfo.initialRoute;
    }
    return appInfo.initialRoute;
  }
}

class _PlexAppState extends State<PlexApp> {
  bool _initialized = false;
  bool useMaterial3 = false;
  var themeMode = ThemeMode.light;

  ///This method will use bool to switch between light and dark mode
  void handleBrightnessChange(ThemeMode themeMode) {
    setState(() {
      this.themeMode = themeMode;
      PlexTheme.setBrightnessMode(themeMode);
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
    initializePlex();
  }

  void initializePlex() {
    Future(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await PlexSp.instance.initialize();
        if (widget.themeFromImage != null) {
          widget.imageColorScheme = await ColorScheme.fromImageProvider(provider: widget.themeFromImage!);
        }
        useMaterial3 = widget.forceMaterial3 ? widget.forceMaterial3 : PlexTheme.isMaterial3();
        if (widget.forceMaterial3) PlexTheme.setMaterial3(true);
        themeMode = PlexTheme.isDarkMode(context) ? ThemeMode.dark : ThemeMode.light;
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
      return ToastificationWrapper(
        child: MaterialApp(
          title: widget.appInfo.title,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(PlexDim.medium),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: widget.appInfo.appLogo,
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("Loading Components..."),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ToastificationWrapper(
      child: GetMaterialApp(
        title: widget.appInfo.title,
        theme: PlexTheme.getThemeByBrightness(Brightness.light),
        darkTheme: PlexTheme.getThemeByBrightness(Brightness.dark),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        scrollBehavior: widget.scrollBehaviour ?? PlexScrollBehavior(),
        enableLog: false,
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
          if (widget.useAuthorization) ...{
            PlexRoutesPaths.loginPath: (_) => PlexLoginScreen(loginConfig: widget.loginConfig!, nextRoute: widget.appInfo.initialRoute),
          },
          if (widget.dashboardConfig != null) ...{
            PlexRoutesPaths.homePath: (_) => PlexDashboardScreen(handleBrightnessChange, handleMaterialVersionChange),
          },
          if (widget.dashboardConfig?.dashboardScreens.where((r) => r.external).isNotEmpty ?? false) ...{
            for (var page in widget.dashboardConfig!.dashboardScreens.where((r) => r.external)) ...{
              page.route: (_) => page.screen.call(context),
            }
          },
          if (widget.pages?.isNotEmpty == true) ...{
            for (var page in widget.pages!) ...{
              page.route: (_) => page.screen.call(context),
            },
          },
        },
      ),
    );
  }
}
