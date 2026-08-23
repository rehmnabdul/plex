import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plex/plex_database/plex_database.dart';
import 'package:plex/plex_database/plex_entity.dart';
import 'package:plex/plex_di/plex_dependency_injection.dart';
import 'package:plex/plex_networking/plex_networking.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex_app/screens/all_inputs_screen.dart';
import 'package:plex_app/screens/example_chrome.dart';
import 'package:plex_app/screens/example_routes.dart';
import 'package:plex_app/screens/home_overview_screen.dart';
import 'package:plex_app/screens/home_screen.dart';
import 'package:plex_app/screens/plex_data_grid_demo_screen.dart';
import 'package:plex_app/screens/plex_gantt_demo_screen.dart';
import 'package:plex_app/screens/plex_info_sheet_demo_screen.dart';
import 'package:plex_app/screens/plex_scanner_demo_screen.dart';
import 'package:plex_app/screens/second_screen.dart';
import 'package:plex_app/screens/table_demo_screens.dart';
import 'package:plex_app/screens/ui_kit_buttons_screen.dart';
import 'package:plex_app/screens/ui_kit_feedback_screen.dart';
import 'package:plex_app/screens/ui_kit_forms_screen.dart';
import 'package:plex_app/screens/ui_kit_dashboard_widgets_screen.dart';
import 'package:plex_app/screens/ui_kit_tabs_screen.dart';
import 'package:plex_app/screens/ui_kit_theme_screen.dart';

export 'package:plex_app/screens/example_routes.dart';

class AppUser extends PlexUser {
  late String email;
  late String userName;
  List<String>? rules;

  AppUser.init({required this.email, required this.userName, this.rules});

  @override
  String? getPictureUrl() {
    return "https://images.pexels.com/photos/631317/pexels-photo-631317.jpeg";
  }

  @override
  String getLoggedInEmail() => email;

  @override
  List<String>? getLoggedInRules() => rules;

  @override
  String getLoggedInUsername() => userName;

  @override
  String getLoggedInFullName() => userName;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userName'] = userName;
    map['email'] = email;
    map['rules'] = rules;
    return map;
  }

  @override
  String? getInitialPath() {
    return Routes.home;
  }

  AppUser.fromJson(Map<String, dynamic> map) {
    userName = map["userName"];
    email = map["email"];
    rules = map["rules"];
  }
}

class UserEntity implements PlexEntity {
  late String email;
  late String userName;
  List<String>? rules;

  UserEntity.init({required this.email, required this.userName, this.rules});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userName'] = userName;
    map['email'] = email;
    map['rules'] = rules;
    return map;
  }

  UserEntity.fromJson(Map<String, dynamic> map) {
    userName = map["userName"];
    email = map["email"];
    rules = map["rules"];
  }

  @override
  int? entityId;
}

initializeDb() async {
  final db = await PlexDb.initialize(PlexDbConfig("PlexTestDatabase.db"));
  db.getEntityCollection(
    "UsersEntities",
    toJson: (UserEntity e) => e.toJson(),
    fromJson: (m) => UserEntity.fromJson(m),
  );
}

void main() async {
  ///Dependency Injection
  injectSingleton(MyUser(
      "firstName", "lastName", 20, DateTime.now(), true, "object", [1, 2, 3]));

  initializeDb();

  runApp(PlexApp(
    themeFromColor: PlexTheme.defaultSeedColor,
    brandConfig: const PlexBrandConfig(
      density: PlexDensity.comfortable,
    ),
    appInfo: PlexAppInfo(
      title: "Plex Example",
      appLogo: Image.asset("assets/app.png"),
      appLogoDark: Image.asset("assets/app.png"),
      initialRoute: Routes.home,
      versionCode: 1,
      versionName: "v1.0.0",
    ),
    useAuthorization: true,
    onInitializationComplete: () async {
      PlexTheme.appTextTheme = GoogleFonts.outfitTextTheme();
      PlexNetworking.instance.allowBadCertificateForHTTPS();
    },
    loginConfig: PlexLoginConfig(
      layout: PlexLoginLayout.split,
      useBackground: false,
      brandHeadline: "Plex Example",
      brandSubtitle: "Enterprise UI kit for Flutter",
      formTitle: "Sign in",
      formHint: "Use User / Password. Debug builds also accept DebugUser.",
      debugUsername: 'DebugUser',
      debugPassword: 'DebugPassword',
      username: "User",
      password: "Password",
      passwordMaxLength: 15,
      additionalWidgetsTop: (context) => Text(
        "Slot: additionalWidgetsTop",
        style: TextStyle(
          color: PlexThemeData.of(context).colors.textMuted,
          fontSize: PlexFontSize.caption,
        ),
      ),
      additionalWidgetsAboveLoginButton: (context) => Text(
        "Slot: additionalWidgetsAboveLoginButton",
        style: TextStyle(
          color: PlexThemeData.of(context).colors.textMuted,
          fontSize: PlexFontSize.caption,
        ),
      ),
      additionalWidgetsBottom: (context) => Text(
        "Slot: additionalWidgetsBottom",
        style: TextStyle(
          color: PlexThemeData.of(context).colors.textMuted,
          fontSize: PlexFontSize.caption,
        ),
      ),
      onLogin: (context, email, password) async {
        return AppUser.init(userName: "Abdur Rahman", email: "ar@mail.com");
      },
      userFromJson: (userData) {
        return AppUser.fromJson(userData);
      },
    ),
    dashboardConfig: PlexDashboardConfig(
      useBackground: false,
      disableExpandNavigationRail: false,
      disableNavigationRail: false,
      disableBottomNavigation: false,
      showThemeSwitch: true,
      showBrightnessSwitch: true,
      navigationRailBottomWidgets: (state, context) => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: PlexDim.small),
          child: Text(
            "Example app",
            style: TextStyle(
              color: PlexThemeData.of(context).colors.textMuted,
              fontSize: PlexFontSize.caption,
            ),
          ),
        ),
      ],
      navigationRailTopWidgets: (state, context) => const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: PlexDim.small),
          child: PlexBadge(
            label: "UI revamp",
            tone: PlexBadgeTone.info,
            dot: true,
          ),
        ),
      ],
      hideNavigationRailVersionInfo: false,
      hideNavigationRailLogo: false,
      hideNavigationRailLogoHeight: 100,
      hideNavigationRailLogoWidth: 200,
      appbarActions: (state, context) => [
        MenuItemButton(
          leadingIcon: const Icon(Icons.downloading),
          child: const Text("Show Dashboard Loading"),
          onPressed: () {
            if (!PlexApp.app.isDashboardLoading()) {
              PlexApp.app.showDashboardLoading();
            }
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.clear),
          child: const Text("Hide Dashboard Loading"),
          onPressed: () {
            PlexApp.app.hideDashboardLoading();
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.account_balance_outlined),
          child: const Text("Balance"),
          onPressed: () {},
        ),
      ],
      dashboardScreens: [
        PlexRoute(
          route: Routes.home,
          category: "Overview",
          title: "Home",
          shortTitle: "Home",
          logo: const Icon(Icons.home_outlined),
          selectedLogo: const Icon(Icons.home),
          screen: (context, {data}) => const HomeOverviewScreen(),
        ),
        PlexRoute(
          route: Routes.uiTheme,
          category: "Design system",
          title: "Theme & brand",
          shortTitle: "Theme",
          tag: "0",
          logo: const Icon(Icons.palette_outlined),
          selectedLogo: const Icon(Icons.palette),
          screen: (context, {data}) => const UiKitThemeScreen(),
        ),
        PlexRoute(
          route: Routes.uiButtons,
          category: "Design system",
          title: "Buttons & identity",
          shortTitle: "Buttons",
          tag: "1",
          logo: const Icon(Icons.smart_button_outlined),
          selectedLogo: const Icon(Icons.smart_button),
          screen: (context, {data}) => const UiKitButtonsScreen(),
        ),
        PlexRoute(
          route: Routes.uiForms,
          category: "Design system",
          title: "Forms",
          shortTitle: "Forms",
          tag: "2",
          logo: const Icon(Icons.edit_note_outlined),
          selectedLogo: const Icon(Icons.edit_note),
          screen: (context, {data}) => const UiKitFormsScreen(),
        ),
        PlexRoute(
          route: Routes.uiFeedback,
          category: "Design system",
          title: "Cards & feedback",
          shortTitle: "Feedback",
          tag: "3",
          logo: const Icon(Icons.notifications_outlined),
          selectedLogo: const Icon(Icons.notifications),
          screen: (context, {data}) => const UiKitFeedbackScreen(),
        ),
        PlexRoute(
          route: Routes.uiTabs,
          category: "Design system",
          title: "Tabs",
          shortTitle: "Tabs",
          tag: "4",
          logo: const Icon(Icons.tab_outlined),
          selectedLogo: const Icon(Icons.tab),
          screen: (context, {data}) => const UiKitTabsScreen(),
        ),
        PlexRoute(
          route: Routes.uiDashboard,
          category: "Design system",
          title: "Dashboard widgets",
          shortTitle: "Dashboard",
          tag: "6",
          logo: const Icon(Icons.space_dashboard_outlined),
          selectedLogo: const Icon(Icons.space_dashboard),
          screen: (context, {data}) => const UiKitDashboardWidgetsScreen(),
        ),
        PlexRoute(
          route: Routes.dataGridScreen,
          category: "Design system",
          title: "Plex Data Grid",
          shortTitle: "Data Grid",
          tag: "grid",
          logo: const Icon(Icons.grid_on_outlined),
          selectedLogo: const Icon(Icons.grid_on),
          screen: (context, {data}) => const PlexDataGridDemoScreen(),
        ),
        PlexRoute(
          route: Routes.dashboardScreen,
          category: "Tables",
          title: "Data Table Widget Usage",
          shortTitle: "Data Table",
          logo: const Icon(Icons.table_rows_outlined),
          selectedLogo: const Icon(Icons.table_rows),
          screen: (context, {data}) => const DataTableDemoScreen(),
        ),
        PlexRoute(
          route: Routes.paginatedTable,
          category: "Tables",
          title: "Paginated Data Table",
          shortTitle: "Paginated Table",
          logo: const Icon(Icons.view_list_outlined),
          selectedLogo: const Icon(Icons.view_list),
          screen: (context, {data}) => const PaginatedTableDemoScreen(),
        ),
        PlexRoute(
          route: Routes.advanceDataTable,
          category: "Tables",
          title: "Advance Data Table",
          shortTitle: "Advance Table",
          logo: const Icon(Icons.table_chart_outlined),
          selectedLogo: const Icon(Icons.table_chart),
          screen: (context, {data}) => const AdvanceDataTableDemoScreen(),
        ),
        PlexRoute(
          external: true,
          route: "${Routes.dashboardScreen}External",
          category: "Tables",
          title: "External Screen",
          shortTitle: "Ext Screen",
          logo: const Icon(Icons.open_in_new_outlined),
          selectedLogo: const Icon(Icons.open_in_new),
          screen: (context, {data}) => const ExternalTableScreen(),
        ),
        PlexRoute(
          route: Routes.allInputs,
          category: "Forms",
          title: "All Inputs Usage",
          shortTitle: "All Inputs",
          logo: const Icon(Icons.input),
          selectedLogo: const Icon(Icons.panorama_photosphere_select),
          screen: (context, {data}) => const AllInputsScreen(),
        ),
        PlexRoute(
          route: Routes.formUsage,
          category: "Forms",
          title: "Form Widget Usage",
          shortTitle: "Form Widget",
          logo: const Icon(Icons.format_align_center_outlined),
          selectedLogo: const Icon(Icons.format_align_center),
          screen: (context, {data}) => const FormUsageScreen(),
        ),
        PlexRoute(
          route: Routes.autocompleteSample,
          category: "Widgets",
          title: "Autocomplete sample",
          shortTitle: "Autocomplete",
          logo: const Icon(Icons.search_outlined),
          selectedLogo: const Icon(Icons.search),
          screen: (context, {data}) {
            var controller = PlexWidgetController();
            return ExampleScrollPage(
              children: [
                ExampleCard(
                  title: "PlexFormFieldAutoComplete",
                  child: Column(
                    children: [
                      PlexFormFieldAutoComplete(
                        properties: const PlexFormFieldGeneric(
                          title: "Search",
                          useMargin: false,
                        ),
                        showBarCode: true,
                        dropdownSelectionController: controller,
                        autoCompleteItems: (query) async {
                          await Future<void>.delayed(
                              const Duration(milliseconds: 1000));
                          var items = List<String>.empty(growable: true);
                          for (int i = 1; i <= 10; i++) {
                            items.add("$query-$i");
                          }
                          return items;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        PlexRoute(
          route: Routes.logoRouteSample,
          category: "Widgets",
          title: "Logo route sample",
          shortTitle: "Logo route",
          screen: (context, {data}) => const ExampleScrollPage(
            children: [
              ExampleCard(
                title: "Custom route logo",
                child: Text("This route uses assets/app.png as its rail icon."),
              ),
            ],
          ),
          logo: SizedBox(
              width: 26, height: 26, child: Image.asset("assets/app.png")),
        ),
        PlexRoute(
          route: Routes.updateWidget,
          category: "Widgets",
          title: "Updatable Widget Usage",
          shortTitle: "Updatable Widget",
          logo: const Icon(Icons.browser_updated_outlined),
          selectedLogo: const Icon(Icons.browser_updated),
          screen: (context, {data}) => const UpdatableScreen(),
        ),
        PlexRoute(
          route: Routes.infoSheetDemoScreen,
          category: "Widgets",
          title: "Info Sheet Demo",
          shortTitle: "InfoSheet",
          logo: const Icon(Icons.info_outline),
          selectedLogo: const Icon(Icons.info),
          screen: (context, {data}) => const PlexInfoSheetDemoScreen(),
        ),
        PlexRoute(
          route: Routes.scannerDemoScreen,
          category: "Widgets",
          title: "Mobile Scanner Demo",
          shortTitle: "Scanner",
          logo: const Icon(Icons.qr_code_scanner_outlined),
          selectedLogo: const Icon(Icons.qr_code_scanner),
          screen: (context, {data}) => const PlexScannerDemoScreen(),
        ),
        PlexRoute(
          route: Routes.ganttDemoScreen,
          category: "Charts",
          title: "Gantt Chart Demo",
          shortTitle: "Gantt Demo",
          logo: const Icon(Icons.timeline_outlined),
          selectedLogo: const Icon(Icons.timeline),
          screen: (context, {data}) => const PlexGanttDemoScreen(),
        ),
      ],
      enableNotifications: true,
      showAnimationSwitch: true,
      navigationRailBackgroundColor: null,
    ),
    pages: [],
  ));
}
