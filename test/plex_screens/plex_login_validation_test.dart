import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_screens/plex_login_screen.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_user.dart';
import 'package:plex/plex_widgets/plex_backgrounds/plex_background.dart';
import 'package:plex/plex_widgets/plex_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

PlexLoginConfig _loginConfig({
  PlexLoginLayout layout = PlexLoginLayout.split,
  bool useBackground = false,
}) {
  return PlexLoginConfig(
    layout: layout,
    useBackground: useBackground,
    backgroundType: PlexBackgroundType.neoGlass,
    additionalWidgetsTop: (_) => const Text('Login Top'),
    additionalWidgetsAboveLoginButton: (_) => const Text('Login Mid'),
    additionalWidgetsBottom: (_) => const Text('Login Bottom'),
    onLogin: (context, email, password) async => PlexDemoUser(),
    userFromJson: (_) => PlexDemoUser(),
  );
}

void _ensureApp(PlexLoginConfig login) {
  PlexApp(
    appInfo: PlexAppInfo(
      title: 'Test App',
      appLogo: const Text('AppLogo'),
      initialRoute: '/home',
      versionName: 'v1.0.0',
    ),
    useAuthorization: true,
    loginConfig: login,
    pages: [
      PlexRoute(
        route: '/home',
        title: 'Home',
        screen: (context, {data}) => const SizedBox.shrink(),
      ),
    ],
  );
}

Future<void> _pumpLogin(
  WidgetTester tester, {
  PlexLoginLayout layout = PlexLoginLayout.split,
  bool useBackground = false,
}) async {
  final PlexLoginConfig config = _loginConfig(
    layout: layout,
    useBackground: useBackground,
  );
  _ensureApp(config);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[PlexThemeData.fallback()],
      ),
      home: PlexLoginScreen(
        loginConfig: config,
        nextRoute: '/home',
        useBackground: useBackground,
        backgroundType: PlexBackgroundType.neoGlass,
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
    PlexSp.instance.setString(PlexSp.loggedInUser, null);
    PlexSp.instance.setList(PlexSp.rememberUsers, null);
    PlexSp.instance.setBool('plex_animations', false);
  });

  testWidgets('empty username shows Username can\'t be empty', (tester) async {
    await _pumpLogin(tester);
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text("Username can't be empty"), findsOneWidget);
  });

  testWidgets('empty password shows Password can\'t be empty', (tester) async {
    await _pumpLogin(tester);
    await tester.enterText(find.byType(TextField).first, 'user');
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text("Password can't be empty"), findsOneWidget);
    expect(find.text("Username can't be empty"), findsNothing);
  });

  testWidgets('split is the default layout and shows the brand panel',
      (tester) async {
    await _pumpLogin(tester);
    expect(find.byKey(PlexLoginScreen.splitLayoutKey), findsOneWidget);
    expect(find.byKey(PlexLoginScreen.brandPanelKey), findsOneWidget);
    expect(find.byKey(PlexLoginScreen.centeredLayoutKey), findsNothing);
    expect(find.byType(PlexCard), findsNothing);
    expect(find.text('Remember User'), findsOneWidget);
    expect(find.text('Login Top'), findsOneWidget);
    expect(find.text('Login Mid'), findsOneWidget);
    expect(find.text('Login Bottom'), findsOneWidget);
    expect(find.text('AppLogo'), findsWidgets);
  });

  testWidgets('layout: centered keeps the historic card and hides brand panel',
      (tester) async {
    await _pumpLogin(tester, layout: PlexLoginLayout.centered);
    expect(find.byKey(PlexLoginScreen.centeredLayoutKey), findsOneWidget);
    expect(find.byKey(PlexLoginScreen.splitLayoutKey), findsNothing);
    expect(find.byKey(PlexLoginScreen.brandPanelKey), findsNothing);
    expect(find.byType(PlexCard), findsOneWidget);
    expect(find.text('Remember User'), findsOneWidget);
    expect(find.text('Login Top'), findsOneWidget);
    expect(find.text('AppLogo'), findsWidgets);
  });

  testWidgets('centered layout still validates empty username', (tester) async {
    await _pumpLogin(tester, layout: PlexLoginLayout.centered);
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text("Username can't be empty"), findsOneWidget);
  });

  testWidgets('useBackground neoGlass still builds split login',
      (tester) async {
    await _pumpLogin(tester, useBackground: true);
    expect(find.byKey(PlexLoginScreen.splitLayoutKey), findsOneWidget);
    expect(find.text('Remember User'), findsOneWidget);
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text("Username can't be empty"), findsOneWidget);
  });
}
