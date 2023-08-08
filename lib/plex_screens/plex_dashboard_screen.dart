import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

class PlexDashboardScreen extends PlexScreen {
  const PlexDashboardScreen(this.handleBrightnessChange, this.handleMaterialVersionChange, {Key? key}) : super(key: key);

  final Function(bool useLightMode) handleBrightnessChange;
  final Function() handleMaterialVersionChange;

  @override
  PlexState<PlexDashboardScreen> createState() => _PlexDashboardScreenState();
}

class _PlexDashboardScreenState extends PlexState<PlexDashboardScreen> {
  var drawerSelectedIndex = 0;

  @override
  void initState() {
    if (PlexApp.app.useAuthorization && !PlexApp.app.isLogin()) {
      PlexApp.app.logout();
    }
    super.initState();
  }

  @override
  AppBar? buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(PlexApp.app.routes[drawerSelectedIndex].title),
      leading: (PlexApp.app.routes.isNotEmpty)
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                key.currentState?.openDrawer();
              },
            )
          : null,
      actions: [
        MenuAnchor(
          menuChildren: [
            SubmenuButton(
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {
                    widget.handleMaterialVersionChange();
                  },
                  leadingIcon: const Icon(Icons.layers_outlined),
                  trailingIcon: Switch(
                      value: PlexTheme.isMaterial3(),
                      onChanged: (bool value) {
                        widget.handleMaterialVersionChange();
                      }),
                  child: const Text("Material 3"),
                ),
                MenuItemButton(
                  onPressed: () {
                    widget.handleBrightnessChange(PlexTheme.isDarkMode());
                  },
                  leadingIcon: Icon(PlexTheme.isDarkMode() ? Icons.dark_mode : Icons.light_mode),
                  trailingIcon: Switch(
                      value: PlexTheme.isDarkMode(),
                      onChanged: (bool value) {
                        widget.handleBrightnessChange(value);
                      }),
                  child: const Text("Dark Mode"),
                ),
              ],
              leadingIcon: const Icon(Icons.color_lens_outlined),
              child: const Text('Theme'),
            ),
            if (PlexApp.app.useAuthorization) ...[
              MenuItemButton(
                onPressed: () {
                  PlexApp.app.logout();
                },
                leadingIcon: const Icon(Icons.logout),
                child: const Text("Logout"),
              )
            ],
          ],
          builder: (context, controller, child) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.more_vert),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget? buildDrawer() {
    if (Get.size.aspectRatio >= 1) {
      if (kDebugMode) {
        print(Get.size.aspectRatio.toString());
      }
      return null;
    }
    return NavigationDrawer(
      onDestinationSelected: (value) {
        key.currentState?.closeDrawer();
        setState(() {
          drawerSelectedIndex = value;
        });
      },
      selectedIndex: drawerSelectedIndex,
      children: [
        if (PlexApp.app.customDrawerHeader != null) ...{
          PlexApp.app.customDrawerHeader!,
        },
        ..._createDrawerButtons(),
      ],
    );
  }

  List<Widget> _createDrawerButtons() {
    var routes = PlexApp.app.routes;
    var menus = List<Widget>.empty(growable: true);

    String? prevCategory;
    for (var e in routes) {
      if (prevCategory != e.category) {
        prevCategory = e.category;
        menus.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              prevCategory ?? "",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        );
      }
      menus.add(PlexApp.app.generateDrawerNavigationButton?.call(e) ??
          NavigationDrawerDestination(
            icon: e.logo ?? Container(),
            label: Text(e.title),
          ));
    }
    if (menus.isNotEmpty && menus.first is Divider) {
      menus.removeAt(0);
    }
    return menus;
  }

  @override
  Widget buildBody() {
    var body = PlexApp.app.routes[drawerSelectedIndex].screen.call(PlexApp.app.scaffoldKey, context);
    if (!PlexTheme.isMaterial3()) {
      return body;
    }
    return Card(
      margin: EdgeInsets.zero,
      elevation: Dim.smallest,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(Dim.medium), topRight: Radius.circular(Dim.medium)),
      ),
      child: body,
    );
  }
}
