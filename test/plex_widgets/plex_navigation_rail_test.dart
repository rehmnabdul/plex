import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_navigation_rail.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<PlexRoute> _routes() {
  return [
    PlexRoute(
      route: '/home',
      title: 'Home',
      category: 'Main',
      screen: (context, {data}) => const SizedBox.shrink(),
    ),
    PlexRoute(
      route: '/orders',
      title: 'Orders',
      category: 'Main',
      screen: (context, {data}) => const SizedBox.shrink(),
    ),
    PlexRoute(
      route: '/people',
      title: 'People',
      category: 'HR',
      screen: (context, {data}) => const SizedBox.shrink(),
    ),
  ];
}

void _ensureApp({
  bool hideLogo = false,
  bool hideVersion = false,
}) {
  PlexApp(
    appInfo: PlexAppInfo(
      title: 'Test App',
      appLogo: const Text('AppLogo'),
      initialRoute: '/home',
      versionName: 'v9.9.9',
    ),
    dashboardConfig: PlexDashboardConfig(
      dashboardScreens: _routes(),
      hideNavigationRailLogo: hideLogo,
      hideNavigationRailVersionInfo: hideVersion,
    ),
  );
}

Future<void> _pumpRail(
  WidgetTester tester, {
  required bool extended,
  required ValueChanged<int> onSelect,
  int selected = 0,
  bool hideLogo = false,
  bool hideVersion = false,
}) async {
  _ensureApp(hideLogo: hideLogo, hideVersion: hideVersion);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
      ),
      home: Scaffold(
        body: Row(
          children: [
            PlexNavigationRail(
              destinations: _routes(),
              selectedDestination: selected,
              onSelectDestination: onSelect,
              extended: extended,
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'plex_animations': false,
    });
    await PlexSp.instance.initialize();
  });

  setUp(() {
    PlexSp.instance.setBool('plex_animations', false);
  });

  testWidgets('select callback fires with the destination index',
      (tester) async {
    int? selected;
    await _pumpRail(
      tester,
      extended: true,
      onSelect: (int index) => selected = index,
    );
    await tester.tap(find.text('Orders'));
    await tester.pump();
    expect(selected, 1);
  });

  testWidgets('extended rail is 260 wide and shows category headers',
      (tester) async {
    await _pumpRail(tester, extended: true, onSelect: (_) {});
    expect(tester.getSize(find.byType(PlexNavigationRail)).width,
        PlexLayout.railExpanded);
    expect(tester.getSize(find.byType(PlexNavigationRail)).width, 260);
    expect(find.text('Main'), findsOneWidget);
    expect(find.text('HR'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
  });

  testWidgets('collapsed rail is 90 wide and hides category headers',
      (tester) async {
    await _pumpRail(tester, extended: false, onSelect: (_) {});
    expect(tester.getSize(find.byType(PlexNavigationRail)).width,
        PlexLayout.railCollapsed);
    expect(tester.getSize(find.byType(PlexNavigationRail)).width, 90);
    expect(find.text('Main'), findsNothing);
    expect(find.text('HR'), findsNothing);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('logo hide flag still hides the rail logo', (tester) async {
    await _pumpRail(
      tester,
      extended: true,
      onSelect: (_) {},
      hideLogo: true,
    );
    expect(find.byKey(PlexNavigationRail.logoKey), findsNothing);
    expect(find.text('AppLogo'), findsNothing);
  });

  testWidgets('logo is shown when hide flag is false', (tester) async {
    await _pumpRail(
      tester,
      extended: true,
      onSelect: (_) {},
    );
    expect(find.byKey(PlexNavigationRail.logoKey), findsOneWidget);
    expect(find.text('AppLogo'), findsOneWidget);
  });

  testWidgets('version hide flag still hides version info', (tester) async {
    await _pumpRail(
      tester,
      extended: true,
      onSelect: (_) {},
      hideVersion: true,
    );
    expect(find.byKey(PlexNavigationRail.versionKey), findsNothing);
  });

  testWidgets('version is shown when hide flag is false', (tester) async {
    await _pumpRail(tester, extended: true, onSelect: (_) {});
    expect(find.byKey(PlexNavigationRail.versionKey), findsOneWidget);
    expect(find.text('v9.9.9'), findsOneWidget);
  });
}
