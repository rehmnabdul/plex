import 'package:flutter/material.dart';
import 'package:plex_app/images.dart';
import 'package:plex_app/screens/home_screen.dart';
import 'package:plex_package/plex_package.dart';
import 'package:plex_package/plex_route.dart';
import 'package:plex_package/plex_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    PlexApp(
      appLogo: Image.asset(imageHosiery),
      title: "Plex App",
      initialRoute: 'home',
      useAuthorization: true,
      onLogin: (email, pass) async {
        var user = PlexUser(<String, dynamic>{"Name": "Abdur Rahman"});
        return user;
      },
      routes: [
        PlexRoute("home", const HomeScreen()),
      ],
    ),
  );
}
