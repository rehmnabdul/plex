part of '../plex_package.dart';

class PlexDashboardConfig {
  PlexDashboardConfig({
    this.appbarActions,
    required this.dashboardScreens,
    this.disableExpandNavigationRail = false,
    this.disableNavigationRail = false,
    this.disableBottomNavigation = false,
    this.showAnimationSwitch = true,
    this.showThemeSwitch = true,
    this.showBrightnessSwitch = true,
    this.showMaterialSwitch = true,
    this.navigationRailBackgroundColor,
    this.hideNavigationRailLogo = false,
    this.hideNavigationRailLogoWidth = double.maxFinite,
    this.hideNavigationRailLogoHeight = 100,
    this.hideNavigationRailVersionInfo = false,
    this.navigationRailTopWidgets,
    this.navigationRailBottomWidgets,
  });

  ///Hide and Show Theme Options from the Actions List
  final bool showAnimationSwitch;
  final bool showThemeSwitch;
  final bool showBrightnessSwitch;
  final bool showMaterialSwitch;

  ///This [dashboardScreens] list will contains all the routes information for Application
  final List<PlexRoute> dashboardScreens;

  ///This [disableExpandNavigationRail] will disable Left NavigationRail from Expanding
  final bool disableExpandNavigationRail;

  ///This [disableNavigationRail] will disable Left NavigationRail from Screen
  ///Left Drawer Still Visible
  final bool disableNavigationRail;

  ///This [disableBottomNavigation] will disable Bottom Navigation from Screen
  ///Left Drawer Still visible
  final bool disableBottomNavigation;

  ///This [appbarActions] will be available on top right submenu link
  final List<MenuItemButton> Function(PlexState<PlexScreen> state, BuildContext context)? appbarActions;

  final Color? navigationRailBackgroundColor;
  final bool hideNavigationRailLogo;
  final double hideNavigationRailLogoWidth;
  final double hideNavigationRailLogoHeight;
  final bool hideNavigationRailVersionInfo;
  final List<Widget> Function(PlexState<PlexScreen> state, BuildContext context)? navigationRailTopWidgets;
  final List<Widget> Function(PlexState<PlexScreen> state, BuildContext context)? navigationRailBottomWidgets;

  ///Navigate to other screen present in Dashboard Screen
  void navigateOnDashboard(int index) {
    if (index < 0 || index >= dashboardScreens.length) {
      throw Exception("Invalid Screen Index");
    }
    onNavigation?.call(index);
  }

  Function(int index)? onNavigation;
}

class PlexDashboardScreen extends PlexScreen {
  const PlexDashboardScreen(this.handleBrightnessChange, this.handleMaterialVersionChange, {super.key});

  final Function(ThemeMode mode) handleBrightnessChange;
  final Function() handleMaterialVersionChange;

  @override
  PlexState<PlexDashboardScreen> createState() => _PlexDashboardScreenState();
}

class _PlexDashboardScreenState extends PlexState<PlexDashboardScreen> {
  final int maxBottomNavDestinations = 4;
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

    PlexApp.app._loadingDelegate = (isLoading) {
      isLoading ? showLoading() : hideLoading();
    };
    PlexApp.app._isLoadingDelegate = () => isLoading();
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
      var index = routes.indexWhere((element) => element.route == PlexApp.app.appInfo.initialRoute);
      navigationSelectedIndex = index == -1 ? 0 : index;
    }

    PlexApp.app.dashboardConfig?.onNavigation = (index) {
      setState(() {
        navigationSelectedIndex = index;
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    PlexApp.app._loadingDelegate = null;
    PlexApp.app._isLoadingDelegate = null;
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
          if (largeScreen) ...{
            Center(child: Text(PlexApp.app.getUser()?.getLoggedInFullName().toUpperCase() ?? "N/A")),
            spaceSmall(),
          },
          Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Tooltip(
                message: PlexApp.app.getUser()?.getLoggedInFullName().toString() ?? "N/A",
                child: Container(
                  decoration: BoxDecoration(
                    color: PlexTheme.getActiveTheme(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: PlexApp.app.getUser()?.getPictureUrl() != null
                      ? CachedNetworkImage(
                          imageUrl: PlexApp.app.getUser()!.getPictureUrl()!,
                          progressIndicatorBuilder: (context, url, downloadProgress) {
                            debugPrint(downloadProgress.progress.toString());
                            return Stack(
                              children: [
                                Center(
                                  child: Text(
                                    PlexApp.app.getUser()?.getInitials().toString() ?? "N/A",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.yellowAccent,
                                    value: downloadProgress.totalSize == null ? null : downloadProgress.downloaded / downloadProgress.totalSize!,
                                  ),
                                )
                              ],
                            );
                          },
                          errorWidget: (context, url, error) => Center(
                            child: Text(
                              PlexApp.app.getUser()?.getInitials().toString() ?? "N/A",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            PlexApp.app.getUser()?.getInitials().toString() ?? "N/A",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
        MenuAnchor(
          menuChildren: [
            if (PlexApp.app.dashboardConfig!.showAnimationSwitch) ...{
              SubmenuButton(
                leadingIcon: const Icon(Icons.animation),
                menuChildren: [
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.animation),
                    onPressed: () {},
                    trailingIcon: Switch(
                        value: isPlexAnimationsEnable(),
                        onChanged: (bool value) {
                          value ? enablePlexAnimations() : disablePlexAnimations();
                          setState(() {});
                        }),
                    child: Text(isPlexAnimationsEnable() ? 'Disable' : 'Enable'),
                  )
                ],
                child: const Text("Animations"),
              ),
            },
            if (PlexApp.app.dashboardConfig!.showThemeSwitch && (PlexApp.app.dashboardConfig!.showMaterialSwitch || PlexApp.app.dashboardConfig!.showBrightnessSwitch)) ...{
              SubmenuButton(
                menuChildren: <Widget>[
                  if (PlexApp.app.dashboardConfig!.showMaterialSwitch) ...{
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
                  },
                  if (PlexApp.app.dashboardConfig!.showBrightnessSwitch) ...{
                    MenuItemButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          useSafeArea: true,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Select Brightness Mode"),
                              actions: [
                                TextButton.icon(
                                  onPressed: () {
                                    widget.handleBrightnessChange(ThemeMode.system);
                                  },
                                  icon: const Icon(Icons.brightness_4),
                                  label: Row(
                                    children: [
                                      const Text("System Specified"),
                                      if (PlexTheme.getBrightnessMode() == ThemeMode.system) ...{
                                        Expanded(child: Container()),
                                        const Icon(Icons.check_circle, color: Colors.green),
                                      }
                                    ],
                                  ),
                                ),
                                TextButton.icon(
                                    onPressed: () {
                                      widget.handleBrightnessChange(ThemeMode.dark);
                                    },
                                    icon: const Icon(Icons.dark_mode),
                                    label: Row(
                                      children: [
                                        const Text("Dark Mode"),
                                        if (PlexTheme.getBrightnessMode() == ThemeMode.dark) ...{
                                          Expanded(child: Container()),
                                          const Icon(Icons.check_circle, color: Colors.green),
                                        }
                                      ],
                                    )),
                                TextButton.icon(
                                  onPressed: () {
                                    widget.handleBrightnessChange(ThemeMode.light);
                                  },
                                  icon: const Icon(Icons.light_mode),
                                  label: Row(
                                    children: [
                                      const Text("Light Mode"),
                                      if (PlexTheme.getBrightnessMode() == ThemeMode.light) ...{
                                        Expanded(child: Container()),
                                        const Icon(Icons.check_circle, color: Colors.green),
                                      }
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      leadingIcon: const Icon(Icons.brightness_4),
                      child: const Text("Brightness Mode"),
                    ),
                  },
                ],
                leadingIcon: const Icon(Icons.color_lens_outlined),
                child: const Text('Theme'),
              ),
            },
            ...?PlexApp.app.dashboardConfig!.appbarActions?.call(this, context),
            if (PlexApp.app.useAuthorization) ...[
              MenuItemButton(
                onPressed: () {
                  PlexApp.app.logout();
                },
                leadingIcon: const Icon(Icons.logout),
                child: const Text("Logout"),
              )
            ],
            if (PlexApp.app.appInfo.versionName != null) ...[
              MenuItemButton(
                leadingIcon: const Icon(Icons.code),
                onPressed: () {
                  PlexApp.app.showAboutDialogue(context);
                },
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
          PlexApp.app.customDrawerHeader!.call(),
        } else ...{
          Container(
            color: PlexTheme.getActiveTheme(context).secondaryHeaderColor,
            child: Padding(
              padding: const EdgeInsets.all(Dim.large),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: PlexApp.app.getLogo(context),
                  ),
                  if (PlexApp.app.appInfo.versionName != null) ...[
                    Text("Version: ${PlexApp.app.appInfo.versionName}"),
                  ],
                ],
              ),
            ),
          )
        },
        spaceMedium(),
        ..._createSideNavigationButtons(),
      ],
    );
  }

  @override
  Widget? buildBottomNavigation() {
    if (PlexApp.app.dashboardConfig!.disableBottomNavigation) return null;
    if (!smallScreen || (routes.length) <= 1) return null;
    return NavigationBar(
      selectedIndex: navigationSelectedIndex > maxBottomNavDestinations ? maxBottomNavDestinations : navigationSelectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      animationDuration: const Duration(milliseconds: 500),
      onDestinationSelected: (int index) {
        setState(() {
          navigationSelectedIndex = index;
        });
      },
      destinations: [
        if (routes.length > maxBottomNavDestinations) ...{
          ...routes.sublist(0, maxBottomNavDestinations).map((destination) => NavigationDestination(
                label: destination.shortTitle ?? destination.title,
                icon: destination.logo ?? const Icon(Icons.circle),
                selectedIcon: destination.logo,
                tooltip: destination.title,
              )),
          MenuAnchor(
            menuChildren: [
              ...routes.sublist(maxBottomNavDestinations).map(
                    (e) => MenuItemButton(
                      onPressed: () {
                        setState(() {
                          navigationSelectedIndex = routes.indexWhere((i) => i.route == e.route);
                        });
                      },
                      leadingIcon: e.logo ?? const Icon(Icons.logout),
                      child: Text(e.shortTitle ?? e.title),
                    ),
                  ),
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
                icon: const Icon(Icons.more),
              );
            },
          ),
        } else ...{
          ...routes.map((destination) => NavigationDestination(
                label: destination.shortTitle ?? destination.title,
                icon: destination.logo ?? const Icon(Icons.circle),
                selectedIcon: destination.logo,
                tooltip: destination.title,
              )),
        }
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
        if (!PlexApp.app.dashboardConfig!.disableNavigationRail) ...{
          if (!smallScreen && (routes.length) > 1) ...{
            Padding(
              padding: const EdgeInsets.all(Dim.small),
              child: Card(
                color: PlexApp.app.dashboardConfig!.navigationRailBackgroundColor ?? PlexTheme.getActiveTheme(context).navigationRailTheme.backgroundColor,
                clipBehavior: Clip.hardEdge,
                elevation: Dim.small,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: NavigationRail(
                            useIndicator: true,
                            extended: !PlexApp.app.dashboardConfig!.disableExpandNavigationRail && largeScreen,
                            backgroundColor: Colors.transparent,
                            selectedIconTheme: PlexTheme.getActiveTheme(context).iconTheme.copyWith(size: 25),
                            unselectedIconTheme: PlexTheme.getActiveTheme(context).iconTheme.copyWith(size: 15),
                            selectedLabelTextStyle: (PlexTheme.getActiveTheme(context).navigationRailTheme.selectedLabelTextStyle ??
                                    TextStyle(
                                      color: PlexTheme.isDarkMode(context) ? Colors.white : Colors.black,
                                    ))
                                .copyWith(fontWeight: FontWeight.bold),
                            indicatorShape: null,
                            leading: SizedBox(
                              width: !PlexApp.app.dashboardConfig!.disableExpandNavigationRail && largeScreen ? 200 : 50,
                              child: Column(
                                children: [
                                  spaceSmall(),
                                  if (!PlexApp.app.dashboardConfig!.hideNavigationRailLogo) ...{
                                    SizedBox(
                                      height: PlexApp.app.dashboardConfig!.hideNavigationRailLogoHeight,
                                      width: PlexApp.app.dashboardConfig!.hideNavigationRailLogoWidth,
                                      child: PlexApp.app.getLogo(context),
                                    ),
                                    spaceSmall(),
                                  },
                                  if (!PlexApp.app.dashboardConfig!.hideNavigationRailVersionInfo && PlexApp.app.appInfo.versionName != null) ...[
                                    Text("${PlexApp.app.appInfo.versionName}"),
                                    spaceSmall(),
                                  ],
                                  ...?PlexApp.app.dashboardConfig!.navigationRailTopWidgets?.call(this, context),
                                  spaceSmall(),
                                ],
                              ),
                            ),
                            trailing: Column(
                              children: [
                                ...?PlexApp.app.dashboardConfig?.navigationRailBottomWidgets?.call(this, context),
                                spaceMedium(),
                              ],
                            ),
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
                                  icon: destination.logo ?? const Icon(Icons.circle_outlined),
                                  selectedIcon: destination.selectedLogo ?? destination.logo ?? const Icon(Icons.circle_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ).scaleAnim(),
            ),
          },
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
