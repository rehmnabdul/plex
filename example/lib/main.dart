import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_dashboard_screen.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_widgets/plex_data_table.dart';
import 'package:plex_app/screens/home_screen.dart';
import 'package:plex_app/screens/second_screen.dart';

class Routes {
  static const dashboardScreen = "/dashboard";
  static const secondScreen = "/second";
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
    themeFromColor: const Color(0xFF26A9E1),
    // themeFromImage: const AssetImage("/path/to/image"),
    appLogo: const Icon(Icons.account_balance),
    title: "Auto Backup",
    initialRoute: Routes.dashboardScreen,
    useAuthorization: true,
    loginConfig: PlexLoginConfig(
        additionalWidgetsTop: (context) => const Text("Login Screen"),
        additionalWidgetsBottom: (context) => const Text("Login Screen End"),
        onLogin: (context, email, password) async {
          return PlexUser({
            "Name": "Abdur Rahman",
          });
        }),
    dashboardConfig: PlexDashboardConfig(
      dashboardScreens: [
        PlexRoute(
          route: Routes.dashboardScreen,
          category: "Tables",
          title: "Data Table Widget Usage",
          logo: const Icon(Icons.account_balance_outlined),
          screen: (context) => PlexDataTable(
            headerTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            headerBackground: Colors.redAccent,
            border: TableBorder.all(color: Colors.black12),
            onRefresh: () {
              getTableData();
            },
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
          logo: const Icon(Icons.browser_updated),
          screen: (context) => const UpdatableScreen(),
        ),
        PlexRoute(
          route: "/form-usage",
          title: "Form Widget Usage",
          logo: const Icon(Icons.format_align_center),
          screen: (context) => const FormUsageScreen(),
        ),
      ],
    ),
  ));
}
