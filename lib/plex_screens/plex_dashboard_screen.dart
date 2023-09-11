import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/utils.dart';

class PlexDashboardConfig {
  PlexDashboardConfig({required this.dashboardScreens});

  ///This [dashboardScreens] list will contains all the routes information for Application
  final List<PlexRoute> dashboardScreens;
}

class PlexDashboardScreen extends PlexScreen {
  const PlexDashboardScreen(this.handleBrightnessChange, this.handleMaterialVersionChange, {Key? key}) : super(key: key);

  final Function(bool useLightMode) handleBrightnessChange;
  final Function() handleMaterialVersionChange;

  @override
  PlexState<PlexDashboardScreen> createState() => _PlexDashboardScreenState();
}

class _PlexDashboardScreenState extends PlexState<PlexDashboardScreen> {
  var navigationSelectedIndex = -1;

  PlexUser? user;
  late List<PlexRoute> routes;

  @override
  void initState() {
    user = PlexApp.app.getUser();
    if (PlexApp.app.useAuthorization && user == null) {
      PlexApp.app.logout();
    }
    super.initState();

    routes = PlexApp.app.dashboardConfig?.dashboardScreens ?? List.empty(growable: true);
    routes = routes.where((element) {
      if (element.rule == null) return true;
      if (user == null) return true;
      if ((user!.getLoggedInRules() ?? List.empty()).isEmpty) return false;
      return user!.getLoggedInRules()!.contains(element.rule);
    }).toList();

    if (routes.isEmpty) {
      delay(() => PlexApp.app.logout());
    } else {
      navigationSelectedIndex = 0;
    }
  }

  @override
  AppBar? buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: navigationSelectedIndex == -1 ? Container() : Text(routes[navigationSelectedIndex].title),
      leading: (routes.isNotEmpty)
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                key.currentState?.openDrawer();
              })
          : null,
      actions: [
        if (PlexApp.app.useAuthorization) ...[
          Center(child: Text(PlexApp.app.getUser()?.getLoggedInFullName().toUpperCase() ?? "N/A")),
        ],
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
            if(PlexApp.app.appInfo.versionName != null) ...[
              MenuItemButton(
                leadingIcon: const Icon(Icons.code),
                onPressed: (){},
                child: Text("Version: ${PlexApp.app.appInfo.versionName}"),
              )
            ]
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
  Widget? buildSideNavigation() {
    return NavigationDrawer(
      selectedIndex: navigationSelectedIndex,
      onDestinationSelected: (value) {
        key.currentState?.closeDrawer();
        setState(() {
          navigationSelectedIndex = value;
        });
      },
      children: [
        if (PlexApp.app.customDrawerHeader != null) ...{
          PlexApp.app.customDrawerHeader!,
        } else ...{
          spaceMedium(),
        },
        ..._createSideNavigationButtons(),
      ],
    );
  }

  @override
  Widget? buildBottomNavigation() {
    if (!smallScreen || (routes.length) <= 1) return null;
    return NavigationBar(
      selectedIndex: navigationSelectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      animationDuration: const Duration(milliseconds: 500),
      onDestinationSelected: (int index) {
        setState(() {
          navigationSelectedIndex = index;
        });
      },
      destinations: [
        ...routes.map((destination) => NavigationDestination(
              label: destination.title,
              icon: destination.logo ?? const Icon(Icons.circle),
              selectedIcon: destination.logo,
              tooltip: destination.title,
            )),
      ],
    );
  }

  List<Widget> _createSideNavigationButtons() {
    var menus = List<Widget>.empty(growable: true);
    String? prevCategory;
    for (var e in routes) {
      if (prevCategory != e.category) {
        prevCategory = e.category;
        menus.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(prevCategory, style: Theme.of(context).textTheme.titleSmall),
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
    var body = Row(
      children: [
        if (!smallScreen && (routes.length) > 1) ...{
          Padding(
            padding: const EdgeInsets.all(Dim.small),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(Dim.medium), // Adjust the radius as per your preference
              ),
              clipBehavior: Clip.hardEdge,
              child: NavigationRail(
                extended: largeScreen,
                elevation: Dim.smallest,
                backgroundColor: PlexTheme.getActiveTheme().secondaryHeaderColor,
                leading: SizedBox(width: largeScreen ? 200 : 50, child: PlexApp.app.getLogo()),
                selectedIndex: navigationSelectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    navigationSelectedIndex = value;
                  });
                },
                destinations: [
                  ...routes.map(
                    (destination) => NavigationRailDestination(
                      label: Text(destination.title),
                      icon: destination.logo ?? const Icon(Icons.menu),
                      selectedIcon: destination.logo ?? const Icon(Icons.circle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        },
        if (navigationSelectedIndex != -1) ...{
          Expanded(child: routes[navigationSelectedIndex].screen.call(context)),
        }
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(Dim.medium),
      child: body,
    );
  }
}