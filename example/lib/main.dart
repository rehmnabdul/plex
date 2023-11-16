import 'package:flutter/material.dart';
import 'package:plex/plex_networking/plex_networking.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_dashboard_screen.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_widgets/plex_data_table.dart';
import 'package:plex_app/screens/home_screen.dart';
import 'package:plex_app/screens/second_screen.dart';

class Routes {
  static const dashboardScreen = "/dashboard";
  static const secondScreen = "/second";
}

class AppUser extends PlexUser {
  late String email;
  late String userName;
  List<String>? rules;

  AppUser.init({required this.email, required this.userName, this.rules});

  @override
  String? getPictureUrl() {
    return "https://images.pexels.com/photos/631317/pexels-photo-631317.jpeg";
    return "https://10.111.2.21/assets/images/super-admin.jpg";
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

  AppUser.fromJson(Map<String, dynamic> map) {
    userName = map["userName"];
    email = map["email"];
    rules = map["rules"];
  }
}

void main() async {
  getTableData() => [
        [
          PlexDataCell.text("1"),
          PlexDataCell.text("First"),
          PlexDataCell.text("Person"),
          PlexDataCell.text("EMP953312RT"),
          PlexDataCell.text("Software Engineer"),
          PlexDataCell.text("Grade"),
          PlexDataCell.custom(
            "First Company Pvt. Ltd",
            const DataCell(
              Text("First Company Pvt. Ltd", style: TextStyle(color: Colors.brown)),
            ),
          ),
        ],
        [
          PlexDataCell.text("2"),
          PlexDataCell.text("Second"),
          PlexDataCell.text("Person"),
          PlexDataCell.text("EMP95313RT"),
          PlexDataCell.text("Software Engineer"),
          PlexDataCell.text("Scale"),
          PlexDataCell.custom(
            "Second Company Pvt. Ltd",
            const DataCell(
              Text("Second Company Pvt. Ltd", style: TextStyle(color: Colors.green)),
            ),
          )
        ],
      ];

  runApp(PlexApp(
    // themeFromColor: const Color(0xFF26A9E1),
    themeFromImage: const AssetImage("assets/img.png"),
    appInfo: PlexAppInfo(
      title: "Auto Backup",
      appLogo: Image.asset("assets/app.png"),
      appLogoDark: Image.asset("assets/app.png"),
      initialRoute: Routes.dashboardScreen,
      versionCode: 1,
      versionName: "v1.0.0",
    ),
    useAuthorization: true,
    onInitializationComplete: () {
      PlexNetworking.instance.allowBadCertificateForHTTPS();
    },
    loginConfig: PlexLoginConfig(
      debugUsername: 'test',
      debugPassword: 'password',
      additionalWidgetsTop: (context) => const Text("Login Screen"),
      additionalWidgetsBottom: (context) => const Text("Login Screen End"),
      onLogin: (context, email, password) async {
        return AppUser.init(userName: "Abdur Rahman", email: "ar@mail.com");
      },
      userFromJson: (userData) {
        return AppUser.fromJson(userData);
      },
    ),
    dashboardConfig: PlexDashboardConfig(
      disableExpandNavigationRail: false,
      disableNavigationRail: false,
      disableBottomNavigation: false,
      showThemeSwitch: true,
      showBrightnessSwitch: true,
      showMaterialSwitch: true,
      appbarActions: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.abc_outlined),
          child: const Text("ABC"),
          onPressed: () {},
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.account_tree_outlined),
          child: const Text("Tree"),
          onPressed: () {},
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.account_balance_outlined),
          child: const Text("Balance"),
          onPressed: () {},
        ),
      ],
      dashboardScreens: [
        PlexRoute(
          route: Routes.dashboardScreen,
          category: "Tables",
          title: "Data Table Widget Usage",
          shortTitle: 'Data Table',
          logo: const Icon(Icons.account_balance_outlined),
          screen: (context) => PlexDataTable(
            enableSearch: true,
            enablePrint: true,
            onRefresh: () {
              getTableData();
            },
            headerTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            headerBackground: PlexTheme.getActiveTheme().primaryColor,
            border: TableBorder.all(color: Colors.black12),
            columns: [
              PlexDataCell.text("Id"),
              PlexDataCell.text("First Name"),
              PlexDataCell.text("Last Name"),
              PlexDataCell.text("Emp Code"),
              PlexDataCell.text("Designation"),
              PlexDataCell.text("Grade"),
              PlexDataCell.text("Company"),
            ],
            rows: List.empty(), //getTableData(),
          ),
        ),
        PlexRoute(
          route: "/paginated-table",
          category: "Paginated Tables",
          title: "Paginated Data Table",
          shortTitle: 'Paginated Table',
          logo: const Icon(Icons.account_balance_outlined),
          screen: (context) => PlexDataTableWithPages(
            columns: [
              PlexDataCell.text("Id"),
              PlexDataCell.text("First Name"),
              PlexDataCell.text("Last Name"),
              PlexDataCell.text("Emp Code"),
              PlexDataCell.text("Designation"),
              PlexDataCell.text("Grade"),
              PlexDataCell.text("Company"),
            ],
            rows: getTableData(),
          ),
        ),
        PlexRoute(
          route: "/update-widget",
          title: "Updatable Widget Usage",
          shortTitle: 'Updatable Widget',
          logo: const Icon(Icons.browser_updated),
          screen: (context) => const UpdatableScreen(),
        ),
        PlexRoute(
          route: "/form-usage",
          title: "Form Widget Usage",
          shortTitle: 'Form Widget',
          logo: const Icon(Icons.format_align_center),
          screen: (context) => const FormUsageScreen(),
        ),
      ],
    ),
  ));
}
