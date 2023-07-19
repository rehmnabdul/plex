
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
  runApp(PlexApp(
    themeFromColor: const Color(0xFF26A9E1),
    // themeFromImage: const AssetImage("/path/to/image"),
    appLogo: const Icon(Icons.account_balance),
    title: "Auto Backup",
    initialRoute: Routes.secondScreen,
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
        screen: (key, context) => Container(
          child: PlexDataTable(
            onRefresh: () {},
            columns: const ["Id", "First Name", "Last Name", "Emp Code", "Designation", "Grade", "Company"],
            rows: const [
              ["1", "Abdur", "Rahman", "256720", "IT Specialist", "E3", "Interloop Pvt. Ltd"],
              ["1", "Abdur", "Rahman", "256720", "IT Specialist", "E3", "Interloop Pvt. Ltd"],
              ["1", "Abdur", "Rahman", "256720", "IT Specialist", "E3", "Interloop Pvt. Ltd"],
              ["1", "Abdur", "Rahman", "256720", "IT Specialist", "E3", "Interloop Pvt. Ltd"],
              ["1", "Abdur", "Rahman", "256720", "IT Specialist", "E3", "Interloop Pvt. Ltd"],
              ["1", "Abdur", "Rahman", "256720", "IT Specialist", "E3", "Interloop Pvt. Ltd"],
            ],
          ),
        ),
      ),
    ],
  ));
}
