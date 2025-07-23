import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plex/plex_charts/plex_chart_gant.dart';
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
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex_app/screens/home_screen.dart';
import 'package:plex_app/screens/plex_info_sheet_demo_screen.dart';
import 'package:plex_app/screens/second_screen.dart';

class Routes {
  static const dashboardScreen = "/dashboard";
  static const secondScreen = "/second";
  static const formBuilderScreen = "/form-builder";
  static const getxExampleScreen = "/getx-example";
  static const infoSheetDemoScreen = "/info-sheet-demo";
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

  @override
  String? getInitialPath() {
    return "/advance-data-table";
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
  }
}

class GanttChartDemoPage extends StatelessWidget {
  const GanttChartDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chartStart = DateTime(2025, 7, 23, 8); // 8 AM
    final chartEnd = DateTime(2025, 7, 23, 18);  // 6 PM

    final tasks = [
      GantTask(
        id: 'task1',
        title: 'Project Kickoff',
        start: DateTime(2025, 7, 23, 9),
        end: DateTime(2025, 7, 23, 10),
        color: Colors.blueAccent,
      ),
      GantTask(
        id: 'task2',
        title: 'UI Design',
        start: DateTime(2025, 7, 23, 10),
        end: DateTime(2025, 7, 23, 12),
        color: Colors.purple,
      ),
      GantTask(
        id: 'task3',
        title: 'API Integration',
        start: DateTime(2025, 7, 23, 13),
        end: DateTime(2025, 7, 23, 15),
        color: Colors.green,
      ),
      GantTask(
        id: 'task4',
        title: 'Testing & QA',
        start: DateTime(2025, 7, 23, 15),
        end: DateTime(2025, 7, 23, 17),
        color: Colors.deepOrange,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Plex Gantt Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PlexChartGant(
          chartStart: chartStart,
          chartEnd: chartEnd,
          tasks: tasks,
          pixelsPerHour: 60,
        ),
      ),
    );
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
          // PlexDataTableValueCell.text("Company", "Company Name is Long jhghggjgjggjgjhj $a"),
          PlexDataTableValueCell.custom("Company", "Long ", Container(color: Colors.redAccent, child: const Text("Long Long Long Long Long Long Long Long Long Long"))),
          PlexDataTableValueCell.text("1", "1 - $a"),
          PlexDataTableValueCell.text("2", "2 - $a"),
          PlexDataTableValueCell.text("3", "3 - $a"),
          PlexDataTableValueCell.text("4", "4 - $a"),
          PlexDataTableValueCell.text("5", "5 - $a"),
          PlexDataTableValueCell.text("6", "6 - $a"),
          PlexDataTableValueCell.text("7", "7 - $a"),
          PlexDataTableValueCell.text("8", "8 - $a"),
          PlexDataTableValueCell.text("9", "9 - $a"),
          PlexDataTableValueCell.text("10", "10 - $a"),
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

  initializeDb();

  ///PlexSignalR Implementation
  // Future.delayed(Duration(seconds: 0), () async {
  //   PlexSignalR.config = PlexSignalRConfig(
  //     "https://flh.interloop.com.pk:4433",
  //     "eventHub",
  //     remoteMethods: [
  //       PlexSignalRMethod("OnEvent", (arguments) {
  //         print(arguments);
  //       }),
  //       PlexSignalRMethod("NewTest", (arguments) {
  //         print(arguments);
  //       }),
  //     ],
  //     onClose: (error) {},
  //     onConnecting: (error) {},
  //   );
  //   await PlexSignalR.instance.start();
  //
  //   PlexSignalR.instance.invoke("JoinGroup", ["FL1"]);
  //   PlexSignalR.instance.invoke("JoinGroup", ["FL2"]);
  //
  //   PlexSignalR.instance.invoke("SendEventToGroup", ["FL1", "From Group 1"]);
  //   PlexSignalR.instance.invoke("SendEventToGroup", ["FL2", "From Group 2"]);
  //
  //   PlexSignalR.instance.invoke("LeaveGroup", ["FL2"]);
  //
  //   PlexSignalR.instance.invoke("SendEventToGroup", ["FL1", "From Group 1"]);
  //   PlexSignalR.instance.invoke("SendEventToGroup", ["FL2", "From Group 2"]);
  //   PlexSignalR.instance.invoke("SendEventToAllByMethod", ["NewTest", "For New Test"]);
  // });
  ///PlexSignalR Implementation End

  runApp(PlexApp(
    ///Setting Theme Second Method : Theme By Color
    themeFromColor: const Color(0xFF26A9E1),

    ///Setting Theme Third Method : Theme By Image
    // themeFromImage: const AssetImage("assets/img.png"),
    appInfo: PlexAppInfo(
      title: "Auto Backup",
      appLogo: Image.asset("assets/app.png"),
      appLogoDark: Image.asset("assets/app.png"),
      initialRoute: "/all-inputs",
      //Routes.dashboardScreen,
      versionCode: 1,
      versionName: "v1.0.0",
    ),
    useAuthorization: true,
    onInitializationComplete: () async {
      PlexTheme.appTextTheme = GoogleFonts.outfitTextTheme();
      PlexNetworking.instance.allowBadCertificateForHTTPS();
    },
    loginConfig: PlexLoginConfig(
      debugUsername: 'DebugUser',
      debugPassword: 'DebugPassword',
      username: "User",
      password: "Password",
      passwordMaxLength: 15,
      additionalWidgetsTop: (context) => const Text("Login Screen"),
      additionalWidgetsBottom: (context) => const Text("Login Screen End"),
      additionalWidgetsAboveLoginButton: (context) => const Text("Middle Widgets"),
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
          route: "/GantChart",
          category: "Charts",
          title: "Gant Charts",
          shortTitle: 'Gant',
          logo: const Icon(Icons.waterfall_chart),
          selectedLogo: const Icon(Icons.waterfall_chart_rounded),
          screen: (context, {data}) {
            return GanttChartDemoPage();
          }
        ),
        PlexRoute(
          external: true,
          route: "${Routes.dashboardScreen}External",
          category: "External",
          title: "External Screen",
          shortTitle: 'Ext Screen',
          logo: const Icon(Icons.extension_outlined),
          selectedLogo: const Icon(Icons.extension),
          screen: (context, {data}) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: const Text("External Screen"),
              ),
              body: PlexDataTable(
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
              ),
            );
          },
        ),
        PlexRoute(
          route: Routes.dashboardScreen,
          category: "Tables",
          title: "Data Table Widget Usage",
          shortTitle: 'Data Table',
          logo: const Icon(Icons.account_balance_outlined),
          selectedLogo: const Icon(Icons.account_balance),
          screen: (context, {data}) {
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
          route: "newPath1",
          title: "New Screen 1",
          screen: (context, {data}) {
            var controller = PlexWidgetController();
            return Column(
              children: [
                PlexFormFieldAutoComplete(
                  properties: const PlexFormFieldGeneric.title("Test"),
                  showBarCode: true,
                  dropdownSelectionController: controller,
                  autoCompleteItems: (query) async {
                    await Future.delayed(const Duration(milliseconds: 1000));
                    var items = List<String>.empty(growable: true);
                    for (int i = 1; i <= 10; i++) {
                      items.add("$query-$i");
                    }

                    return items;
                  },
                ),
                const Text("New Screen 1"),
              ],
            );
          },
        ),
        PlexRoute(route: "newPath2", title: "New Screen 2", screen: (context, {data}) => const Text("New Screen 2"), logo: SizedBox(width: 26, height: 26, child: Image.asset("assets/app.png"))),
        PlexRoute(
          route: "/paginated-table",
          category: "Paginated Tables",
          title: "Paginated Data Table",
          shortTitle: 'Paginated Table',
          logo: const Icon(Icons.account_balance_outlined),
          selectedLogo: const Icon(Icons.account_balance),
          screen: (context, {data}) => PlexDataTableWithPages(
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
          screen: (context, {data}) {
            var gridController = PlexWidgetController(data: getAdvanceTableData());
            var controller = TextEditingController();
            return PlexAdvanceDataTable(
              title: "Advance Data Table",
              widthMode: WidthMode.none,
              columns: [
                PlexDataTableHeaderCell.text("Id", showOrderByControl: false),
                PlexDataTableHeaderCell.text("First", showFilterControl: false),
                PlexDataTableHeaderCell.text("Last"),
                PlexDataTableHeaderCell.text("EmpCode"),
                PlexDataTableHeaderCell.text("Designation"),
                PlexDataTableHeaderCell.text("Grade"),
                PlexDataTableHeaderCell.text("Company", showOrderByControl: false, showFilterControl: false),
                PlexDataTableHeaderCell.text("1"),
                PlexDataTableHeaderCell.text("2"),
                PlexDataTableHeaderCell.text("3"),
                PlexDataTableHeaderCell.text("4"),
                PlexDataTableHeaderCell.text("5"),
                PlexDataTableHeaderCell.text("6"),
                PlexDataTableHeaderCell.text("7"),
                PlexDataTableHeaderCell.text("8"),
                PlexDataTableHeaderCell.text("9"),
                PlexDataTableHeaderCell.text("10"),
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
          screen: (context, {data}) => const UpdatableScreen(),
        ),
        PlexRoute(
          route: "/form-usage",
          title: "Form Widget Usage",
          shortTitle: 'Form Widget',
          logo: const Icon(Icons.format_align_center_outlined),
          selectedLogo: const Icon(Icons.format_align_center),
          screen: (context, {data}) => const FormUsageScreen(),
        ),
        PlexRoute(
          route: "/all-inputs",
          title: "All Inputs Usage",
          shortTitle: 'All Inputs',
          logo: const Icon(Icons.input),
          selectedLogo: const Icon(Icons.panorama_photosphere_select),
          screen: (context, {data}) {
            // Controllers for stateful widgets
            final textEditingController = TextEditingController(text: "Initial Text");
            final errorController = PlexWidgetController(data: "This is an error message");
            final dateController = PlexWidgetController<DateTime?>();
            final timeController = PlexWidgetController<DateTime?>();
            final dateTimeController = PlexWidgetController<DateTime?>();
            final dropdownController = PlexWidgetController<String?>();
            final multiSelectController = PlexWidgetController<List<String>?>(data: ['Option 2']);
            final autoCompleteController = PlexWidgetController<String?>();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("PlexFormFieldInput", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlexFormFieldInput(
                    properties: const PlexFormFieldGeneric.title("Text Input Field"),
                    inputHint: "Enter some text",
                    inputController: textEditingController,
                    inputOnChange: (value) {
                      print("Text Input Changed: $value");
                    },
                  ),
                  PlexFormFieldInput(
                    properties: const PlexFormFieldGeneric.title("Password Field"),
                    inputHint: "Enter your password",
                    isPassword: true,
                    maxInputLength: 20,
                    inputOnChange: (value) {
                      print("Password Changed: $value");
                    },
                  ),
                  PlexFormFieldInput(
                    properties: const PlexFormFieldGeneric.title("Numeric Input"),
                    inputHint: "Enter a number",
                    inputKeyboardType: TextInputType.number,
                    inputOnChange: (value) {
                      print("Numeric Input Changed: $value");
                    },
                  ),
                  PlexFormFieldInput(
                    properties: const PlexFormFieldGeneric.title("Input with Prefix/Suffix Icons"),
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: const Icon(Icons.info_outline),
                    inputOnChange: (value) {
                      print("Icon Input Changed: $value");
                    },
                  ),
                  PlexFormFieldInput(
                    properties: const PlexFormFieldGeneric(title: "Disabled Input Field", enabled: false),
                    inputHint: "This field is disabled",
                  ),
                  PlexFormFieldInput(
                    properties: const PlexFormFieldGeneric.title("Input with Error"),
                    errorController: errorController,
                    inputHint: "This field has an error",
                  ),
                  const SizedBox(height: 16),
                  const Text("PlexFormFieldDate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlexFormFieldDate(
                    type: PlexFormFieldDateType.typeDate,
                    properties: const PlexFormFieldGeneric.title("Date Picker"),
                    selectionController: dateController,
                    onSelect: (item) {
                      print("Date Selected: $item");
                    },
                    minDatetime: DateTime.now().subtract(const Duration(days: 30)),
                    maxDatetime: DateTime.now().add(const Duration(days: 30)),
                  ),
                  PlexFormFieldDate(
                    type: PlexFormFieldDateType.typeTime,
                    properties: const PlexFormFieldGeneric.title("Time Picker"),
                    selectionController: timeController,
                    onSelect: (item) {
                      print("Time Selected: $item");
                    },
                  ),
                  PlexFormFieldDate(
                    type: PlexFormFieldDateType.typeDateTime,
                    properties: const PlexFormFieldGeneric.title("Date & Time Picker"),
                    selectionController: dateTimeController,
                    onSelect: (item) {
                      print("DateTime Selected: $item");
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("PlexFormFieldDropdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlexFormFieldDropdown<String>(
                    properties: const PlexFormFieldGeneric.title("Dropdown Select"),
                    dropdownItems: const ["Option 1", "Option 2", "Option 3", "Another Option with a long name"],
                    dropdownSelectionController: dropdownController,
                    initialSelection: "Option 1",
                    dropdownItemAsString: (item) => item.toUpperCase(),
                    dropdownItemOnSelect: (item) {
                      print("Dropdown Selected: $item");
                    },
                    showClearButton: true,
                  ),
                  const SizedBox(height: 16),
                  const Text("PlexFormFieldMultiSelect", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlexFormFieldMultiSelect<String>(
                    properties: const PlexFormFieldGeneric.title("Multi-Select Dropdown"),
                    dropdownItems: const ["Option A", "Option B", "Option C", "Option D"],
                    multiSelectionController: multiSelectController,
                    // multiInitialSelection: ['Option B'], // Controller takes precedence
                    dropdownItemAsString: (item) => "Item: $item",
                    dropdownItemOnSelect: (items) {
                      print("MultiSelect Selected: $items");
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("PlexFormFieldAutoComplete", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlexFormFieldAutoComplete<String>(
                    properties: const PlexFormFieldGeneric.title("Auto Complete Search"),
                    dropdownSelectionController: autoCompleteController,
                    autoCompleteItems: (query) async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (query.isEmpty) {
                        return ["Apple", "Banana", "Cherry", "Date", "Elderberry"];
                      }
                      return ["Apple", "Banana", "Cherry", "Date", "Elderberry"].where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
                    },
                    dropdownItemAsString: (item) => item,
                    dropdownItemOnSelect: (item) {
                      print("AutoComplete Selected: $item");
                    },
                    inputDelay: 300,
                    // milliseconds
                    showBarCode: true,
                  ),
                  const SizedBox(height: 16),
                  const Text("PlexFormFieldButton", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Elevated Button"),
                    buttonClick: () {
                      print("Elevated Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Elevated Button Clicked!")));
                    },
                  ),
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Button with Icon"),
                    buttonIcon: const Icon(Icons.send),
                    buttonClick: () {
                      print("Icon Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Icon Button Clicked!")));
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("PlexFormFieldButton", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // Elevated Button (default)
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Unified Elevated Button"),
                    buttonType: PlexButtonType.elevated,
                    buttonClick: () {
                      print("Unified Elevated Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unified Elevated Button Clicked!")),
                      );
                    },
                  ),

                  // Text Button
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Unified Text Button"),
                    buttonType: PlexButtonType.text,
                    buttonClick: () {
                      print("Unified Text Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unified Text Button Clicked!")),
                      );
                    },
                  ),

                  // Outlined Button
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Unified Outlined Button"),
                    buttonType: PlexButtonType.outlined,
                    buttonClick: () {
                      print("Unified Outlined Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unified Outlined Button Clicked!")),
                      );
                    },
                  ),

                  // Filled Button
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Unified Filled Button"),
                    buttonType: PlexButtonType.filled,
                    buttonClick: () {
                      print("Unified Filled Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unified Filled Button Clicked!")),
                      );
                    },
                  ),

                  // Filled Tonal Button
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Unified Filled Tonal Button"),
                    buttonType: PlexButtonType.filledTonal,
                    buttonClick: () {
                      print("Unified Filled Tonal Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unified Filled Tonal Button Clicked!")),
                      );
                    },
                  ),

                  // Button with Icon
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Unified Button with Icon"),
                    buttonType: PlexButtonType.elevated,
                    buttonIcon: const Icon(Icons.add),
                    buttonClick: () {
                      print("Unified Button with Icon Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unified Button with Icon Clicked!")),
                      );
                    },
                  ),

                  // Icon-only Button
                  PlexFormFieldButton(
                    buttonType: PlexButtonType.filledTonal,
                    buttonIcon: const Icon(Icons.favorite),
                    buttonClick: () {
                      print("Icon-only Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Icon-only Button Clicked!")),
                      );
                    },
                  ),

                  // Disabled Button
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric(
                      title: "Disabled Button",
                      enabled: false,
                    ),
                    buttonType: PlexButtonType.filled,
                    buttonIcon: const Icon(Icons.block),
                    buttonClick: () {
                      // This won't be called because the button is disabled
                      print("This should not be called!");
                    },
                  ),

                  // Text button with icon
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Text Button with Icon"),
                    buttonType: PlexButtonType.text,
                    buttonIcon: const Icon(Icons.info),
                    buttonClick: () {
                      print("Text Button with Icon Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Text Button with Icon Clicked!")),
                      );
                    },
                  ),

                  // Outlined button with icon
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Outlined Button with Icon"),
                    buttonType: PlexButtonType.outlined,
                    buttonIcon: const Icon(Icons.edit),
                    buttonClick: () {
                      print("Outlined Button with Icon Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Outlined Button with Icon Clicked!")),
                      );
                    },
                  ),

                  // Filled Tonal button with icon
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Filled Tonal with Icon"),
                    buttonType: PlexButtonType.filledTonal,
                    buttonIcon: const Icon(Icons.search),
                    buttonClick: () {
                      print("Filled Tonal Button with Icon Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filled Tonal Button with Icon Clicked!")),
                      );
                    },
                  ),

                  // Button with custom style
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric.title("Custom Styled Button"),
                    buttonType: PlexButtonType.elevated,
                    buttonIcon: const Icon(Icons.star),
                    buttonStyle: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                    buttonClick: () {
                      print("Custom Styled Button Clicked!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Custom Styled Button Clicked!")),
                      );
                    },
                  ),

                  const SizedBox(height: 32), // Extra space at the bottom
                ],
              ),
            );
          },
        ),
        PlexRoute(
          route: Routes.infoSheetDemoScreen,
          title: "Info Sheet Demo",
          shortTitle: "InfoSheet",
          logo: const Icon(Icons.info_outline),
          selectedLogo: const Icon(Icons.info),
          screen: (context, {data}) => const PlexInfoSheetDemoScreen(),
        ),
      ],
      enableNotifications: true,
      showAnimationSwitch: true,
      navigationRailBackgroundColor: null,
    ),
    pages: [],
  ));
}
