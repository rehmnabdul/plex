import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'plex_animations': false,
    });
    await PlexSp.instance.initialize();
  });

  setUp(() {
    PlexSp.instance.setBool('plex_animations', false);
    PlexSp.instance.setString(PlexSp.loggedInUser, null);
  });

  test('PlexAppBar is a PreferredSizeWidget with 64px default height', () {
    const PlexAppBar bar = PlexAppBar(title: Text('Title'));
    expect(bar, isA<PreferredSizeWidget>());
    expect(bar.preferredSize.height, PlexLayout.topbarHeight);
    expect(bar.preferredSize.height, 64);
  });

  test('explicit toolbarHeight still wins', () {
    const PlexAppBar bar = PlexAppBar(
      title: Text('Title'),
      toolbarHeight: 48,
    );
    expect(bar.preferredSize.height, 48);
  });

  testWidgets('PlexAppBar builds inside a Scaffold appBar slot',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
        ),
        home: const Scaffold(
          appBar: PlexAppBar(title: Text('Bar Title')),
          body: Text('Body'),
        ),
      ),
    );
    expect(find.byType(PlexAppBar), findsOneWidget);
    expect(find.text('Bar Title'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });

  testWidgets('dashboard still hosts PlexAppBar', (tester) async {
    PlexApp(
      appInfo: PlexAppInfo(
        title: 'Test App',
        appLogo: const Text('AppLogo'),
        initialRoute: '/home',
        versionName: 'v1.0.0',
      ),
      dashboardConfig: PlexDashboardConfig(
        dashboardScreens: [
          PlexRoute(
            route: '/home',
            title: 'Home Screen Title',
            screen: (context, {data}) => const Text('DashBody'),
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
        ),
        home: PlexDashboardScreen((ThemeMode mode) {}, () {}),
      ),
    );
    await tester.pump();

    expect(find.byType(PlexAppBar), findsOneWidget);
    final PlexAppBar bar = tester.widget<PlexAppBar>(find.byType(PlexAppBar));
    expect(bar, isA<PreferredSizeWidget>());
    expect(bar.preferredSize.height, PlexLayout.topbarHeight);
    expect(find.text('Home Screen Title'), findsWidgets);
    expect(find.text('DashBody'), findsOneWidget);
  });
}
