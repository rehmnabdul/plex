import 'dart:math';

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
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_adv_data_table.dart';
import 'package:plex/plex_widgets/plex_data_table.dart';
import 'package:plex/plex_widgets/plex_data_table_paginated.dart';
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
  var db = await PlexDb.initialize(PlexDbConfig("PlexTestDatabase.db"));
  testMapDb() async {
    var usersRefMap = db.getCollection("Users");

    var maps = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((a) => UserEntity.init(email: "ab$a@gmail.com", userName: "ab$a").toJson()).toList();
    await usersRefMap.insertAll(maps);

    var usersMap = await usersRefMap.getAll();
    for (var element in usersMap) {
      element['userName'] += " (Edited)";
      await usersRefMap.update(element);
    }

    usersMap = await usersRefMap.getAll();
    await usersRefMap.delete(usersMap.first);

    usersMap = await usersRefMap.getAll();
    print("object");
  }

  testEntityDb() async {
    var usersRefMap = db.getEntityCollection(
      "UsersEntities",
      toJson: (e) => e.toJson(),
      fromJson: (m) => UserEntity.fromJson(m),
    );

    var maps = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((a) => UserEntity.init(email: "ab$a@gmail.com", userName: "ab$a")).toList();
    await usersRefMap.insertAll(maps);

    var usersMap = await usersRefMap.getAll();
    for (var element in usersMap) {
      element.userName += " (Edited)";
      await usersRefMap.update(element);
    }

    usersMap = await usersRefMap.getAll();
    await usersRefMap.delete(usersMap.first);

    usersMap = await usersRefMap.getAll();
    print("object");
  }
}

void main() async {
  getTableData() => [
        [
          PlexDataCell.text(285),
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
        [
          PlexDataCell.text(29),
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
          PlexDataCell.text(280),
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

  List<List<PlexDataTableValueCell>> getAdvanceTableData() {
    var data = List<List<PlexDataTableValueCell>>.empty(growable: true);
    for (var a = 0; a < 100; a++) {
      data.add(
        [
          PlexDataTableValueCell.text("Id", Random().nextInt(9999)),
          PlexDataTableValueCell.text("First", "First $a"),
          PlexDataTableValueCell.text("Last", "Last $a"),
          PlexDataTableValueCell.text("EmpCode", "EMP$a"),
          PlexDataTableValueCell.text("Designation", "Engineer ${Random().nextInt(10) + 1}"),
          PlexDataTableValueCell.text("Grade", "Scale ${Random().nextInt(5) + 1}"),
          PlexDataTableValueCell.text("Company", "Company Name $a"),
        ],
      );
    }
    return data;
  }

  ///Setting Theme First Method : Customized Theme
  // PlexTheme.appTheme = ThemeData(
  //   useMaterial3: true,
  //   colorSchemeSeed: const Color(0xFF26A9E1),
  // );

  ///Dependency Injection
  injectSingleton(MyUser("firstName", "lastName", 20, DateTime.now(), true, "object", [1, 2, 3]));

  ///Get Injected Objects
  var user = fromPlex<MyUser>();
  print(user.toString());

  initializeDb();

  runApp(PlexApp(
    ///Setting Theme Second Method : Theme By Color
    themeFromColor: const Color(0xFF26A9E1),

    ///Setting Theme Third Method : Theme By Image
    // themeFromImage: const AssetImage("assets/img.png"),
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
      PlexTheme.appTextTheme = GoogleFonts.outfitTextTheme();
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
      // navigationRailBackgroundColor: Colors.green.shade900,
      navigationRailBottomWidgets: (state, context) => [
        const Text("Bottom Widget"),
      ],
      navigationRailTopWidgets: (state, context) => [
        const Text("Top Widget"),
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
          route: Routes.dashboardScreen,
          category: "Tables",
          title: "Data Table Widget Usage",
          shortTitle: 'Data Table',
          logo: const Icon(Icons.account_balance_outlined),
          selectedLogo: const Icon(Icons.account_balance),
          screen: (context) {
            return PlexDataTable(
              key: UniqueKey(),
              enableSearch: true,
              enablePrint: true,
              enableCopy: false,
              onRefresh: () {
                getTableData();
              },
              headerTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              headerBackground: PlexTheme.getActiveTheme(context).primaryColor,
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
              rows: getTableData(),
            );
          },
        ),
        PlexRoute(
          route: "/paginated-table",
          category: "Paginated Tables",
          title: "Paginated Data Table",
          shortTitle: 'Paginated Table',
          logo: const Icon(Icons.account_balance_outlined),
          selectedLogo: const Icon(Icons.account_balance),
          screen: (context) => PlexDataTableWithPages(
            columns: [
              PlexDataCell.text("Id", numberField: true),
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
          route: "/advance-data-table",
          title: "Advance Data Table",
          logo: const Icon(Icons.table_chart_outlined),
          selectedLogo: const Icon(Icons.table_chart),
          screen: (context) {
            var gridController = PlexWidgetController(data: getAdvanceTableData());
            var controller = TextEditingController();
            return PlexAdvanceDataTable(
              title: "Advance Data Table",
              widthMode: WidthMode.none,
              columns: [
                PlexDataTableHeaderCell.text("Id"),
                PlexDataTableHeaderCell.text("First"),
                PlexDataTableHeaderCell.text("Last"),
                PlexDataTableHeaderCell.text("EmpCode"),
                PlexDataTableHeaderCell.text("Designation"),
                PlexDataTableHeaderCell.text("Grade"),
                PlexDataTableHeaderCell.text("Company", widthMode: WidthMode.fill),
              ],
              controller: gridController,
              cellEditingWidget: (row, column) {
                if ([0, 1, 2].contains(column)) {
                  controller.text = (gridController.data as List<List<PlexDataTableValueCell>>)[row][column].value.toString();
                  return TextField(controller: controller);
                }
              },
              cellEditingSubmit: (row, column) async {
                var cell = (gridController.data as List<List<PlexDataTableValueCell>>)[row][column];
                (gridController.data as List<List<PlexDataTableValueCell>>)[row][column] = cell.clone(newValue: controller.text);
              },
            );
          },
        ),
        PlexRoute(
          route: "/update-widget",
          title: "Updatable Widget Usage",
          shortTitle: 'Updatable Widget',
          logo: const Icon(Icons.browser_updated_outlined),
          selectedLogo: const Icon(Icons.browser_updated),
          screen: (context) => const UpdatableScreen(),
        ),
        PlexRoute(
          route: "/form-usage",
          title: "Form Widget Usage",
          shortTitle: 'Form Widget',
          logo: const Icon(Icons.format_align_center_outlined),
          selectedLogo: const Icon(Icons.format_align_center),
          screen: (context) => const FormUsageScreen(),
        ),
      ],
      enableNotifications: true,
      showAnimationSwitch: true,
      navigationRailBackgroundColor: null,
    ),
  ));
}
