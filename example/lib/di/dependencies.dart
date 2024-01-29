import 'package:flutter/material.dart';
import 'package:plex/plex_annotations/plex_annotations.dart';
import 'package:plex_app/screens/home_screen.dart';

class MyDependencies {
  late MyUser myUser;

  MyDependencies() {
    debugPrint(myUser.toString());
  }
}
