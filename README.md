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
Deprecated compatibility wrapper around `PlexDataGrid`. Existing header/cell constructors still compile. Prefer `PlexDataGrid` for new tables — it is the table engine. Excel, PDF, and optional CSV export use `PlexPrinter`. Grouping, per-column filters, freeze (`freezeColumns` → `frozenColumnCount`), and cell editing map onto `PlexDataGrid`.
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

#### Dashboard widgets
Compact tiles for overview screens. Tokens come from `PlexThemeData`. These do **not** replace `PlexDataTable`, `PlexDataGrid`, or the reactive `PlexWidget` / `PlexWidgetController`.

```dart
PlexStatCard(label: "Orders", value: "128", delta: "+6.1%", icon: Icons.shopping_bag_outlined)
PlexStatTile(label: "On time", value: "94", unit: "%")
PlexStatGrid(children: [/* PlexStatTile … */])
PlexProgressRing(value: 72, label: "Capacity") // circular; PlexProgressBar stays horizontal

PlexWidgetCard(
  eyebrow: "Operations",
  title: "Late SKUs",
  loading: false,
  empty: false,
  child: PlexMiniTable(
    columns: [
      PlexMiniTableColumn(id: "sku", header: "Sku"),
      PlexMiniTableColumn(id: "qty", header: "Qty", numeric: true),
    ],
    rows: [["A-1042", "240"]],
  ),
)

PlexDataList(items: [PlexDataListItem(title: "WO-1042", subtitle: "Cutting", value: "240 pcs")])
PlexActivityFeed(items: [
  PlexActivityItem(id: "1", title: "Lot approved", time: DateTime.now(), body: "QA signed off"),
])
```

#### Wizard, chart, calendar
Opt-in widgets. Import `package:plex/plex_package.dart` or the files under `plex_widgets/`. Footer labels on `PlexWizard` are Back, Next, Finish. `PlexChart` types are bar, line, pie, donut, scatter, combo, heatmap. `PlexCalendar` supports month / week / day / agenda (not a `PlexFormFieldDate` replacement).

```dart
PlexWizard(steps: [
  PlexWizardStep(title: '...', child: Text('...'), subtitle: '...', optional: false, validator: () => true),
], onComplete: () {}, onStepChanged: (i) {}, axis: PlexWizardAxis.horizontal, allowStepJump: false)

PlexChart(type: PlexChartType.bar, series: [PlexChartSeries(name: 'Units', data: [1,2,3])], labels: ['A','B','C'], height: 240)

PlexCalendar(selected: DateTime(2026, 8, 15), onSelected: (d) {}, focusedMonth: DateTime(2026, 8, 1), view: PlexCalendarView.month, events: [PlexCalendarEvent(id: '1', start: DateTime(2026, 8, 15), title: 'Standup')])
```

#### Backlog 2–5 (2.0.1-beta.12)
Additive follow-up after **2.0.1-beta.11**. Existing constructors still work.

- **Wizard:** `axis: PlexWizardAxis.vertical`, `allowStepJump` (tap rail; Next still validates).
- **Chart:** `PlexChartType.donut` / `scatter` / `combo` / `heatmap`. Optional `PlexChartSeries.mark` for combo.
- **Calendar:** `PlexCalendarView`, `events`, `onEventTap`. Month cells show event dots.
- **DataGrid:** `frozenColumnCount`, `PlexDataGridColumn.editable` + `onCellEdited`, filter match `startsWith` / `greaterThan` / `lessThan`. Advance wrapper maps `freezeColumns`.
- **Kits:** `PlexLookup`, `PlexTag` / `PlexTagInput` (not `PlexBadge`), `PlexMobileList` / `PlexMobileTallyItem`, Gantt `progress` / `onTaskTap` and `typedef PlexGanttChart = PlexChartGant`.
- **Still deferred:** trellis charts, frozen rows, in-grid row mutation, xlsio replacement, recurrence/drag calendar.

#### `PlexDataGrid`
Plex-owned client-side grid. Prefer this over the deprecated `PlexAdvanceDataTable` wrapper.

**Built in:** sort, toolbar search, per-column filters (contains / equals / startsWith / greaterThan / lessThan), nested grouping, per-group summaries, frozen columns, cell editing, selection, pagination, CSV / Excel / PDF export, custom `cell` widgets, and `rowStyle` / `cellStyle`.

##### Columns and `value`

Every column needs `id`, `title`, and a `value` accessor. `value` drives sort, search, filter, grouping, summaries, and CSV / Excel / PDF. Optional `cell` only changes what is painted.

```dart
class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    required this.salary,
  });

  final int id;
  final String name;
  final String role;
  final String status;
  final double salary;
}

PlexDataGrid<Employee>(
  title: "Employees",
  rowId: (row) => row.id,
  columns: [
    PlexDataGridColumn(id: "id", title: "Id", numeric: true, value: (row) => row.id),
    PlexDataGridColumn(id: "name", title: "Name", value: (row) => row.name),
    PlexDataGridColumn(id: "role", title: "Role", value: (row) => row.role),
    PlexDataGridColumn(id: "status", title: "Status", value: (row) => row.status),
    PlexDataGridColumn(
      id: "salary",
      title: "Salary",
      numeric: true,
      value: (row) => row.salary,
    ),
  ],
  rows: employees,
)
```

##### Sort, search, and per-column filter

Header tap on a `sortable` column cycles **ascending → descending → unsorted** (single-column sort). Toolbar search (`showSearch`, default `true`) matches `searchable` columns. Set `showColumnFilters: true` for a filter row under the header. Each `filterable` column gets a contains/equals field (`PlexDataGridFilterMatch`).

```dart
PlexDataGrid<Employee>(
  title: "Employees",
  rowId: (row) => row.id,
  showSearch: true,
  showColumnFilters: true,
  onSort: (sort) {
    // sort is PlexDataGridSort? — null when unsorted
  },
  onSearch: (query) {},
  columns: [
    PlexDataGridColumn(id: "id", title: "Id", numeric: true, value: (row) => row.id),
    PlexDataGridColumn(id: "name", title: "Name", value: (row) => row.name),
    PlexDataGridColumn(
      id: "role",
      title: "Role",
      value: (row) => row.role,
      filterable: true, // default; set false to skip the filter field
    ),
  ],
  rows: employees,
)
```

##### CSV / Excel / PDF export

Flags are **opt-in on `PlexDataGrid`** (all default `false`). The deprecated `PlexAdvanceDataTable` wrapper still defaults **Excel and PDF to `true`** and CSV to `false`. Export always uses `value`, not the `cell` widget.

```dart
PlexDataGrid<Employee>(
  title: "Employees",
  rowId: (row) => row.id,
  enableCsvExport: true,
  enableExcelExport: true,
  enablePdfExport: true,
  columns: [
    PlexDataGridColumn(id: "name", title: "Name", value: (row) => row.name),
    PlexDataGridColumn(id: "salary", title: "Salary", numeric: true, value: (row) => row.salary),
  ],
  rows: employees,
)
```

##### Nested grouping

`enableGrouping: true` shows the group-by toolbar (chips plus a header action). Pass `groupByColumnIds` for nested groups — first id is the outer group. `groupByColumnId` still works as a single-column convenience when `groupByColumnIds` is omitted. `onGroupChanged` receives the full `List<String>` of grouping ids (empty list means no grouping).

```dart
PlexDataGrid<Employee>(
  title: "Employees",
  rowId: (row) => row.id,
  enableGrouping: true,
  groupByColumnIds: ["role", "status"],
  // groupByColumnId: "role", // still valid for a single grouping column
  autoExpandGroups: true,
  onGroupChanged: (List<String> columnIds) {
    // [] when the user clears grouping
  },
  columns: [
    PlexDataGridColumn(id: "name", title: "Name", value: (row) => row.name),
    PlexDataGridColumn(id: "role", title: "Role", value: (row) => row.role),
    PlexDataGridColumn(id: "status", title: "Status", value: (row) => row.status),
    PlexDataGridColumn(id: "salary", title: "Salary", numeric: true, value: (row) => row.salary),
  ],
  rows: employees,
)
```

##### Group summaries

Summaries are **on by default** (`showGroupSummaries: true`). Default cells are **row count** plus **sum** of each `numeric` column, using that group's leaf `rows` (all descendants in nested groups). Users can hide/show summaries from the toolbar. Return `null` from `groupSummary` to keep the default; supply cells to replace it. `groupSummaryBuilder` is used when `groupSummary` is null or returns null — return `null` there to keep the default widget.

```dart
PlexDataGrid<Employee>(
  title: "Employees",
  rowId: (row) => row.id,
  enableGrouping: true,
  groupByColumnIds: ["role"],
  showGroupSummaries: true,
  groupSummary: (PlexDataGridGroup<Employee> group) {
    // group.rows is every descendant leaf row in this group
    return [
      PlexDataGridSummaryCell(
        columnId: "name",
        text: "${group.rows.length} people",
      ),
    ];
  },
  columns: [
    PlexDataGridColumn(id: "name", title: "Name", value: (row) => row.name),
    PlexDataGridColumn(id: "role", title: "Role", value: (row) => row.role),
    PlexDataGridColumn(id: "salary", title: "Salary", numeric: true, value: (row) => row.salary),
  ],
  rows: employees,
)
```

##### Custom `cell` widgets

Optional `cell` replaces the default text for that column (buttons, badges, etc.). Keep `value` for sort, filter, grouping, and export.

```dart
PlexDataGridColumn<Employee>(
  id: "status",
  title: "Status",
  value: (row) => row.status, // still used for search / filter / CSV / Excel / PDF
  cell: (context, row) {
    return PlexBadge(
      label: row.status,
      tone: row.status == "Active" ? PlexBadgeTone.success : PlexBadgeTone.warning,
      dot: true,
    );
  },
),
PlexDataGridColumn<Employee>(
  id: "action",
  title: "Action",
  sortable: false,
  filterable: false,
  groupable: false,
  value: (row) => row.id,
  cell: (context, row) {
    return IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () {},
    );
  },
),
```

##### `rowStyle` vs `cellStyle`

`PlexDataGrid.rowStyle` styles every default text cell in the row. `PlexDataGridColumn.cellStyle` overlays that row style **field-by-field** (`PlexDataGridCellStyle.merge`: non-null fields on `cellStyle` win). Conditions are ordinary Dart in the callbacks. `rowStyle.backgroundColor` tints the whole row (selection color still wins when the row is selected). Custom `cell` widgets are not restyled by these text styles.

```dart
PlexDataGrid<Employee>(
  title: "Employees",
  rowId: (row) => row.id,
  rowStyle: (row) {
    if (row.status == "On leave") {
      return const PlexDataGridCellStyle(color: Color(0xFFB45309));
    }
    return null;
  },
  columns: [
    PlexDataGridColumn(id: "name", title: "Name", value: (row) => row.name),
    PlexDataGridColumn(
      id: "salary",
      title: "Salary",
      numeric: true,
      value: (row) => row.salary,
      cellStyle: (row) => row.salary < 0
          ? const PlexDataGridCellStyle(color: Color(0xFFB91C1C))
          : null,
    ),
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

#### `PlexPrinter`
Excel still uses Syncfusion xlsio. PDF is Plex-owned (no Syncfusion DataGrid).
```dart
await PlexPrinter.printExcel(title, columns, rows);
await PlexPrinter.printPdf(title, columns, rows);
final bytes = PlexPrinter.buildTablePdf(title, columns, rows);
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
  plex: 2.0.1-beta.12
```

Then run:

```sh
flutter pub get
```

The example app under `/example` is a full visual QA of Phases 0–7 plus backlog 2–5 (theme, buttons, forms, feedback, tabs, `PlexDataGrid`, dashboard widgets, wizard, chart, calendar, lookup/tags, mobile list) plus restyled feature demos. Run it with:

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

See **Widgets & Components** for IconButton, Badge, Avatar, Alert, ProgressBar, Card slots, Tabs, dashboard widgets, Wizard, Chart, Calendar, Lookup, Tags, Mobile list, DataGrid, and printer.

### What changed (2.0.1 betas) / Migration

This 2.x beta line started after pub.dev `2.0.1-beta.1`. Pin **2.0.1-beta.12**. Stable **2.0.1** follows the beta series.

Shipped: **beta.2** Phase 0 tokens · **beta.3** `.pubignore` for Interloop Design · **beta.4** Phase 1 · **beta.5** Phases 2–4 · **beta.6** `PlexDataGrid` + example redesign · **beta.7** `PlexAdvanceDataTable` wrapper · **beta.8** Phase 5c (Syncfusion grid removal) · **beta.9** DataGrid grouping, summaries, export flags, filters, and cell styles · **beta.10** Phase 6 dashboard widgets · **beta.11** Phase 7 wizard, chart, calendar · **beta.12** backlog 2–5 (wizard axis/jump, extra charts, calendar views+events, DataGrid freeze/edit/filters, lookup/tags, Gantt progress, mobile list).

**Constructors are mostly additive.** Existing required arguments did not change. New optional fields default to previous behavior.

#### Behavior and breaking changes

- **Always Material 3.** `PlexApp.forceMaterial3`, `PlexDashboardConfig.showMaterialSwitch`, and `PlexTheme.setMaterial3` still compile but are no-ops. Prefs key `UseMaterial3` is ignored.
- **Default seed** is generic Material Blue Grey 500 `#607D8B` (`PlexTheme.defaultSeedColor`). It was `#007AD7`. Override with `themeFromColor` or `PlexBrandConfig.brandPrimary`.
- **Login default** is `PlexLoginLayout.split` (brand panel + form). Pass `PlexLoginLayout.centered` to keep the historic single card. Optional copy: `brandHeadline`, `brandSubtitle`, `brandFooter`, `formTitle`, `formHint`.
- **Glass is opt-in.** Default chrome is flat. Set `useBackground: true` on login/dashboard, or wrap with `PlexCardGlassEffect`.
- **Tables:** prefer `PlexDataGrid` for new work. `PlexAdvanceDataTable` is `@Deprecated('Use PlexDataGrid')` and wraps the grid. Keep `PlexDataTable` / `PlexDataTableWithPages` where you already use them.
- **Phase 5c (2.0.1-beta.8) type and dependency breaks:**
  - Package no longer depends on `syncfusion_flutter_datagrid` or `syncfusion_flutter_datagrid_export`.
  - `PlexDataTableValueCell` no longer extends Syncfusion `DataGridCell`. Public fields still match the historic constructor (`columnName`, `value`, `numberField`, custom widget).
  - `customGroupingSummary` is now `(String columnName, List<PlexDataTableValueCell> row, List<List<PlexDataTableValueCell>> rows)?` — not Syncfusion `DataGridRow`.
  - PDF export uses `PlexPrinter.printPdf` / `buildTablePdf` (Plex-owned table PDF). Excel still uses `syncfusion_flutter_xlsio` via `PlexPrinter.printExcel`. CSV uses `PlexPrinter.buildCsv` / `printCsv`.
  - `CustomColumnSizer` is a deprecated no-op (column sizing is handled by `PlexDataGrid`).
  - Grouping and per-column filters on `PlexAdvanceDataTable` now map onto `PlexDataGrid`. Freeze and cell editing still compile but are not mapped (mapped in **2.0.1-beta.12**).
- **Phase 5d (2.0.1-beta.9) `PlexDataGrid` features:**
  - Nested grouping via `groupByColumnIds` (`groupByColumnId` still works). `enableGrouping` shows the toolbar UI; `onGroupChanged` is `List<String>`.
  - Per-group summaries default to count plus numeric sums; hide from the toolbar (`showGroupSummaries`). Override with `groupSummary` / `groupSummaryBuilder` (`group.rows` is all descendant leaf rows).
  - Toolbar search plus `showColumnFilters` (contains/equals per `filterable` column).
  - Opt-in `enableCsvExport` / `enableExcelExport` / `enablePdfExport` on the grid (all default `false`). Advance still defaults Excel/PDF to `true`.
  - Custom column widgets via `PlexDataGridColumn.cell`; keep `value` for export.
  - `rowStyle` and `cellStyle` (`PlexDataGridCellStyle`); `cellStyle` overlays `rowStyle` field-by-field.
- **Phase 6 (2.0.1-beta.10) dashboard widgets** (additive): `PlexStatCard`, `PlexStatTile`, `PlexStatGrid`, `PlexProgressRing`, `PlexWidgetCard`, `PlexMiniTable`, `PlexDataList`, `PlexActivityFeed`. They do not replace `PlexDataGrid`, `PlexDataTable`, or reactive `PlexWidget`.
- **Phase 7 (2.0.1-beta.11) wizard, chart, calendar** (additive): `PlexWizard` / `PlexWizardStep`, `PlexChart` (bar / line / pie), `PlexCalendar` (month view). They do not replace login, `PlexTabs`, `PlexChartGant`, or `PlexFormFieldDate`.
- **Backlog 2–5 (2.0.1-beta.12)** (additive): wizard vertical / jump, extra chart types, calendar views + events, DataGrid freeze / edit / extra filters, `PlexLookup` / `PlexTag` / `PlexMobileList`, Gantt progress. They do not replace `PlexBadge`, `PlexFormFieldDate`, or existing Gantt call sites (`PlexGanttChart` is a typedef).
- **Interloop Design** stays in git as a reference folder. It is **not** in the published package (`.pubignore`). Do not treat it as a runtime dependency.

#### Additive by phase

| Phase | Release | What landed |
| --- | --- | --- |
| **0** | beta.2 | `PlexThemeData` ThemeExtension, optional `PlexBrandConfig` on `PlexApp` (brand colors, `fontFamily`, `PlexDensity`). Logos stay on `PlexAppInfo`. Tokens; always M3. |
| **1** | beta.4 | Restyled `PlexFormFieldButton`; `PlexButtonType.ink` / `danger`; optional `size` (`PlexButtonSize`), `loading`, `expanded`, `buttonTrailingIcon`. New `PlexIconButton`, `PlexBadge`, `PlexAvatar`. |
| **2** | beta.5 | Token-wired `PlexFormFieldInput`, date, dropdown, multi-select, autocomplete. New `PlexFormFieldCheckbox`, `PlexFormFieldSwitch`. |
| **3** | beta.5 | Optional `PlexCard` slots (`title`, `subtitle`, `actions`, `footer`, `hover`, `flush`). New `PlexAlert`, `PlexProgressBar`, `PlexSkeleton`. Token-tinted dialogs/sheets/toasts. |
| **4** | beta.5 | Split login default; `PlexAppBar` 64px (`PlexLayout.topbarHeight`); rail 90/260 (`PlexLayout.railCollapsed` / `railExpanded`). New `PlexTabs` / `PlexTabPanel`. |
| **5a** | beta.6 | `PlexDataGrid` — client-side sort, search, selection (`none` / `single` / `multiple`), pagination, density. |
| **5b** | beta.7 | `PlexAdvanceDataTable` deprecated wrapper around `PlexDataGrid`; old `PlexDataTableHeaderCell` / `PlexDataTableValueCell` API. |
| **5c** | beta.8 | Remove Syncfusion DataGrid packages; Plex-owned PDF; cell type and grouping-callback breaks above. |
| **5d** | beta.9 | Nested grouping, group summaries, column filters, export flags, custom `cell`, `rowStyle` / `cellStyle`. |
| **6** | beta.10 | Dashboard widgets: `PlexStatCard` / `PlexStatTile` / `PlexStatGrid` / `PlexProgressRing`, `PlexWidgetCard`, `PlexMiniTable`, `PlexDataList`, `PlexActivityFeed`. |
| **7** | beta.11 | `PlexWizard` / `PlexWizardStep`, `PlexChart` (bar / line / pie), `PlexCalendar` month view. |
| **7+** | beta.12 | Wizard vertical / jump, extra charts, calendar views + events, DataGrid freeze / edit / filters, lookup / tags / mobile list, Gantt progress. |

`brandConfig` is optional on `PlexApp`. Omit it to keep seed-only theming.

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
