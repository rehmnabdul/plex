# plex_app

Example application for the Plex Flutter UI framework. It is a visual QA of Phases 0–5c plus restyled feature demos — not a product branded app.

## Run

From the repo root:

```sh
cd example
flutter pub get
flutter run
```

The example depends on the local package (`plex: path: ../../plex`). Published apps should use `plex: 2.0.1-beta.8` (see the root README).

## What you will see

Flow is unchanged: **`PlexApp` → split login → dashboard routes**.

Login defaults to `PlexLoginLayout.split` with generic copy and `assets/app.png`. Glass is off (`useBackground: false`). Theme seed is `PlexTheme.defaultSeedColor` (`#607D8B`) with `PlexBrandConfig(density: PlexDensity.comfortable)`.

`PlexDataGrid` is the table engine. `PlexAdvanceDataTable` is a deprecated wrapper around it. Excel and PDF export use `PlexPrinter` (Plex-owned PDF; Excel still via xlsio). The package no longer depends on Syncfusion DataGrid.

### Dashboard categories

| Category | Routes | Purpose |
| --- | --- | --- |
| **Overview** | `/home` | Landing page, shortcuts, badges, avatar |
| **Design system** | `/ui-theme`, `/ui-buttons`, `/ui-forms`, `/ui-feedback`, `/ui-tabs`, `/data-grid` | Phases 0–5c widget QA |
| **Tables** | `/dashboard`, `/paginated-table`, `/advance-data-table`, `/dashboardExternal` | Existing table widgets (`PlexAdvanceDataTable` is a deprecated wrapper around `PlexDataGrid`; Excel/PDF export use `PlexPrinter`) |
| **Forms** | `/all-inputs`, `/form-usage` | Full field catalog and `PlexFormWidget` |
| **Widgets** | autocomplete sample, logo route, updatable widget, info sheet, scanner | Existing demos, restyled |
| **Charts** | `/gantt-demo` | `PlexChartGant` |

Dashboard AppBar is `PlexAppBar`. Screens inside the dashboard should not add a second `Scaffold` (`useScaffold: false` on `PlexScreen`s).

## Design system routes

- **Theme & brand** — `PlexThemeData.of(context)`, density, surfaces, status colors, flat vs `PlexCardGlassEffect`
- **Buttons & identity** — `PlexFormFieldButton` types, `PlexIconButton`, `PlexBadge`, `PlexAvatar`
- **Forms** — restyled `PlexFormField*`, checkbox, switch
- **Cards & feedback** — card slots, `PlexAlert`, `PlexProgressBar`, `PlexSkeleton` / `PlexShimmer`, toasts
- **Tabs** — `PlexTabs` + `PlexTabPanel`
- **Plex Data Grid** — `PlexDataGrid` (the table engine; prefer over the deprecated `PlexAdvanceDataTable` wrapper)

## Copy-paste: app wiring

See `lib/main.dart` for the full example. Minimal shape:

```dart
runApp(PlexApp(
  themeFromColor: PlexTheme.defaultSeedColor,
  brandConfig: const PlexBrandConfig(density: PlexDensity.comfortable),
  appInfo: PlexAppInfo(
    title: "Plex Example",
    appLogo: Image.asset("assets/app.png"),
    appLogoDark: Image.asset("assets/app.png"),
    initialRoute: "/home",
  ),
  useAuthorization: true,
  loginConfig: PlexLoginConfig(
    layout: PlexLoginLayout.split,
    useBackground: false,
    onLogin: (context, email, password) async => user,
    userFromJson: (json) => AppUser.fromJson(json),
  ),
  dashboardConfig: PlexDashboardConfig(
    useBackground: false,
    dashboardScreens: [
      PlexRoute(
        route: "/home",
        category: "Overview",
        title: "Home",
        screen: (context, {data}) => const HomeOverviewScreen(),
      ),
    ],
  ),
));
```

Debug login: `DebugUser` / `DebugPassword`. Release-style fields: `User` / `Password`.

## Assets

Generic identity only: `assets/app.png`. Do not copy third-party design-system logos into this example.

## More detail

The root [README.md](../README.md) has install instructions, widget snippets, and migration notes.
