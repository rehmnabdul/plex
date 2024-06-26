import 'dart:convert';

import 'package:plex/plex_sp.dart';

///This [PlexUser] will be use hold login user data all over the application
abstract mixin class PlexUser {

  String? getInitialPath() => null;

  String? getPictureUrl() => null;

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

class PlexDemoUser extends PlexUser {
  @override
  String getLoggedInEmail() {
    return "email@mail.com";
  }

  @override
  String getLoggedInFullName() {
    return "Demo User";
  }

  @override
  List<String>? getLoggedInRules() {
    return null;
  }

  @override
  String getLoggedInUsername() {
    return "username";
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, String>{};
  }
}
