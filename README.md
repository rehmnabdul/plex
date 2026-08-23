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
- **Networking Utilities**: Built-in HTTP client with `PlexNetworking` / `PlexCalls` for JSON APIs, file downloads to disk, and in-memory binary downloads.
- **Persistent Storage**: Easy-to-use local storage utilities for app data and user preferences.
- **Material 3, Light & Dark Modes**: Theme is always Material 3. Switch brightness from the dashboard; Material 2 flags are deprecated no-ops.
- **Design tokens**: `PlexBrandConfig`, `themeFromColor`, and `PlexThemeData.of(context)` for brand, density, and semantic colors.
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

#### `PlexAdvanceDataTable`
Deprecated compatibility wrapper around `PlexDataGrid`. Existing header/cell constructors still compile. Prefer `PlexDataGrid` for new tables. Excel export uses `PlexPrinter`; PDF export still uses a hidden Syncfusion `SfDataGrid`. Grouping, freeze, and cell editing are not mapped.
```dart
PlexAdvanceDataTable(
  title: "Employees",
  columns: [
    PlexDataTableHeaderCell.text("ID"),
    PlexDataTableHeaderCell.text("Name"),
  ],
  controller: PlexWidgetController(data: rows),
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
PlexFormWidget<User>(entity: User(), onSubmit: (user) => print(user.name))
```

#### Specialized Form Fields
- **Input**: `PlexFormFieldInput`
- **Date/Time**: `PlexFormFieldDate` (supports date, time, datetime)
- **Dropdown**: `PlexFormFieldDropdown`
- **Multi-Select**: `PlexFormFieldMultiSelect`
- **Autocomplete**: `PlexFormFieldAutoComplete`
- **Button**: `PlexFormFieldButton` (`PlexButtonType`: elevated, text, outlined, filled, filledTonal, ink, danger)
- **Checkbox**: `PlexFormFieldCheckbox`
- **Switch**: `PlexFormFieldSwitch`

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
PlexFormFieldCheckbox(
  properties: PlexFormFieldGeneric(title: "Accept terms"),
  value: true,
  onChanged: (value) {},
)
PlexFormFieldSwitch(
  properties: PlexFormFieldGeneric(title: "Email notifications"),
  value: true,
  onChanged: (value) {},
)
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

#### `PlexCard` & `PlexCardGlassEffect`
Material card with optional header slots. Glass is opt-in; default chrome is flat.
```dart
PlexCard(
  title: "Inventory",
  subtitle: "Optional header slots",
  footer: Text("Footer"),
  child: Text("Body"),
)
PlexCardGlassEffect(child: Text("Glass card"))
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

#### `PlexShimmer` & `PlexSkeleton`
Show shimmer effect while loading data. `PlexSkeleton` is a placeholder that reuses shimmer.
```dart
PlexShimmer(child: Container(width: 200, height: 20))
PlexSkeleton.line()
PlexSkeleton.circle(size: 32)
```

#### `PlexIconButton`
Square icon-only button for toolbars and row actions.
```dart
PlexIconButton(
  icon: Icon(Icons.filter_list),
  variant: PlexIconButtonVariant.outline,
  label: "Filter",
  onPressed: () {},
)
```

#### `PlexBadge`
Compact status or category label.
```dart
PlexBadge(label: "Neutral")
PlexBadge(label: "Info", tone: PlexBadgeTone.info, dot: true)
PlexBadge(label: "Danger", tone: PlexBadgeTone.danger, appearance: PlexBadgeAppearance.solid)
```

#### `PlexAvatar`
Initials or image avatar with optional presence.
```dart
PlexAvatar(name: "Ada Lovelace")
PlexAvatar(name: "Grace Hopper", size: 32, square: true, status: PlexAvatarStatus.online)
```

#### `PlexAlert`
Inline contextual banner (not a modal). Use `PlexInfoSheet` for sheets.
```dart
PlexAlert(
  variant: PlexAlertVariant.info,
  title: "Inline banner",
  message: "Dismissible alert using semantic tokens.",
  onClose: () {},
)
```

#### `PlexProgressBar`
Determinate or indeterminate progress.
```dart
PlexProgressBar(label: "Sync", value: 64, showValue: true)
PlexProgressBar(label: "Working", indeterminate: true)
```

#### `PlexTabs`
Body-level tab strip. Does not replace `PlexScreen.getTabBar()`.
```dart
PlexTabs(
  tabs: [Tab(text: "Overview"), Tab(text: "Activity")],
  children: [
    PlexTabPanel(child: Text("Overview")),
    PlexTabPanel(child: Text("Activity")),
  ],
)
```

#### `PlexDataGrid`
Plex-owned client-side grid (sort, search, selection, pagination). Prefer this over the deprecated `PlexAdvanceDataTable` wrapper.
```dart
PlexDataGrid<Employee>(
  title: "Employees",
  selectionMode: PlexDataGridSelectionMode.multiple,
  pageSize: 10,
  rowId: (row) => row.id,
  columns: [
    PlexDataGridColumn(id: "id", title: "Id", numeric: true, value: (row) => row.id),
    PlexDataGridColumn(id: "name", title: "Name", value: (row) => row.name),
  ],
  rows: employees,
)
```

#### `PlexAppBar`
Drop-in `PreferredSizeWidget` used by the dashboard chrome. You can also use it on stacked / external routes.
```dart
Scaffold(
  appBar: PlexAppBar(title: Text("External Screen")),
  body: child,
)
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

#### `PlexNetworking` & `PlexCalls`
HTTP utilities for API calls, file downloads, and binary responses.

**JSON GET/POST** via `PlexCalls`:
```dart
PlexCalls.instance.setBaseUrl('https://api.example.com');
PlexCalls.instance.setHeadersCallback(() async => {'Authorization': 'Bearer token'});

final result = await PlexCalls.instance.get(
  '/api/users',
  queryParams: {'page': 1},
);
if (result.success) {
  final data = result.data; // decoded JSON or string
}
```

**Download file to app documents directory** (with progress callback):
```dart
PlexNetworking.instance.downloadFile(
  '/api/files/report.pdf',
  filename: 'report.pdf',
  onProgressUpdate: (downloaded, percentage, file) {
    if (file != null) {
      // download complete — file saved under app documents
    }
  },
);
```

**Download binary content into memory** (e.g. PDF, Excel, images) without writing to disk:
```dart
import 'dart:typed_data';

final result = await PlexCalls.instance.downloadBytes(
  '/api/v1/DigitalMta/GetMtaFromHms',
  queryParams: {
    'batchNo': batchNo,
    'yearCode': yearCode,
    'update': false,
  },
);

if (result.success) {
  final bytes = result.data as Uint8List;
  // use bytes directly — display, parse, or open in memory
}
```

Use `PlexNetworking.instance.downloadBytes(...)` directly if you prefer `PlexSuccess` / `PlexError` instead of `PlexApiResult`.

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

Theme is always Material 3. Light and dark still apply:

| Light | Dark |
|:---:|:---:|
| ![Light](https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_2.png) | ![Dark](https://raw.githubusercontent.com/rehmnabdul/plex/main/screenshots/img_4.png) |

More examples in the `/screenshots` folder.

---

## 🚀 Getting Started

Add PLEX to your `pubspec.yaml`:

```yaml
dependencies:
  plex: 2.0.1-beta.7
```

Then run:

```sh
flutter pub get
```

The example app under `/example` is a full visual QA of Phases 0–5b (theme, buttons, forms, feedback, tabs, data grid) plus restyled feature demos. Run it with:

```sh
cd example
flutter run
```

---

## 🛠️ Usage

### `PlexApp` + `PlexAppInfo` logos

Logos live on `PlexAppInfo`, not on `PlexBrandConfig`.

```dart
import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_theme.dart';

void main() {
  runApp(PlexApp(
    themeFromColor: PlexTheme.defaultSeedColor, // #607D8B
    brandConfig: const PlexBrandConfig(
      density: PlexDensity.comfortable,
    ),
    appInfo: PlexAppInfo(
      title: "Plex Example",
      appLogo: Image.asset("assets/app.png"),
      appLogoDark: Image.asset("assets/app.png"),
      initialRoute: "/home",
      versionCode: 1,
      versionName: "v1.0.0",
    ),
    useAuthorization: true,
    loginConfig: PlexLoginConfig(
      layout: PlexLoginLayout.split, // package default
      onLogin: (context, email, password) async { /* return PlexUser */ },
      userFromJson: (json) { /* hydrate PlexUser */ },
    ),
    dashboardConfig: PlexDashboardConfig(
      useBackground: false, // glass is opt-in; default chrome is flat
      dashboardScreens: [
        PlexRoute(
          route: "/home",
          category: "Overview",
          title: "Home",
          screen: (context, {data}) => const HomeScreen(),
        ),
      ],
    ),
  ));
}
```

### Theme: `PlexBrandConfig`, `themeFromColor`, `PlexTheme.appTextTheme`

Resolution order for colors: widget-level → `PlexBrandConfig` → ColorScheme / seed → generic fallbacks. Default seed is Material Blue Grey 500 (`#607D8B`).

```dart
runApp(PlexApp(
  themeFromColor: const Color(0xFF607D8B),
  brandConfig: const PlexBrandConfig(
    // All fields optional. Null means "use seed / fallbacks".
    brandPrimary: null,
    brandInk: null,
    success: null,
    warning: null,
    danger: null,
    info: null,
    fontFamily: null, // package default is Roboto
    density: PlexDensity.comfortable, // or PlexDensity.compact
  ),
  appInfo: PlexAppInfo(
    title: "My App",
    appLogo: Icon(Icons.business),
    initialRoute: "/home",
  ),
  dashboardConfig: PlexDashboardConfig(dashboardScreens: [...]),
));

// Optional: override typography after init. Wins over brandConfig.fontFamily.
PlexTheme.appTextTheme = GoogleFonts.outfitTextTheme();
```

Use `themeFromImage` instead of `themeFromColor` if you want a scheme extracted from an image. Do not set both.

### Theme extension lookup

```dart
final plex = PlexThemeData.of(context);
final Color page = plex.colors.surfacePage;
final Color brand = plex.colors.brandPrimary;
final PlexDensity density = plex.density;
```

`PlexThemeData.of` never returns null — missing extension yields generic fallbacks.

### Login layout

`PlexLoginLayout.split` is the package default (brand panel + form). Pass `centered` for the historic single card.

```dart
PlexLoginConfig(
  layout: PlexLoginLayout.split,
  brandHeadline: "Plex Example",
  brandSubtitle: "Enterprise UI kit for Flutter",
  formTitle: "Sign in",
  formHint: "Use your workspace credentials.",
  onLogin: (context, email, password) async => user,
  userFromJson: (json) => userFrom(json),
)

// Historic centered card:
PlexLoginConfig(
  layout: PlexLoginLayout.centered,
  onLogin: ...,
  userFromJson: ...,
)
```

Set `useBackground: true` on login or dashboard only if you want glass / `PlexBackground`. Default chrome is flat.

### Always Material 3

Theme is always Material 3. These flags still compile but do nothing:

- `PlexApp.forceMaterial3`
- `PlexDashboardConfig.showMaterialSwitch`
- `PlexTheme.setMaterial3(bool)`

### Buttons

```dart
PlexFormFieldButton(
  properties: PlexFormFieldGeneric(title: "Save", useMargin: false),
  buttonType: PlexButtonType.filled, // elevated, text, outlined, filledTonal, ink, danger
  buttonIcon: Icon(Icons.check),
  loading: false,
  buttonClick: () {},
)
```

See **Widgets & Components** below for IconButton, Badge, Avatar, Alert, ProgressBar, Card slots, Tabs, and DataGrid.

### Migration notes

- **Constructors**: no required-argument changes for existing widgets.
- **`brandConfig`**: optional on `PlexApp`. Omit it to keep seed-only theming.
- **Login**: split layout is the new default. Pass `PlexLoginLayout.centered` to keep the old card.
- **Default seed**: `#607D8B` (`PlexTheme.defaultSeedColor`). Override with `themeFromColor` or `PlexBrandConfig.brandPrimary`.
- **Material 2**: removed. M2 flags are no-ops.
- **`PlexDataGrid`**: prefer for new tables. `PlexAdvanceDataTable` is a deprecated wrapper; keep `PlexDataTable` where you already use it.

---

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
        PlexRoute(
          route: "/dashboard",
          title: "Dashboard",
          screen: (context, {data}) => const DashboardScreen(),
        ),
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
- **Customizable Themes**: `themeFromColor` / `PlexBrandConfig`, light and dark, always Material 3.
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
