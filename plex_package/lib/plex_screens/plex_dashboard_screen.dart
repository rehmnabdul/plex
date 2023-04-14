import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex_package/plex_menu.dart';
import 'package:plex_package/plex_screens/plex_screen.dart';

class PlexDashboardScreen extends PlexScreen {
  const PlexDashboardScreen({Key? key, required this.title, this.menus = const []}) : super(key: key);

  final String title;
  final List<PlexMenu> menus;

  @override
  PlexState<PlexDashboardScreen> createState() => _PlexDashboardScreenState();
}

class _PlexDashboardScreenState extends PlexState<PlexDashboardScreen> {
  @override
  AppBar? buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(widget.title),
      leading: (widget.menus.isNotEmpty)
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            )
          : null,
    );
  }

  @override
  Widget? buildDrawer() {
    if(Get.size.aspectRatio >= 1) {
      print(Get.size.aspectRatio.toString());
      return null;
    }
    return super.buildDrawer();
  }

  @override
  Widget buildBody() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        child: Container(),
      ),
    );
  }
}
