import 'dart:convert';

import 'package:plex/plex_sp.dart';

///This [PlexUser] will be use hold login user data all over the application
abstract class PlexUser {
  String getLoggedInUsername();

  String getLoggedInEmail();

  String getLoggedInFullName();

  String getInitials() {
    List<String> names = getLoggedInFullName().split(' ');
    String initials = '';
    for (String name in names) {
      if (name.isNotEmpty) {
        initials += name[0];
      }
    }
    return initials.toUpperCase();
  }

  List<String>? getLoggedInRules();

  Map<String, dynamic> toJson();

  save() {
    PlexSp.instance.setString(PlexSp.loggedInUser, jsonEncode(toJson()));
  }
}
