import 'package:shared_preferences/shared_preferences.dart';

/// This class allow user to save and get persistent data
class PlexDb {
  static const loggedInUser = "LOGGED_IN_USER";

  SharedPreferences? _prefs;

  Future initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static PlexDb instance = PlexDb._();

  PlexDb._();

  ///Check weather the key exists or not
  bool hasKey(String key) {
    return _prefs!.containsKey(key);
  }

  ///Get the string value against a key
  String? getString(String key) {
    return _prefs!.getString(key);
  }

  ///Get the boolean value against a key
  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  ///Set the string value against a key
  setString(String key, String? value) {
    if(value == null) {
      return _prefs!.remove(key);
    }
    return _prefs!.setString(key, value);
  }

  ///Set the boolean value against a key
  setBool(String key, bool? value) {
    if(value == null) {
      return _prefs!.remove(key);
    }
    return _prefs!.setBool(key, value);
  }
}
