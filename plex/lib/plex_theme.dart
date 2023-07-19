

import 'package:plex/plex_db.dart';

///This class will hold theme related information
class PlexTheme {

  PlexTheme._();

  ///Check theme is Material 3 or not
  static bool isMaterial3() {
    return PlexDb.instance.getBool("UseMaterial3") ?? true;
  }

  ///Set theme to material 3
  static void setMaterial3(bool value) {
    PlexDb.instance.setBool("UseMaterial3", value);
  }

  ///Check theme is dark or light
  static bool isDarkMode() {
    return PlexDb.instance.getBool("UseDarkMode") ?? false;
  }

  ///Set theme to dark
  static void setDarkMode(bool value) {
    PlexDb.instance.setBool("UseDarkMode", value);
  }
}