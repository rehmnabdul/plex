# PLEX: Enterprise-Grade Flutter UI Framework

<table>
  <tr>
    <td align="center" valign="top">
      <img src="https://avatars.githubusercontent.com/u/17247881?v=4" width="120" style="border-radius:50%" alt="Abdur Rahman"/>
      <br/>
      <b>Abdur Rahman</b><br/>
      <a href="https://github.com/rehmnabdul">GitHub</a> |
      <a href="https://www.linkedin.com/in/rehmnabdul/">LinkedIn</a> |
      <a href="https://abdurrahman.pk/">Portfolio</a>
    </td>
  </tr>
</table>

PLEX is a powerful, open-source UI framework for Flutter, designed to accelerate the development of enterprise applications. With a focus on scalability, maintainability, and developer productivity, PLEX provides a robust foundation, modern UI components, and best practices for building high-quality business apps.

---

## ✨ Features

- **Enterprise Boilerplate**: Rapidly scaffold production-ready apps with built-in routing, theming, and screen management.
- **Modern UI Widgets**: Rich set of customizable widgets—advanced tables, forms, loaders, shimmers, and more.
- **MVVM Architecture**: Built-in support for Model-View-ViewModel, reducing boilerplate and improving testability.
- **Dependency Injection**: Simple, tag-based DI for managing app-wide and feature-specific dependencies.
- **User Management**: Integrated login screens, session handling, and user models.
- **SignalR Integration**: Native support for real-time communication using Microsoft SignalR.
- **Persistent Storage**: Easy-to-use local storage utilities for app data and user preferences.
- **Material 2 & 3, Light & Dark Modes**: Effortlessly switch between Material versions and color schemes.
- **Code Generation**: Annotation-based model enhancements (e.g., `copy()`, `asString()` methods).
- **Extensible & Customizable**: Designed for flexibility—override, extend, and adapt to your needs.

---

## 🧩 Widgets & Components

PLEX offers a comprehensive suite of widgets and utilities for enterprise Flutter development. Below are the most important components, with usage examples:

### Data Tables

#### `PlexDataTable`
A powerful, customizable data table with sorting, searching, and export features.
```dart
PlexDataTable(
  columns: [PlexDataCell.text("ID"), PlexDataCell.text("Name")],
  rows: [
    [PlexDataCell.text("1"), PlexDataCell.text("Alice")],
    [PlexDataCell.text("2"), PlexDataCell.text("Bob")],
  ],
  enableSearch: true,
  enablePrint: true,
)
```

#### `PlexAdvDataTable`
A modern, feature-rich data table with advanced export (Excel, PDF) and pagination.
```dart
PlexAdvDataTable(
  columns: [PlexDataCell.text("ID"), PlexDataCell.text("Name")],
  rows: [
    [PlexDataCell.text("1"), PlexDataCell.text("Alice")],
    [PlexDataCell.text("2"), PlexDataCell.text("Bob")],
  ],
  enableExportExcel: true,
  enableExportPdf: true,
)
```

#### `PlexDataTableWithPages`
Paginated data table for large datasets.
```dart
PlexDataTableWithPages(
  columns: [PlexDataCell.text("ID"), PlexDataCell.text("Name")],
  rows: [...],
)
```

---

### Forms & Inputs

#### `PlexFormWidget` & `PlexFormField`
Rapidly build forms from your model classes.
```dart
class User with PlexForm {
  String name = '';
  int age = 0;
  @override
  List<PlexFormField> getFields(State context) => [
    PlexFormField.input(title: "Name", type: String, onChange: (v) => name = v),
    PlexFormField.input(title: "Age", type: int, onChange: (v) => age = v),
  ];
}
// Usage:
PlexFormWidget<User>(form: User(), onSubmit: (user) => print(user.name))
```

#### Specialized Form Fields
- **Input**: `PlexFormFieldInput`
- **Date/Time**: `PlexFormFieldDate` (supports date, time, datetime)
- **Dropdown**: `PlexFormFieldDropdown`
- **Multi-Select**: `PlexFormFieldMultiSelect`
- **Autocomplete**: `PlexFormFieldAutoComplete`
- **Button**: `PlexFormFieldButton`

Example:
```dart
PlexFormFieldInput(
  properties: PlexFormFieldGeneric(title: "Username"),
  inputController: TextEditingController(),
)
PlexFormFieldDate(type: PlexFormFieldDateType.typeDate)
PlexFormFieldDropdown(dropdownItems: ["A", "B", "C"])
PlexFormFieldMultiSelect(dropdownItems: ["A", "B", "C"])
PlexFormFieldAutoComplete(autoCompleteItems: (query) async => ["A", "B", "C"])
PlexFormFieldButton(properties: PlexFormFieldGeneric(title: "Submit"), buttonClick: () {})
```

#### `PlexInputWidget` (Legacy)
A flexible input widget supporting text, dropdown, date, and multi-select. (Prefer the new form fields above.)

---

### Layout & Navigation

#### `PlexNavigationRail`
A customizable navigation rail for side navigation in desktop/tablet layouts.
```dart
PlexNavigationRail(
  destinations: [
    PlexRoute(route: "/home", title: "Home", screen: (context) => HomeScreen()),
    PlexRoute(route: "/settings", title: "Settings", screen: (context) => SettingsScreen()),
  ],
  selectedDestination: 0,
  onSelectDestination: (index) {},
)
```

#### `PlexCard` & `PlexCardGlass`
Material and glassmorphic card widgets for modern UIs.
```dart
PlexCard(child: Text("Standard Card"))
PlexCardGlass(child: Text("Glass Card"))
```

#### `PlexMenu`
Model for menu items with icon and title.
```dart
PlexMenu("Dashboard", icon: Icon(Icons.dashboard))
```

---

### Loading, Feedback & Effects

#### `PlexLoaderV1` / `PlexLoaderV2`
Show loading indicators (two styles).
```dart
PlexLoaderV1()
PlexLoaderV2()
```

#### `PlexShimmer`
Show shimmer effect while loading data.
```dart
PlexShimmer(child: Container(width: 200, height: 20))
```

#### `PlexInfoSheet`
Highly configurable bottom sheet for info, errors, alerts, etc.
```dart
PlexInfoSheet.show(
  context,
  title: "Info",
  message: "This is an info sheet.",
  type: PlexInfoSheetType.info,
)
```

#### `PlexSelectionList`
Show a searchable, selectable list in a modal.
```dart
showPlexSelectionList(
  context,
  items: ["A", "B", "C"],
  itemText: (item) => item,
  onSelect: (item) => print(item),
)
```

#### `PlexHighlightWidget`
Highlight a widget with animation.
```dart
PlexHighlightWidget(child: Text("Highlight Me!"))
```

---

### State Management & Reactivity

#### `PlexWidget` & `PlexWidgetController`
A reactive widget that can be updated via a controller, replacing BLoC/provider for simple cases.
```dart
final controller = PlexWidgetController();
PlexWidget(controller: controller, createWidget: (context, data) => Text("Current value: $data"))
```

#### `PlexRx` & `PlexRxWidget`
Simple observable/reactive state management.
```dart
final count = 0.plexObs;
Text("Count: ").plexRxWidget(count)
```

---

### Utilities & Helpers

#### Spacing & Dimensions
```dart
spaceMini() // Widget with 2px
spaceSmall() // Widget with 8px
spaceMedium() // Widget with 16px
PlexDim.large // 32.0
```

#### Console & Async
```dart
console("Debug message")
delay(() => print("Delayed"), delayMillis: 500)
runAsync(() => print("Async"))
```

#### Platform & Screen Size
```dart
isLargeScreen(context)
isMediumScreen(context)
isSmallScreen(context)
```

#### Date & String Utilities
```dart
DateTime.now().toDDMMMHHmmss()
"2012-02-27 13:27:00".toDate()
```

#### Grouping & Sorting
```dart
List<T>.sortAndReturn()
List<T>.groupBy((item) => key)
```

---

### Other Widgets

#### `PlexScanner`
Barcode/QR code scanner widget.
```dart
PlexScanner()
```

---

### Real-Time & Networking

#### `PlexSignalR`
Real-time communication using SignalR.
```dart
PlexSignalR.config = PlexSignalRConfig(
  "https://serverurl:port", "hubPath",
  remoteMethods: [PlexSignalRMethod("OnEvent", (args) => print(args))],
);
await PlexSignalR.instance.start();
```

---

## 📸 Screenshots

| Material 3 Light | Material 3 Dark | Material 2 Light | Material 2 Dark |
|:---:|:---:|:---:|:---:|
| ![M3 Light](https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_2.png) | ![M3 Dark](https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_4.png) | ![M2 Light](https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_1.png) | ![M2 Dark](https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_3.png) |

More examples in the `/screenshots` folder.

---

## 🚀 Getting Started

Add PLEX to your `pubspec.yaml`:

```yaml
dependencies:
  plex: ^<latest_version>
```

Then run:

```sh
flutter pub get
```

---

## 🛠️ Usage

### Quick App Scaffold

```dart
import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';

void main() {
  runApp(PlexApp(
    appInfo: PlexAppInfo(
      title: "My Enterprise App",
      appLogo: Icon(Icons.business),
      initialRoute: "/dashboard",
    ),
    dashboardConfig: PlexDashboardConfig(
      dashboardScreens: [
        // Define your screens here
      ],
    ),
  ));
}
```

### Advanced Data Table

```dart
PlexDataTable(
  columns: [PlexDataCell.text("ID"), PlexDataCell.text("Name")],
  rows: [
    [PlexDataCell.text("1"), PlexDataCell.text("Alice")],
    [PlexDataCell.text("2"), PlexDataCell.text("Bob")],
  ],
)
```

### Form Builder from Model

```dart
class Order with PlexForm {
  late String id;
  late double amount;
  Order();
  @override
  List<PlexFormField> getFields(State context) => [
    PlexFormField.input(title: "ID", type: String, onChange: (v) => id = v),
    PlexFormField.input(title: "Amount", type: double, onChange: (v) => amount = v),
  ];
}
```

### MVVM ViewModel Example

```dart
class HomeScreenViewModel extends PlexViewModel<HomeScreen, _HomeScreenState> {
  void fetchData() {
    showLoading();
    // Fetch data logic
    hideLoading();
  }
}
```

### Dependency Injection

```dart
injectSingleton(MyService());
final service = fromPlex<MyService>();
```

### SignalR Real-Time Integration

```dart
PlexSignalR.config = PlexSignalRConfig(
  "https://serverurl:port", "hubPath",
  remoteMethods: [PlexSignalRMethod("OnEvent", (args) => print(args))],
);
await PlexSignalR.instance.start();
```

---

## 🏗️ Architecture & Extensibility

- **MVVM Pattern**: Clean separation of UI and business logic.
- **Customizable Themes**: Use your own color schemes, images, or Material versions.
- **Flexible Routing**: Define routes and navigation with ease.
- **Widget Extensibility**: All core widgets are designed for extension and override.

---

## 🤝 Contributing

PLEX is open source and welcomes contributions! To get started:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Submit a pull request

Please see the `CONTRIBUTING.md` (if available) for guidelines.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**PLEX** is built with ❤️ for the Flutter community. For questions, issues, or feature requests, please open an issue on GitHub.
