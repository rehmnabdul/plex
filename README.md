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

### Application Screen Shots

<div style="text-align: center;">
<img alt="Dashboard - Large" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/1.png" width="38%" title="Dashboard - Large"/>
<img alt="Dashboard - Medium" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/2.png" width="25%" title="Dashboard - Medium">
</div>

<div style="text-align: center;">
<img alt="Dashboard - Mobile" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/3.png" width="25%" title="Dashboard - Mobile"/>
<img alt="Dashboard Drawer - Mobile" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/4.png" width="25%" title="Dashboard Drawer - Mobile">
</div>

<div style="text-align: center;">
<img alt="Paginated Table" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/5.png" width="25%" title="Paginated Table"/>
<img alt="Updatable Widget" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/6.png" width="25%" title="Updatable Widget">
</div>

<div style="text-align: center;">
<img alt="Plex Form" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/7.png" width="25%" title="Plex Form"/>
<img alt="Drop Down Fields" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/8.png" width="25%" title="Drop Down Fields">
</div>

<div style="text-align: center;">
<img alt="Drop Down Fields" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/9.png" width="45%" title="Drop Down Fields"/>
<img alt="Navigation Menu - Theme Options" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/10.png" width="45%" title="Navigation Menu - Theme Options">
</div>

<div style="text-align: center;">
<img alt="Auto Dark Mode" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/11.png" width="70%" title="Auto Dark Mode"/>
<img alt="Auto Dark Mode" src="https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/app/12.png" width="18%" title="Auto Dark Mode">
</div>

## Features

1. Create boilerplate code for an **Application**
2. Built in login screen
3. Built in User session manager
4. Free useful widgets
5. Free useful utilities
6. Built in screens and pages
7. Builtin form builder from model class
8. Code Generation For Models i.e. `copy()` and `asString()` method generation.
9. Dependency Injection based on TAGs.
10. Support `MVVM` pattern by providing `PlexViewModel` to help reduce boilerplate code and useful features 

## Getting started

Install the `plex` in your application.

## Usage

## Widgets

1. `PlexWidget` 
   - Updatable widget and controlled by a controller. Replaces the use of BLoC or provider pattern
2. `PlexDataTable`
   - View Data in a tabular form. Sort By Any Column, Search By Any Column, Export as Excel builtin functions
2. `PlexAdvanceDataTable`
   - Modern Data Table for more feature rich experience, Export as Excel & Pdf
3. `PlexInputWidget`
   - Simple Widget to create a `TextInputField`, `DropdownField`, `DatePickerField` and `MultiSelectionFiel`
   - There are lots of features available for each field
4. `PlexFormWidget`
   - Extend any model class with `PlexForm` and `override` method `getFields()` and configure UI fields. All the form layout will be created automatically.
5. `PlexLoader`
   - Show loading anywhere in application by displaying widget `PlexLoader`
6. `PlexShimmer`
   - Show shimmer widget when data is loading by displaying widget `PlexShimmer`

#### PlexInputWidget

###### Usage

```dart
/// Input Types
/// PlexInputWidgetType.typeInput
/// PlexInputWidgetType.typeDropdown
/// PlexInputWidgetType.typeDate
/// PlexInputWidgetType.typeButton

PlexInputWidget(
    title: "Username / Email",
    
    type: PlexInputWidgetType.typeInput,
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

### Utils

#### Dimension Utilities
```dart
Dim.mini          //Dimension of 2
Dim.smallest      //Dimension of 4
Dim.small         //Dimension of 8
Dim.medium        //Dimension of 16
Dim.large         //Dimension of 32
```

#### Spacing Utilities
```dart
spaceMini()       //Widget with height width 2
spaceSmallest()   //Widget with height width 4
spaceSmall()      //Widget with height width 8
spaceMedium()     //Widget with height width 16
space(Any Double) //Widget with custom height anf width
```

#### Console Utilities
```dart
console("Your Message In Console", '(optional) enable print in release build')
```

#### Show Messages & Toast
```dart
//If Using PlexApp 
showMessage("Your Message");

// If not using PlexAp 
context.showMessage("Your Message");

//You can use following options as parameter
String message
String title,
Widget? titleWidget,
Widget? messageWidget,
MessageType type = MessageType.info,
MessageStyle style = MessageStyle.flatColored,
bool autoClose = true,
int autoCloseDurationSeconds = 5,
Alignment alignment = Alignment.bottomRight,
TextDirection textDirection = TextDirection.ltr,
bool showAnimation = false,
int animationDurationMillis = 300,
Widget? customIcon,
```

#### Widget Utilities
```dart
createWidget((){
  //Any Calculation or Custom Logic Here...
  return Container();
})
```

#### Async Utilities
```dart
//This will delay your code for 500 millis then do the work
//Usefully when you want to execute a task after navigation or when UI is still building
delay(() {
  //Your Logic Here
  return 'Any Object';
})

runAsync(() {
  //Your Logic Here will be Asynchronously run
  return "Any Object"
})
```

#### List Utilities
```dart
//List.sort() doesn't return anything so we need a extra line to sort the list og type T
//You can use this method to sort and use in one single line
List<T> result = List<T>.sortAndReturn();

//Will return a Map<Key, List<T>> by grouping the list on some condition
Map<String, List<User>> usersByCities = List<User>.groupBy((user) {
  return user.city;
});
```

#### String Utils
```dart
/// "2012-02-27"
/// "2012-02-27 13:27:00"
/// "2012-02-27 13:27:00.123456789z"
/// "2012-02-27 13:27:00,123456789z"
/// "20120227 13:27:00"
/// "20120227T132700"
/// "20120227"
/// "+20120227"
/// "2012-02-27T14Z"
/// "2012-02-27T14+00:00"
/// "-123450101 00:00:00 Z": in the year -12345.
/// "2002-02-27T14:00:00-0500"
/// "2002-02-27T19:00:00Z"

DateTime time = "2012-02-27 13:27:00".toDate();
```

#### DateTime Utilities
```dart
var dateInString = DateTime.now().toDDMMMHHmmss();
var dateInString = DateTime.now().toMMMDDYYYY();

//Convert DateTime to String in custom format
var dateInString = DateTime.now().toFormattedString("hh:mm:ss a");

// Will return the time difference in hours or minutes or in seconds 
var timeDifference = "20120227 13:27:00".toDate().getDifferenceString();
```

-------------------------------------------------------------------------------------------

### Code Generation

Update your code like below:

##### 1. Dependency
   Add Dev Dependency in the `pubspec.yaml`
```yaml
dev_dependencies:
  # Other Dev Dependencies
  build_runner: 2.4.8
  # Other Dev Dependencies
```

#### 2. Code Changes
```dart
import 'package:plex/plex_annotations/plex_annotations.dart';

/// 1. Add part file path in the file, name of the file 
///    must be same as your model class file
part 'order.plex.dart';


/// 2. Annotate the model class with [plexAnnotationModel]
@plexAnnotationModel
class Order {
  late String name;
  late String id;
  late List<String> names;
  late double amount;

  /// 3. Create an empty constructor with no argument in the model
  Order();
}
```

#### 3. Terminal Command
Run the following command in terminal of main directory of project

```commandline
flutter pub run build_runner build --delete-conflicting-outputs
```

-------------------------------------------------------------------------------------------


### Dependency Injection

You can use dependency injection as below:

##### 1. Inject Dependencies
```dart
///Test Model Class
class Model {
  int modelId;
  String modelTitle;
  
  const Model(this.modelId, this.modelTitle);
}

/// Inject Singleton Object, You can use optional tag in it also
injectSingleton(Model(1, "Singleton Model"));

/// Inject Singleton Object Lazy, You can use optional tag in it also
injectSingletonLazy((parm) => const Model(1, parm["title"]), tag: "singleton_model");

/// Inject Factory Object that will be created everytime, You can use optional tag in it also
injectFactory((parm) => Model(2, parm["title"]), tag: "factory_model");
```

##### 2. Get Dependencies
```dart
///Get the SINGLETON model like this
var singletonModel = fromPlex<Model>();

///Get the LAZY SINGLETON model like this
///With optional {parm} to be used by builder
var singletonModelLazy = fromPlex<Model>(tag: "singleton_model", parm: { "title": "Test Model"});

///Get the Factory model like this
///With optional {parm} to be used by builder 
var factoryModel = fromPlex<Model>(parm: { "title": "Test Model"});
```

------


### MVVM Usage

You can use MVVM ViewModel as below:

##### 1. Create Your Screen i.e. `HomeScreen`:
```dart

class HomeScreen extends PlexScreen {} 

class _HomeScreenState extends PlexState<HomeScreen> {
  
  showBottomSheet() {
    ///Example
    ///Show Bottom Sheet Logic Here
  }
}
```

##### 2. Create `ViewModel` Your Screen `HomeScreen`:
```dart
class HomeScreenViewModel extends PlexViewModel<HomeScreen, _HomeScreenState>{
   /// Mode All Youe Data Access Logic Here
   
   exampleFunction() {
     showLoading();
     hideLoading();
     
     toast('Your Message');
     toastDelayed('Your Message');
     
     ///state will be of type `_HomeScreenState`
     ///So you can call any function or access any field from '_HomeScreenState'
     state?.showBottomSheet();
   }
}
```

##### 3. Initialize `ViewModel` of any Screen and Use in `_HomeScreenState`

```dart
class _HomeScreenState extends PlexState<HomeScreen> {
  
  /// If using Plex Dependency Injection
  /// i.e. injectSingleton(HomeScreenViewModel());
  var viewModel = fromPlex<HomeScreenViewModel>();
  
  ///Or Simply by creating object of view model
  var viewModel = HomeScreenViewModel();
  
  initState() {
    super.initState();
    viewModel.setState(this);
  }
  
  ///Other Logic and Functions
  ///....
          
  showBottomSheet() {
    ///Example
    ///Show Bottom Sheet Logic Here
  }
}
```

------

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

  ///Setting Theme First Method : Customized Theme
  PlexTheme.appTheme = ThemeData(
     useMaterial3: true,
     colorSchemeSeed: const Color(0xFF26A9E1),
  );
  
  runApp(PlexApp(
     ///Setting Theme Second Method : Theme By Color
     // themeFromColor: const Color(0xFF26A9E1),
     ///Setting Theme Third Method : Theme By Image
     // themeFromImage: const AssetImage("assets/img.png"),
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
```
