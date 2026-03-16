import 'package:flutter/material.dart';

import 'package:plex/plex_router/plex_route_guard.dart';

///Plex route and side menu widget will use this clas instance to work properly
class PlexRoute {
  ///[route] will be use to move between screens
  String route;

  ///Parameterized path for GoRouter (e.g. "/orders/:id"). Ignored by [PlexGetXRouter].
  String? path;

  ///[title] will be use to display title od the screen in the app
  String title;
  String? shortTitle;

  ///[tag] will be used to show as a tag in navigation rail
  String? tag;
  String? tagDescription;
  Color? tagBgColor;
  Color? tagTextColor;

  ///This is the build method to build the screen user defined UI
  Widget Function(BuildContext context, {dynamic data}) screen;

  ///Optional [logo]
  Widget? logo;
  Widget? selectedLogo;

  ///Use this [category] to group the screen in drawer menu
  String category;

  ///Use this [rule] to group the screen in drawer menu
  String? rule;

  ///Use this [external] to navigate this screen on stack instead dashboard
  bool external;

  ///Optional guards. If [rule] is set and [guards] is empty, [PlexRoleGuard] is used automatically.
  final List<PlexRouteGuard> guards;

  ///Default constructor
  PlexRoute({
    required this.route,
    this.path,
    required this.title,
    required this.screen,
    this.external = false,
    this.logo,
    this.selectedLogo,
    this.category = "Menu",
    this.rule,
    this.shortTitle,
    this.tag,
    this.tagDescription,
    this.tagBgColor,
    this.tagTextColor,
    this.guards = const [],
  });
}
