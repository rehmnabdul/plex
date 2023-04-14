
import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexDb {

  static final LOGGED_IN_USER = "LOGGED_IN_USER";

  SharedPreferences? _prefs;

  initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static PlexDb instance = PlexDb._();

  PlexDb._();

  String? getString(String key) {
    return _prefs!.getString(key);
  }

  setString(String key, String value) async {
    return _prefs!.setString(key, value);
  }


}
