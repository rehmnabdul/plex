import 'package:flutter/material.dart';

///Plex route and side menu widget will use this clas instance to work properly
class PlexRoute {
  ///[route] will be use to move between screens
  String route;

  ///[title] will be use to display title od the screen in the app
  String title;
  String? shortTitle;

  ///This is the build method to build the screen user defined UI
  Widget Function(BuildContext context) screen;

  ///Optional [logo]
  Widget? logo;

  ///Use this [category] to group the screen in drawer menu
  String category;

  ///Use this [rule] to group the screen in drawer menu
  String? rule;

  ///Default constructor
  PlexRoute({required this.route, required this.title, required this.screen, this.logo, this.category = "Menu", this.rule, this.shortTitle});
}
