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

## 📑 Table of Contents

- [Features](#-features)
- [Widgets & Components](#-widgets--components) — Data Tables, Charts, Dashboard, Timeline, Calendar, Rich Text, Backgrounds, Forms
- [Layout & Navigation](#layout--navigation) — Navigation Rail, Cards, Backgrounds, Routing, Guards
- [Loading & Feedback](#loading-feedback--effects)
- [State Management](#state-management--reactivity)
- [Utilities](#utilities--helpers)
- [Networking & API](#networking--api)
- [Data Storage](#data-storage) — PlexSp, PlexDb, Query Builder, Migrations, Relations, Encryption
- [Dependency Injection](#dependency-injection)
- [Getting Started](#-getting-started)
- [Usage Examples](#-usage)

---

## ✨ Features

- **Enterprise Boilerplate**: Rapidly scaffold production-ready apps with built-in routing, theming, and screen management.
- **Navigation Modernization (v1.5.x)**: Pluggable router (GetX or GoRouter), route guards, parameterized paths, and deep linking.
- **UI & Widget Expansion (v1.7.x)**: Charts (bar, line, pie, donut, sparkline), dashboard cards, timeline, calendar, rich text editor, form improvements (conditional fields, validator, wizard, stepper, color, file), and unified data table API.
- **Modern UI Widgets**: Rich set of customizable widgets—advanced tables, forms, loaders, shimmers, and more.
- **MVVM Architecture**: Built-in support for Model-View-ViewModel with `PlexAsyncAction` for zero-boilerplate async operations.
- **Dependency Injection**: Tag-based DI with scoped lifetimes, circular dependency detection, async lazy init, and `PlexDisposable` cleanup.
- **User Management**: Integrated login screens, session handling, and user models.
- **SignalR Integration**: Native support for real-time communication using Microsoft SignalR.
- **Persistent Storage**: Easy-to-use local storage (PlexSp, PlexDb/Sembast) for app data and user preferences.
- **Database Enhancements (v1.8.x)**: Fluent query builder, relations (hasMany/belongsTo), migrations, reactive streams, and optional AES-256 encryption at rest.
- **Networking**: Full-featured HTTP client with interceptors, timeouts, cancellation, response caching, and type-safe parsing.
- **Structured Logging**: `PlexLogger` with configurable levels, release-mode suppression, and optional remote sinks.
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

#### `PlexDataTableUnified` (v1.7.x)
Unified API for list, paginated, and stream-based data sources. Delegates to existing table widgets.
```dart
// In-memory list
PlexDataTableUnified(
  source: PlexTableSource.list(rows),
  columns: [PlexDataCell.text("ID"), PlexDataCell.text("Name")],
  features: PlexTableFeatures(search: true, print: true),
)

// Paginated (async fetch per page)
PlexDataTableUnified(
  source: PlexTableSource.paginated((page) => api.fetchPage(page)),
  columns: [...],
)

// Stream (reactive updates)
PlexDataTableUnified(
  source: PlexTableSource.stream(dataStream),
  columns: [...],
)
```

| PlexTableSource | Description |
|-----------------|--------------|
| `PlexTableSource.list(rows)` | In-memory list of rows |
| `PlexTableSource.paginated(fetchFn)` | Async fetch per page |
| `PlexTableSource.stream(stream)` | Reactive stream of row lists |

| PlexTableFeatures | Description |
|-------------------|-------------|
| `search` | Enable search |
| `export` | List of `PlexExportFormat` (xlsx, pdf) |
| `groupBy` | Enable grouping |
| `editing` | Enable cell editing |
| `print` | Enable print |

| PlexExportFormat | Description |
|------------------|-------------|
| `PlexExportFormat.xlsx` | Export to Excel |
| `PlexExportFormat.pdf` | Export to PDF |

---

### Charts & Data Visualization (v1.7.x)

All chart widgets use `syncfusion_flutter_charts` with theme-aware defaults.

#### `PlexBarChart`
Vertical or horizontal bar chart with optional stacking. Built on `syncfusion_flutter_charts`.

```dart
PlexBarChart(
  title: 'Revenue',
  series: [
    PlexBarSeries(name: 'Q1', data: [('Jan', 1200.0), ('Feb', 980.0)], color: Colors.blue),
    PlexBarSeries(name: 'Q2', data: [('Jan', 1400.0), ('Feb', 1100.0)], color: Colors.green),
  ],
  orientation: PlexBarOrientation.vertical,
  stacked: false,
)
```

| PlexBarSeries | Description |
|---------------|-------------|
| `name` | Series label |
| `data` | `List<(String, double)>` — (category, value) pairs |
| `color` | Bar color |

#### `PlexLineChart`
Line chart with optional area fill. Uses SplineSeries / SplineAreaSeries.

```dart
PlexLineChart(
  title: 'Users',
  series: [
    PlexLineSeries(name: 'Active', data: [(DateTime.now(), 400.0)]),
  ],
  showArea: false,
)
```

| PlexLineSeries | Description |
|----------------|-------------|
| `name` | Series label |
| `data` | `List<(DateTime, double)>` — (x, y) pairs |

#### `PlexPieChart` & `PlexDonutChart`
Pie and donut charts for proportional data.

```dart
PlexPieChart(
  title: 'Share',
  data: [PlexPieSegment('A', 40), PlexPieSegment('B', 60)],
)
PlexDonutChart(title: 'Share', data: [...])
```

| PlexPieSegment | Description |
|----------------|-------------|
| `label` | Segment label |
| `value` | Numeric value (proportional) |

#### `PlexSparkline`
Compact inline chart for KPI cards. Uses `CustomPainter` (no Syncfusion dependency).
```dart
PlexSparkline(
  data: [10.0, 14.0, 12.0, 18.0, 22.0],
  width: 80,
  height: 32,
)
```

#### `PlexChartGant`
Hour-level Gantt chart for task scheduling.
```dart
PlexChartGant(
  tasks: [
    GantTask(name: 'Task 1', start: DateTime.now(), end: DateTime.now().add(Duration(hours: 2))),
  ],
)
```

---

### Dashboard & KPI (v1.7.x)

#### `PlexDashboardCard`
KPI card with optional trend indicator and sparkline. Uses `PlexCard` internally.

```dart
PlexDashboardCard(
  title: 'Revenue',
  value: '\$12,450',
  subtitle: 'vs last month',
  trend: 12.4,
  icon: Icon(Icons.trending_up),
  chart: PlexSparkline(data: [10, 14, 12, 18, 22]),
  onTap: () {},
)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String` | Card title |
| `value` | `String` | Main value (e.g. KPI) |
| `subtitle` | `String?` | Optional subtitle |
| `trend` | `double?` | Positive = green up-arrow, negative = red down-arrow |
| `icon` | `Widget?` | Leading icon |
| `chart` | `Widget?` | Typically `PlexSparkline` |
| `onTap` | `VoidCallback?` | Tap handler |
| `color` | `Color?` | Optional accent color |

#### `PlexDashboardGrid`
Responsive grid of dashboard cards. Uses `LayoutBuilder` for responsive column count (2 small, 3 medium, 4 large screens).

```dart
PlexDashboardGrid(
  cards: [
    PlexDashboardCard(title: 'Users', value: '1,234'),
    PlexDashboardCard(title: 'Orders', value: '56', trend: -3.2),
  ],
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
)
```

| Parameter | Description |
|-----------|-------------|
| `cards` | `List<PlexDashboardCard>` |
| `crossAxisCount` | Optional override (default: responsive) |
| `crossAxisSpacing` | Horizontal gap (default: 16) |
| `mainAxisSpacing` | Vertical gap (default: 16) |

---

### Timeline & Calendar (v1.7.x)

#### `PlexTimeline`
Vertical timeline with optional alternating layout.

```dart
PlexTimeline(
  events: [
    PlexTimelineEvent(title: 'Order placed', subtitle: 'Details', timestamp: '10:00'),
    PlexTimelineEvent(title: 'Shipped', icon: Icon(Icons.local_shipping)),
  ],
  alternating: false,
  dotRadius: 10.0,
)
```

| PlexTimelineEvent | Description |
|-------------------|-------------|
| `title` | Event title |
| `subtitle` | Optional subtitle |
| `timestamp` | Optional timestamp string |
| `icon` | Optional leading icon |
| `color` | Optional dot/line color |
| `child` | Optional expanded content |

#### `PlexCalendar`
Calendar built on Syncfusion SfCalendar.

```dart
PlexCalendar(
  events: [
    PlexCalendarEvent(title: 'Meeting', start: DateTime.now(), end: DateTime.now().add(Duration(hours: 1))),
  ],
  initialView: PlexCalendarView.month,
  onEventTap: (event) {},
  onSlotTap: (dateTime) {},
  allowDragging: false,
)
```

| PlexCalendarEvent | Description |
|-------------------|-------------|
| `title` | Event title |
| `start`, `end` | `DateTime` range |
| `color` | Optional `Color` |
| `data` | Optional custom data |

| PlexCalendarView | Description |
|------------------|-------------|
| `month` | Month view |
| `week` | Week view |
| `day` | Day view |

---

### Rich Text Editor (v1.7.x)

#### `PlexRichTextEditor`
WYSIWYG editor using flutter_quill. Supports Delta JSON and HTML input.
```dart
PlexRichTextEditor(
  initialValue: '[{"insert":"Hello\\n"}]',
  outputFormat: PlexRichTextFormat.delta,
  onChanged: (value) => print(value),
  placeholder: 'Write something...',
  minHeight: 200.0,
)
```

#### `PlexFormFieldRichText`
Form field wrapper for the rich text editor.
```dart
PlexFormFieldRichText(
  properties: PlexFormFieldGeneric.title('Description'),
  initialValue: null,
  outputFormat: PlexRichTextFormat.html,
  onChanged: (value) {},
)
```

**Output formats:** `PlexRichTextFormat.delta` (JSON), `PlexRichTextFormat.html`, `PlexRichTextFormat.markdown`

---

### Backgrounds (v1.7.x)

#### `PlexBackground`
Decorative background layer. Supports five types:

```dart
PlexBackground(
  type: PlexBackgroundType.particleField,
  child: content,
)
```

| PlexBackgroundType | Description |
|--------------------|-------------|
| `neoGlass` | Glassmorphic blur effect |
| `particleField` | Animated drifting particles (canvas-drawn circles) |
| `gradientMesh` | Animated multi-stop gradient rotation |
| `geometricTiles` | Tessellation pattern (hexagonal/triangular) |
| `solidSurface` | Plain color (for accessibility/performance; no animation) |

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
- **Date/Time**: `PlexFormFieldDate` — `PlexFormFieldDateType.typeDate`, `typeTime`, `typeDateTime`
- **Dropdown**: `PlexFormFieldDropdown`
- **Multi-Select**: `PlexFormFieldMultiSelect`
- **Autocomplete**: `PlexFormFieldAutoComplete`
- **Button**: `PlexFormFieldButton`
- **Stepper** (v1.7.x): `PlexFormFieldStepper` — numeric +/- with min, max, step
- **Color** (v1.7.x): `PlexFormFieldColor` — color picker with preset grid
- **File** (v1.7.x): `PlexFormFieldFile` — file picker with `allowedExtensions`, `allowMultiple`
- **Rich Text** (v1.7.x): `PlexFormFieldRichText` — WYSIWYG editor

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

// v1.7.x additions
PlexFormFieldStepper(value: 5, min: 0, max: 10, step: 1, onChanged: (v) {})
PlexFormFieldColor(value: Colors.blue, onChanged: (c) {})
PlexFormFieldFile(allowedExtensions: ['pdf', 'doc'], allowMultiple: false, onChanged: (files) {})
PlexFormFieldRichText(properties: PlexFormFieldGeneric.title('Notes'), onChanged: (v) {})
```

| Form Field | Key Parameters |
|------------|----------------|
| `PlexFormFieldStepper` | `value`, `min`, `max`, `step`, `onChanged` |
| `PlexFormFieldColor` | `value`, `onChanged` — opens color grid dialog |
| `PlexFormFieldFile` | `allowedExtensions`, `allowMultiple`, `onChanged` — uses `file_picker` |
| `PlexFormFieldRichText` | `properties`, `initialValue`, `outputFormat`, `onChanged` |

#### Conditional Fields (v1.7.x) — `showWhen`
Show or hide fields based on form state.
```dart
PlexFormField.input(
  title: "Company",
  type: String,
  onChange: (v) => entity.company = v,
  showWhen: (state) => state.isBusiness == true,
)
```

#### PlexValidator (v1.7.x)
Reusable validators for form fields.
```dart
import 'package:plex/plex_utils/plex_validator.dart';

// Single validator
PlexFormFieldInput(
  errorController: errorController,
  inputOnChange: (v) {
    final err = PlexValidator.required(message: 'Required')(v);
    errorController?.setValue(err);
  },
)

// Composed validators
final validate = PlexValidator.compose([
  PlexValidator.required(),
  PlexValidator.email(),
  PlexValidator.minLength(8),
]);

// Available: required(), email(), minLength(n), maxLength(n), pattern(regex), compose([...])
```

#### PlexWizardForm (v1.7.x)
Multi-step form with Back / Next / Submit. Renders a `Stepper` with validation per step.

```dart
PlexWizardForm(
  steps: [
    PlexWizardStep(title: 'Step 1', fields: [/* PlexFormField list */]),
    PlexWizardStep(title: 'Step 2', fields: [...]),
  ],
  onComplete: () {},
  onCancel: () {},
)
```

| PlexWizardStep | Description |
|----------------|-------------|
| `title` | Step title |
| `fields` | `List<PlexFormField>` for this step |

#### Form State Persistence (v1.7.x)
Auto-save and restore form drafts via `PlexDb`.
```dart
PlexFormWidget<User>(
  entity: userForm,
  onSubmit: (user) {},
  persistenceKey: 'user_registration',
  db: plexDb,
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

#### `PlexCard` & `PlexCardGlass`
Material and glassmorphic card widgets for modern UIs.
```dart
PlexCard(child: Text("Standard Card"))
PlexCardGlass(child: Text("Glass Card"))
```

#### `PlexBackground`
Decorative background layer. Supports `neoGlass`, `particleField`, `gradientMesh`, `geometricTiles`, and `solidSurface` (v1.7.x).
```dart
PlexBackground(type: PlexBackgroundType.neoGlass, child: content)
```

#### `PlexMenu`
Model for menu items with icon and title.
```dart
PlexMenu("Dashboard", icon: Icon(Icons.dashboard))
```

---

### Navigation & Routing (v1.5.x)

PLEX provides a pluggable navigation layer with support for route guards, parameterized paths, and optional GoRouter for deep linking and web URL sync.

#### Navigation API

Use the `Plex` class for all navigation. It delegates to the configured router (GetX by default).

```dart
import 'package:plex/plex_utils/plex_routing.dart';

// Push a named route
Plex.toNamed('/orders');

// Push with query parameters
Plex.toNamed('/orders', parameters: {'page': '1', 'status': 'pending'});

// Replace current route (e.g. login → home)
Plex.offAndToNamed('/home');

// Push a widget directly (GetX router only)
Plex.to(OrderDetailScreen(orderId: 42), arguments: order);

// Pop the current route
Plex.back();
Plex.back(result: selectedItem);
```

#### PlexRouter — Pluggable Backend

`PlexApp` accepts an optional `router` or `experimentalRouter` parameter. The default is `PlexGetXRouter` (wraps GetX).

```dart
// Default: GetX (unchanged behavior)
runApp(PlexApp(appInfo: ..., dashboardConfig: ...));

// Custom router
runApp(PlexApp(appInfo: ..., router: myCustomRouter, dashboardConfig: ...));

// Experimental: GoRouter (deep linking, web URL sync)
import 'package:plex/plex_router/plex_go_router.dart';
runApp(PlexApp(appInfo: ..., experimentalRouter: PlexGoRouter(), dashboardConfig: ...));
```

#### Route Guards

Guards run before navigation and can redirect. Use `PlexAuthGuard` and `PlexRoleGuard`, or implement `PlexRouteGuard`.

```dart
import 'package:plex/plex_router/plex_route_guard.dart';

// Require authentication
PlexRoute(
  route: '/profile',
  title: 'Profile',
  screen: (context) => ProfileScreen(),
  guards: [PlexAuthGuard(loginPath: '/Login')],
);

// Require a specific role (or use legacy rule field — auto-wrapped)
PlexRoute(
  route: '/admin',
  title: 'Admin',
  screen: (context) => AdminScreen(),
  guards: [PlexRoleGuard('admin')],
);

// Legacy: rule is auto-wrapped into PlexRoleGuard
PlexRoute(route: '/reports', title: 'Reports', screen: ..., rule: 'view_reports');
```

#### Parameterized Paths (GoRouter)

When using `PlexGoRouter`, set `path` for parameterized routes. The URL bar reflects the current route on web.

```dart
PlexRoute(
  route: '/orders',
  path: '/orders/:id',
  title: 'Order Detail',
  screen: (context, {data}) => OrderDetailScreen(orderId: data),
);

// Navigate with parameters
Plex.toNamed('/orders', parameters: {'id': '42'});
```

#### PlexRoute Reference

| Field | Type | Description |
|-------|------|-------------|
| `route` | `String` | Route name used for navigation |
| `path` | `String?` | Parameterized path for GoRouter (e.g. `"/orders/:id"`) |
| `title` | `String` | Display title |
| `screen` | `Widget Function(BuildContext, {dynamic data})` | Screen builder |
| `rule` | `String?` | Permission rule (auto-wraps to `PlexRoleGuard`) |
| `guards` | `List<PlexRouteGuard>` | Route guards (evaluated before navigation) |
| `external` | `bool` | If true, pushed onto stack instead of inline in dashboard |
| `category` | `String` | Groups routes in drawer menu |

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

| PlexInfoSheetType | Description |
|-------------------|-------------|
| `info` | Informational |
| `error` | Error state |
| `alert` | Warning/alert |

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

#### `PlexAsyncAction` & `runAction`
Eliminates boilerplate for async operations with automatic loading and error handling. Use with `PlexViewModel`, `PlexViewViewModel`, or directly on `PlexState` / `PlexViewState`.

```dart
import 'package:plex/plex_view_model/plex_async_action.dart';

// In a PlexViewModel
void fetchOrders() => runAction(PlexAsyncAction(
  () => orderService.getOrders(),
  onSuccess: (orders) => setState(() => _orders = orders),
  onError: (e, s) => context?.showMessage('Failed to load orders'),
));

// In PlexState or PlexViewState directly (no ViewModel needed)
void onRefresh() => runAction(PlexAsyncAction(
  () => PlexApi.instance.get('/data'),
  onSuccess: (result) => setState(() => _data = result.data),
  onError: (e, s) => PlexLogger.e('Refresh', 'Error', error: e),
));
```

`runAction` automatically calls `showLoading()` before the task, `hideLoading()` in `finally`, catches errors, invokes `onError`, and logs via `PlexLogger`. Returns `null` on error, or the result on success.

---

### Utilities & Helpers

#### Spacing & Dimensions
```dart
spaceMini() // Widget with 2px
spaceSmall() // Widget with 8px
spaceMedium() // Widget with 16px
PlexDim.large // 32.0
```

#### PlexLogger (Structured Logging)
Structured logging with configurable levels. In release builds, `verbose` and `debug` are suppressed by default.
```dart
import 'package:plex/plex_utils/plex_logger.dart';

// Log at different levels
PlexLogger.v('MyTag', 'Verbose');      // verbose
PlexLogger.d('MyTag', 'Debug message'); // debug
PlexLogger.i('MyTag', 'Info message'); // info
PlexLogger.w('MyTag', 'Warning', error: someError);
PlexLogger.e('MyTag', 'Error occurred', error: e, stack: stackTrace);

// Configure minimum level (messages below this are not output)
PlexLogger.setLevel(PlexLogLevel.info);
```

| PlexLogLevel | Description |
|--------------|-------------|
| `verbose` | Most verbose |
| `debug` | Debug messages |
| `info` | Informational |
| `warning` | Warnings |
| `error` | Errors |

In release builds, `verbose` and `debug` are suppressed by default.

Add remote sink (e.g. Sentry, Crashlytics):

```dart
class MyLogSink extends PlexLogSink {
  @override
  void write(PlexLogLevel level, String tag, String message, {Object? error, StackTrace? stack}) {
    // Send to your logging service
  }
}
PlexLogger.addSink(MyLogSink());
PlexLogger.removeSink(myLogSink);
```

#### Console & Async
```dart
console("Debug message")  // Uses PlexLogger internally; prefer PlexLogger for new code
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

### Networking & API

PLEX provides a full-featured HTTP client with interceptors, timeouts, cancellation, caching, and type-safe response parsing.

#### Basic Setup

```dart
import 'package:plex/plex_networking/plex_api_calls.dart';

// Configure base URL and headers (typically in main() or app init)
PlexApi.instance.setBaseUrl('https://api.example.com');
PlexApi.instance.setHeadersCallback(() async => {
  'Content-Type': 'application/json',
  'X-App-Version': '1.0.0',
});
```

#### Simple API Calls

```dart
// GET
final result = await PlexApi.instance.get('/users', queryParams: {'page': 1});
if (result.success) {
  final data = result.data;  // Parsed JSON
}

// POST
final result = await PlexApi.instance.post('/users', body: {'name': 'John', 'email': 'john@example.com'});

// PUT
final result = await PlexApi.instance.put('/users/1', body: {'name': 'John Updated'});

// DELETE
final result = await PlexApi.instance.delete('/users/1');

// File upload (multipart)
final result = await PlexApi.instance.uploadFiles(
  '/upload',
  formData: {'description': 'Profile photo'},
  files: {'file': File('/path/to/image.jpg')},
);

// File download
await PlexNetworking.instance.downloadFile(
  'https://example.com/file.pdf',
  filename: 'document.pdf',
  onProgressUpdate: (downloaded, percentage, file) {
    print('Progress: $percentage%');
  },
);
```

#### Type-Safe Response Parsing

Use `getTyped` and `postTyped` to parse JSON responses into strongly-typed models:

```dart
class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
  );
}

// GET with typed response
final result = await PlexApi.instance.getTyped<User>(
  '/users/1',
  fromJson: User.fromJson,
);
if (result.success) {
  final user = result.data as User;  // Already typed
}

// POST with typed response
final result = await PlexApi.instance.postTyped<User>(
  '/users',
  body: {'name': 'Jane'},
  fromJson: User.fromJson,
);
```

#### Interceptors

Add request/response hooks for auth, retries, logging, etc.:

```dart
import 'package:plex/plex_networking/plex_networking.dart';
import 'package:plex/plex_networking/plex_interceptor.dart';

// Add Bearer token (automatic on every request)
PlexNetworking.instance.addInterceptor(
  PlexAuthInterceptor(() async => await getStoredToken()),
);

// Retry on 500/502/503 (default: 3 attempts)
PlexNetworking.instance.addInterceptor(
  PlexRetryInterceptor(maxAttempts: 3, retryOnStatusCodes: [500, 502, 503]),
);

// Custom interceptor
class LoggingInterceptor extends PlexInterceptor {
  @override
  Future<Map<String, String>> onRequest(String url, Map<String, String> headers) async {
    PlexLogger.d('API', 'Request: $url');
    return headers;
  }
  @override
  Future<PlexApiResponse> onResponse(PlexApiResponse response) async => response;
}
PlexNetworking.instance.addInterceptor(LoggingInterceptor());
```

#### Request Cancellation & Timeouts

```dart
// Create a cancel token
final cancelToken = PlexCancelToken();

// Use with low-level PlexNetworking (e.g. for search/cancel)
final response = await PlexNetworking.instance.get(
  '/search',
  query: {'q': 'query'},
  timeout: Duration(seconds: 10),
  cancelToken: cancelToken,
);

// Cancel from another part of your app (e.g. user taps "Cancel")
cancelToken.cancel();

// Default timeout is 30 seconds; override per request:
PlexNetworking.instance.defaultTimeout = Duration(seconds: 60);
```

#### Response Caching

Cache GET responses to reduce network calls and improve offline support:

```dart
import 'package:plex/plex_networking/plex_networking.dart';
import 'package:plex/plex_networking/plex_cache.dart';
import 'package:plex/plex_database/plex_database.dart';

// Initialize PlexDb first (e.g. in main)
final db = await PlexDb.initialize(PlexDbConfig('my_app'));

// Enable cache
await PlexNetworking.instance.enableCache(
  PlexCacheConfig(
    maxAge: Duration(minutes: 5),
    maxStale: Duration(minutes: 30),  // Optional: serve stale when offline
    cacheKey: (url, query) => '$url?${query?.toString() ?? ''}',  // Optional custom key
  ),
  db,
);

// GET requests now check cache first; successful responses are cached automatically
final result = await PlexApi.instance.get('/products');

// Clear cache when needed
await PlexNetworking.instance.clearCache();
await PlexNetworking.instance.clearCache(urlPattern: '/products');  // Clear only matching
```

#### Error Handling

The API returns a structured error hierarchy. Check `PlexApiResult`:

```dart
final result = await PlexApi.instance.get('/users', queryParams: {'page': 1});

if (result.success) {
  final data = result.data;
} else {
  // result.code: 408 = timeout, 5001 = no network, 499 = cancelled, 4xx/5xx = server error
  // result.message: human-readable error
  switch (result.code) {
    case 408: showError('Request timed out'); break;
    case 5001: showError('No internet connection'); break;
    case 499: showError('Request cancelled'); break;
    default: showError(result.message);
  }
}
```

When using `PlexNetworking` directly, you get `PlexApiResponse` which can be pattern-matched:

```dart
final response = await PlexNetworking.instance.get('/users');
if (response is PlexSuccess) {
  final data = response.response;
} else if (response is PlexNetworkTimeout) {
  // Handle timeout
} else if (response is PlexNetworkNoConnectivity) {
  // Handle no network
} else if (response is PlexNetworkServerError) {
  final statusCode = response.statusCode;
  final body = response.body;
}
```

---

### Data Storage

#### PlexSp (SharedPreferences)

Lightweight key-value storage for user preferences and small data:

```dart
import 'package:plex/plex_sp.dart';

await PlexSp.instance.initialize();

// Set values
PlexSp.instance.setString('theme', 'dark');
PlexSp.instance.setBool('notifications', true);
PlexSp.instance.setInt('counter', 42);
PlexSp.instance.setList('tags', ['a', 'b', 'c']);

// Get values
final theme = PlexSp.instance.getString('theme');
final enabled = PlexSp.instance.getBool('notifications');

// Remove (pass null)
PlexSp.instance.setString('theme', null);

// Check key exists
if (PlexSp.instance.hasKey('theme')) { }
```

Built-in constants: `PlexSp.loggedInUser`, `PlexSp.rememberUsers`.

#### PlexDb (Sembast)

Local NoSQL database for structured data. Import: `package:plex/plex_database/plex_database.dart`

```dart
// Initialize
final db = await PlexDb.initialize(PlexDbConfig('my_app'));

// Generic collection (key-value)
final collection = db.getCollection('items');
await collection.insert({'name': 'Item 1', 'value': 100});
final all = await collection.getAll();
final one = await collection.getById(1);

// Typed entity collection (model must use PlexEntity mixin)
// PlexEntity provides: int? entityId (set by DB on insert)
class Task with PlexEntity {
  String title;
  bool done;
  Task({required this.title, this.done = false});
  factory Task.fromJson(Map<String, dynamic> m) => Task(title: m['title'], done: m['done'] ?? false);
  Map<String, dynamic> toJson() => {'title': title, 'done': done};
}
final tasks = db.getEntityCollection<Task>('tasks', fromJson: Task.fromJson, toJson: (t) => t.toJson());
await tasks.insert(Task(title: 'Buy milk'));
```

| PlexDbConfig | Type | Description |
|--------------|------|-------------|
| `dbName` | `String` | Database file name |
| `encrypted` | `bool` | Enable AES-256 encryption at rest (default: `false`) |

| PlexCollection methods | Description |
|------------------------|-------------|
| `insert(record)` | Insert a new record (auto-generates `entityId`) |
| `insertAll(records)` | Bulk insert |
| `update(record)` | Update by `entityId` |
| `delete(record)` | Delete by record |
| `deleteById(id)` | Delete by id |
| `getById(id)` | Get single record |
| `getAll()` | Get all records |
| `find({limit, offset})` | Find with pagination |

#### Database Enhancements (v1.8.x)

**Query Builder** — Fluent DSL for filtering, sorting, and pagination:

```dart
import 'package:plex/plex_database/plex_database.dart';

final orders = db.getEntityCollection<Order>('orders', fromJson: Order.fromJson, toJson: (o) => o.toJson());

// Query with filters
final pending = await orders
  .query()
  .where('status').equals('pending')
  .where('total').greaterThan(100)
  .orderBy('createdAt', descending: true)
  .limit(20)
  .get();

// Count, first, delete
final count = await orders.query().where('status').equals('pending').count();
final first = await orders.query().where('status').equals('pending').first();
await orders.query().where('archived').equals(true).deleteAll();
```

**PlexQuery conditions** — All return `PlexQuery<T>` for chaining:

| Method | Example |
|--------|---------|
| `equals(value)` | `where('status').equals('pending')` |
| `notEquals(value)` | `where('status').notEquals('archived')` |
| `greaterThan(value)` | `where('total').greaterThan(100)` |
| `greaterThanOrEquals(value)` | `where('count').greaterThanOrEquals(10)` |
| `lessThan(value)` | `where('total').lessThan(1000)` |
| `lessThanOrEquals(value)` | `where('count').lessThanOrEquals(10)` |
| `contains(value, {caseInsensitive})` | `where('name').contains('john', caseInsensitive: true)` |
| `isIn(List values)` | `where('status').isIn(['pending', 'active'])` |
| `isNull()` | `where('deletedAt').isNull()` |
| `isNotNull()` | `where('deletedAt').isNotNull()` |

**PlexQuery terminal methods**:

| Method | Returns | Description |
|--------|---------|-------------|
| `get()` | `Future<List<T>>` | Execute and return all matching entities |
| `first()` | `Future<T?>` | Return first match or null |
| `count()` | `Future<int>` | Count matching records |
| `deleteAll()` | `Future<void>` | Delete all matching records |
| `watch()` | `Stream<List<T>>` | Reactive stream; emits when data changes |

**Migrations** — Versioned schema changes. Migrations run in ascending order on startup. Import: `package:plex/plex_database/plex_migration.dart` (or re-exported from `plex_database.dart`).

```dart
final db = await PlexDb.initialize(
  PlexDbConfig('my_app'),
  migrations: [
    PlexDbMigration(version: 1, up: (db) async {
      // Add initial collections
    }),
    PlexDbMigration(version: 2, up: (db) async {
      // Add indexes, new collections
    }),
  ],
);
```

| PlexDbMigration | Description |
|-----------------|-------------|
| `version` | Integer; migrations run in ascending order |
| `up(db)` | Async callback; receives `PlexDb` (e.g. `db.getCollection('orders')`) |

**Relations** — `hasMany` and `belongsTo`. Import: `package:plex/plex_database/plex_relation.dart`

```dart
final orderItems = orderCollection.hasMany(itemCollection, 'orderId');
final items = await orderItems.loadHasMany(order.entityId!);

final customer = orderCollection.belongsTo(customerCollection, 'customerId');
final cust = await customer.loadBelongsTo(order);
```

| Relation | Usage | Load method |
|----------|-------|-------------|
| `hasMany(related, foreignKey)` | One-to-many (e.g. Order → OrderItems) | `loadHasMany(ownerId)` → `Future<List<R>>` |
| `belongsTo(related, localForeignKey)` | Many-to-one (e.g. Order → Customer) | `loadBelongsTo(owner)` → `Future<R?>` |

**Reactive Queries** — Streams that emit when data changes:

```dart
// Watch all entities
orders.watchAll().listen((list) => updateUI(list));

// Watch a single entity
orders.watchById(42).listen((order) => updateDetail(order));

// Watch a filtered query
orders.query().where('status').equals('pending').watch().listen((list) => ...);
```

**Encryption at Rest** — AES-256-CBC encryption with key stored in secure storage:

```dart
final db = await PlexDb.initialize(PlexDbConfig('my_app', encrypted: true));
```

- Uses `flutter_secure_storage` and `encrypt` (included in Plex)
- Key is generated and stored in the device keystore on first run
- Key stored under `plex_db_key`; cannot be changed without losing access to encrypted data

**PlexDb HTTP cache** — Used by `PlexNetworking` for response caching. Also available for custom use:

```dart
await db.putInCache('my_key', {'data': 'value'});
final cached = await db.getFromCache('my_key');
await db.deleteFromCache('my_key');
await db.clearCache();                    // Clear all
await db.clearCache(urlPattern: '/api');  // Clear matching keys
final keys = await db.getCacheKeys();
```

---

### Dependency Injection

PLEX provides a flexible, tag-based dependency injection system with support for global and scoped lifetimes, circular dependency detection, and async initialization.

#### Basic Registration & Resolution

```dart
import 'package:plex/plex_di/plex_dependency_injection.dart';

// Register singleton (created immediately)
injectSingleton(MyService());

// Register lazy singleton (created on first access)
injectSingletonLazy((parm) => MyService());

// Register factory (new instance each time)
injectFactory((parm) => MyService());

// Resolve
final service = fromPlex<MyService>();

// Use tags for multiple implementations of same type
injectSingleton(HttpClient(), tag: 'api');
injectSingleton(HttpClient(), tag: 'auth');
final apiClient = fromPlex<HttpClient>(tag: 'api');
```

#### Scoped DI (v1.4.x)

Scoped dependencies live in a named scope and are cleaned up when the scope is closed. Use this for session-level or screen-level services that should not persist forever.

```dart
// Register a dependency in a named scope (lazy within scope)
injectScoped<SessionService>(
  () => SessionService(),
  scope: 'session',
  tag: null,  // optional tag
);

// Resolve from scope (falls back to global if not found in scope)
final session = fromScoped<SessionService>(scope: 'session');

// Close a scope and dispose all PlexDisposable instances inside it
await closeScope('session');
```

**When to use scoped DI:**
- Session-scoped services (e.g., per-user session, checkout flow)
- Screen-scoped services that should be disposed when the screen is popped
- Feature modules that need isolated dependency graphs

#### PlexDisposable — Cleanup on Scope Close

Implement the `PlexDisposable` mixin so your service receives a `dispose()` call when its scope is closed:

```dart
class MyScopedService with PlexDisposable {
  StreamSubscription? _subscription;

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    // Release resources, close connections, etc.
  }
}

injectScoped<MyScopedService>(
  () => MyScopedService(),
  scope: 'feature',
);

// When closeScope('feature') is called, dispose() is invoked automatically
await closeScope('feature');
```

Services that do not implement `PlexDisposable` are simply removed from the scope; no dispose call is made.

#### Screen-Level Auto-Scope (PlexState)

`PlexState` supports an optional `diScope` override. When set, the scope is automatically closed when the screen is disposed (e.g., on pop or route replacement).

```dart
class OrderScreen extends PlexScreen {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends PlexState<OrderScreen> {
  @override
  String? get diScope => 'order_screen';  // Scope name for this screen

  @override
  void initState() {
    super.initState();
    // Register screen-scoped dependencies
    injectScoped<OrderViewModel>(
      () => OrderViewModel(),
      scope: diScope!,
    );
  }

  @override
  Widget buildBody() {
    final vm = fromScoped<OrderViewModel>(scope: diScope!);
    return OrderView(viewModel: vm);
  }
  // When the screen is disposed, closeScope('order_screen') is called automatically
}
```

Screens that do not override `diScope` (default `null`) are unaffected.

#### Circular Dependency Detection

The DI container detects circular dependencies during resolution and throws `PlexCircularDependencyError` with the full dependency chain instead of causing a stack overflow.

```dart
// Example: A depends on B, B depends on A
injectSingletonLazy<ServiceA>((_) => ServiceA());  // ServiceA() calls fromPlex<ServiceB>()
injectSingletonLazy<ServiceB>((_) => ServiceB());  // ServiceB() calls fromPlex<ServiceA>()

try {
  fromPlex<ServiceA>();
} on PlexCircularDependencyError catch (e) {
  print(e);  // "PlexCircularDependencyError: Circular dependency detected: ServiceA → ServiceB → ServiceA"
}
```

#### Async Lazy Initialization

For dependencies that require async setup (e.g., database initialization, network config), use `injectSingletonLazyAsync` and `fromPlexAsync`:

```dart
// In main() or app setup
injectSingletonLazyAsync<PlexDb>(
  () => PlexDb.initialize(PlexDbConfig('my_app')),
);

// In a ViewModel or service — await on first access
final db = await fromPlexAsync<PlexDb>();

// With tag
injectSingletonLazyAsync<AnalyticsService>(
  () => AnalyticsService.init(),
  tag: 'analytics',
);
final analytics = await fromPlexAsync<AnalyticsService>(tag: 'analytics');
```

The async builder is invoked once; subsequent calls to `fromPlexAsync` return the same cached instance.

#### API Reference

| Function | Description |
|----------|-------------|
| `injectSingleton<T>(instance, {tag})` | Register an immediate singleton |
| `injectSingletonLazy<T>(builder, {tag})` | Register a lazy singleton (sync builder) |
| `injectSingletonLazyAsync<T>(builder, {tag})` | Register a lazy singleton (async builder) |
| `injectFactory<T>(builder, {tag})` | Register a factory (new instance each time) |
| `injectScoped<T>(builder, {scope, tag})` | Register a scoped lazy singleton |
| `fromPlex<T>({tag, parm})` | Resolve from global registry |
| `fromPlexAsync<T>({tag})` | Resolve async lazy singleton |
| `fromScoped<T>({scope, tag, parm})` | Resolve from scope (fallback to global) |
| `closeScope(scope)` | Close scope and dispose `PlexDisposable` instances |

| Type / Mixin | Description |
|--------------|-------------|
| `PlexDisposable` | Mixin with `Future<void> dispose()` for cleanup on scope close |
| `PlexCircularDependencyError` | Error thrown when a circular dependency is detected; `chain` contains the resolution path |

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

## 📦 Import Paths

| Module | Import |
|--------|--------|
| Core app | `package:plex/plex_package.dart` |
| Database | `package:plex/plex_database/plex_database.dart` |
| Migrations | `package:plex/plex_database/plex_migration.dart` |
| Relations | `package:plex/plex_database/plex_relation.dart` |
| Networking | `package:plex/plex_networking/plex_networking.dart`, `plex_api_calls.dart`, `plex_cache.dart`, `plex_interceptor.dart` |
| DI | `package:plex/plex_di/plex_dependency_injection.dart` |
| Routing | `package:plex/plex_utils/plex_routing.dart` |
| Guards | `package:plex/plex_router/plex_route_guard.dart` |
| GoRouter | `package:plex/plex_router/plex_go_router.dart` |
| Validator | `package:plex/plex_utils/plex_validator.dart` |
| Logger | `package:plex/plex_utils/plex_logger.dart` |
| Storage | `package:plex/plex_sp.dart` |

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

**Key dependencies** (included in Plex): `sembast`, `flutter_secure_storage`, `encrypt`, `syncfusion_flutter_*`, `flutter_quill`, `file_picker`, `get`, `go_router`, `connectivity_plus`, `path_provider`, `http`, `toastification`, `intl`, `lottie`, `mobile_scanner`, `signalr_netcore`, and more. See `pubspec.yaml` for the full list.

---

## 🧪 Testing

PLEX includes built-in unit and widget tests. Run all tests:

```sh
flutter test
```

Or run specific test suites:

```sh
flutter test test/unit/
flutter test test/widget/
```

**Test structure:**
- `test/unit/` — Unit tests for `PlexSp`, `PlexDI`, `PlexNetworking`, `PlexDb`, `PlexWidgetController`
- `test/widget/` — Widget tests for `PlexFormFieldInput`, `PlexFormFieldDropdown`

**Key testable modules:** PlexSp, PlexDI, PlexNetworking, PlexDb, PlexWidgetController, PlexFormFieldInput, PlexFormFieldDropdown

**Dev dependencies** (used when contributing to PLEX):

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  fake_async: ^1.3.2
  path_provider_platform_interface: ^2.1.2
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
        // Define your screens: PlexRoute(route, title, screen: (ctx) => YourScreen()),
      ],
    ),
  ));
}

// Navigate: Plex.toNamed('/path'); Plex.back();
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

// Unified API (v1.7.x) — list, paginated, or stream
PlexDataTableUnified(
  source: PlexTableSource.list(rows),
  columns: [PlexDataCell.text("ID"), PlexDataCell.text("Name")],
  features: PlexTableFeatures(search: true, print: true),
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
import 'package:plex/plex_view_model/plex_async_action.dart';

class HomeScreenViewModel extends PlexViewModel<HomeScreen, _HomeScreenState> {
  void fetchData() => runAction(PlexAsyncAction(
    () => PlexApi.instance.get('/api/data'),
    onSuccess: (result) {
      if (result.success) setState(() => _data = result.data);
    },
    onError: (e, s) => context?.showMessage('Failed to load data'),
  ));
}
```

### Dependency Injection

```dart
import 'package:plex/plex_di/plex_dependency_injection.dart';

injectSingleton(MyService());
final service = fromPlex<MyService>();

// Scoped (cleaned up when scope closes)
injectScoped<SessionService>(() => SessionService(), scope: 'session');
final session = fromScoped<SessionService>(scope: 'session');

// Async (e.g. database init)
injectSingletonLazyAsync(() => PlexDb.initialize(PlexDbConfig('my_app')));
final db = await fromPlexAsync<PlexDb>();
```

### Navigation

```dart
import 'package:plex/plex_utils/plex_routing.dart';

Plex.toNamed('/orders');
Plex.offAndToNamed('/home');  // Replace stack (e.g. after login)
Plex.back(result: selectedItem);

// With GoRouter: parameterized paths and web URL sync
PlexApp(experimentalRouter: PlexGoRouter(), ...);
```

### SignalR Real-Time Integration

```dart
PlexSignalR.config = PlexSignalRConfig(
  "https://serverurl:port", "hubPath",
  remoteMethods: [PlexSignalRMethod("OnEvent", (args) => print(args))],
);
await PlexSignalR.instance.start();
```

### Complete API Setup Example

```dart
import 'package:flutter/material.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_database/plex_database.dart';
import 'package:plex/plex_networking/plex_api_calls.dart';
import 'package:plex/plex_networking/plex_networking.dart';
import 'package:plex/plex_networking/plex_interceptor.dart';
import 'package:plex/plex_networking/plex_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await PlexSp.instance.initialize();
  final db = await PlexDb.initialize(PlexDbConfig('my_app'));
  
  // Configure networking
  PlexApi.instance.setBaseUrl('https://api.example.com');
  PlexApi.instance.setHeadersCallback(() async => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${await getToken()}',
  });
  
  // Optional: Add auth interceptor (alternative to setHeadersCallback)
  PlexNetworking.instance.addInterceptor(
    PlexAuthInterceptor(() async => await getToken()),
  );
  
  // Optional: Enable response caching
  await PlexNetworking.instance.enableCache(
    PlexCacheConfig(maxAge: Duration(minutes: 5)),
    db,
  );
  
  runApp(MyApp());
}
```

---

## 🏗️ Architecture & Extensibility

- **MVVM Pattern**: Clean separation of UI and business logic.
- **Customizable Themes**: Use your own color schemes, images, or Material versions.
- **Flexible Routing**: Pluggable router (GetX or GoRouter), route guards, parameterized paths, and deep linking.
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
