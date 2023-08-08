import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_widgets/plex_data_table.dart';

class Routes {
  static const dashboardScreen = "/dashboard";
  static const secondScreen = "/second";
}

void main() async {
  getTableData() =>
      [
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
        additionalWidgets: Container(),
        onLogin: (email, password) async {
          return PlexUser({
            "Name": "Abdur Rahman",
          });
        }),
    routes: [
      PlexRoute(
        route: Routes.dashboardScreen,
        category: "Tables",
        title: "Data Table",
        logo: const Icon(Icons.account_balance_outlined),
        screen: (key, context) =>
            PlexDataTable(
              headerTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              headerBackground: Colors.redAccent,
              border: TableBorder.all(color: Colors.black12),
              onRefresh: () {
                return getTableData();
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
    ],
  ));
}
