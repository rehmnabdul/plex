import 'package:shared_preferences/shared_preferences.dart';

/// This class allow user to save and get persistent data
class PlexSp {
  static const loggedInUser = "PLEX_LOGGED_IN_USER";

  SharedPreferences? _prefs;

  Future initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static PlexSp instance = PlexSp._();

  PlexSp._();

  ///Check weather the key exists or not
  bool hasKey(String key) {
    return _prefs!.containsKey(key);
  }

  ///Get the string value against a key
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  ///Get the boolean value against a key
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  ///Get the int value against a key
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  ///Get the List<String> value against a key
  List<String>? getList(String key) {
    return _prefs?.getStringList(key);
  }

  ///Set the string value against a key
  setString(String key, String? value) {
    if (value == null) {
      return _prefs!.remove(key);
    }
    return _prefs!.setString(key, value);
  }

  ///Set the boolean value against a key
  setBool(String key, bool? value) {
    if (value == null) {
      return _prefs!.remove(key);
    }
    return _prefs!.setBool(key, value);
  }

  ///Set the int value against a key
  setInt(String key, int? value) {
    if (value == null) {
      return _prefs!.remove(key);
    }
    return _prefs!.setInt(key, value);
  }

  ///Set the List<String> value against a key
  setList(String key, List<String>? value) {
    if (value == null) {
      return _prefs!.remove(key);
    }
    return _prefs!.setStringList(key, value);
  }
}
