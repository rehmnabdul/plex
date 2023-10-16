# <div style="text-align: center;">PLEX</div>

<p style="text-align: justify;">
`PLEX` is a UI framework for Flutter designed specifically for building enterprise applications. It provides a robust and customizable foundation for the entire application, including boilerplate code for main.dart file, routes, screens, and other essential components.

In addition to the basic application structure, `PLEX` comes with pre-built components for common UI elements such as tableviews and forms. The tableviews can be easily customized to display data in various formats like lists and grids, while the forms can collect data from users using different
input
types like text fields, dropdowns, and checkboxes.

`PLEX` also offers guidelines and best practices for building enterprise applications, including data management, architecture, testing, and more. These guidelines can help developers to build scalable, maintainable, and high-performance applications.

The `PLEX` framework is an ideal choice for developers who want to build enterprise-level applications quickly and efficiently, without compromising on quality or customization. Its pre-built components and best practices can save developers a significant amount of time and effort, while also
ensuring
the resulting application meets the high standards of enterprise-level software.
</p>

#### Note:

`PLEX` also provide a single click to move from `Material 2` to `Material 3` and `Light Mode` to `Dark Mode`.

## Screenshots

### Material 3

<div style="text-align: center;">
<img alt="Material 3 Light" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_2.png"  width="25%" title="Material 3 Light"/>
<img alt="Material 3 Dark" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_4.png" width="25%" title="Material 3 Dark">
</div>

### Material 2

<div style="text-align: center;">
<img alt="Material 2 Light" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_1.png" width="25%" title="Material 2 Light"/>
<img alt="Material 2 Dark" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_3.png" width="25%" title="Material 2 Dark">
</div>

## Features

1. Create boilerplate code for an **Application**
2. Built in login screen
3. Built in User session manager
4. Free useful widgets
5. Free useful utilities
6. Built in screens and pages
7. Builtin form builder from model class

## Getting started

Install the `plex` in your application.

## Usage

## Widgets

1. PlexWidget
2. PlexDataTable
3. PlexInputWidget
4. PlexFormWidget
5. PlexInputWidget

#### PlexInputWidget

###### Usage

```dart
// Input Types
// PlexInputWidget.typeInput
// PlexInputWidget.typeDropdown
// PlexInputWidget.typeDate
// PlexInputWidget.typeButton

PlexInputWidget(
    title: "Username / Email",
    
    type: PlexInputWidget.typeInput,
    inputHint: "Enter Your Email or Username",
    inputController: usernameController,
    inputOnChange: (value) {},
    inputOnSubmit: (value) {},
    inputAction: TextInputAction.go,
    inputKeyboardType: TextInputType.name,
    isPassword: false,
    
    dropdownItemOnSelect: (item) {},
    dropdownItemAsString: (item) => item.toString(),
    dropdownItems: const ["Data"],
    dropdownAsyncItems: Future(() => ["Data"]),
    dropdownSelectionController: PlexWidgetController(),
    dropDownLeadingIcon: (item) => const Icon(Icons.add),
    dropdownItemWidget: (item) => const Text("Data"),
    dropdownOnSearch: (query, item) { return true; },
    dropdownCustomOnTap: () {},
    
    buttonClick: ,
    buttonIcon: ,
    buttonColor: ,
    
    useMargin: ,
    margin: ,
    fieldColor: ,
    editable: ,
    helperText: ,
)
```

#### Persistent Storage

```dart
//Only initialize if you are not using PlexApp 
//and using PlexDb separately
PlexDb.initialize();

PlexDb.instance.setString("Key", "Value");
PlexDb.instance.getString("Key");

PlexDb.instance.setBool("Key", true);
PlexDb.instance.getBool("Key");
```

### Messaging

```dart
BuildContext context;
context.showSnackBar("Your Message...");
```

### Complete Example of Using PlexApp

- You can also see example project to see the whole project usage in action.

```dart
import 'package:flutter/material.dart';
import 'package:plex/plex_networking/plex_networking.dart';
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

class AppUser extends PlexUser {
  late String email;
  late String userName;
  List<String>? rules;

  AppUser.init({required this.email, required this.userName, this.rules});

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
    themeFromColor: const Color(0xFF26A9E1),
    // themeFromImage: const AssetImage("/path/to/image"),
    appInfo: PlexAppInfo(
      title: "Auto Backup",
      appLogo: const Icon(Icons.account_balance),
      appLogoDark: const Icon(Icons.account_balance, color: Colors.white),
      initialRoute: Routes.dashboardScreen,
      versionCode: 1,
      versionName: "v1.0.0",
    ),
    useAuthorization: true,
    onInitializationComplete: () {
      PlexNetworking;
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
      dashboardScreens: [
        PlexRoute(
          route: Routes.dashboardScreen,
          category: "Tables",
          title: "Data Table Widget Usage",
          logo: const Icon(Icons.account_balance_outlined),
          screen: (context) => PlexDataTable(
            enableSearch: true,
            enablePrint: true,
            onRefresh: () {
              getTableData();
            },
            headerTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            headerBackground: Colors.redAccent,
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
        ),
        PlexRoute(
          route: "/paginated-table",
          category: "Paginated Tables",
          title: "Paginated Data Table",
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
```
