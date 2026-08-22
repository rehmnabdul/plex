import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_theme.dart';

void _ensurePlexApp({PlexBrandConfig? brand, Color? seed}) {
  PlexApp(
    themeFromColor: seed ?? PlexTheme.defaultSeedColor,
    brandConfig: brand,
    appInfo: PlexAppInfo(
      title: 'Test',
      appLogo: const SizedBox.shrink(),
      initialRoute: '/home',
    ),
    pages: [
      PlexRoute(
        route: '/home',
        title: 'Home',
        screen: (context, {data}) => const SizedBox.shrink(),
      ),
    ],
  );
}

void main() {
  tearDown(() {
    PlexTheme.appTheme = null;
    PlexTheme.appTextTheme = null;
  });

  test('getThemeByBrightness attaches PlexThemeData extension', () {
    _ensurePlexApp();
    final ThemeData light = PlexTheme.getThemeByBrightness(Brightness.light);
    final ThemeData dark = PlexTheme.getThemeByBrightness(Brightness.dark);

    expect(light.extension<PlexThemeData>(), isNotNull);
    expect(dark.extension<PlexThemeData>(), isNotNull);
    expect(light.useMaterial3, isTrue);
    expect(dark.useMaterial3, isTrue);
    expect(light.extension<PlexThemeData>()!.colors.surfacePage,
        isNot(dark.extension<PlexThemeData>()!.colors.surfacePage));
  });

  test('appTheme override still has the extension merged', () {
    _ensurePlexApp();
    const Color orange = Color(0xFFFF9800);
    PlexTheme.appTheme = ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(seedColor: orange),
    );

    final ThemeData theme = PlexTheme.getThemeByBrightness(Brightness.light);
    expect(theme.extension<PlexThemeData>(), isNotNull);
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, ColorScheme.fromSeed(seedColor: orange).primary);
  });

  test('appTextTheme still wins over package defaults', () {
    _ensurePlexApp(brand: const PlexBrandConfig(fontFamily: 'Roboto'));
    PlexTheme.appTextTheme = const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Courier', fontSize: 22),
    );

    final ThemeData theme = PlexTheme.getThemeByBrightness(Brightness.light);
    expect(theme.textTheme.bodyLarge?.fontFamily, 'Courier');
    expect(theme.textTheme.bodyLarge?.fontSize, 22);
  });

  test('appTextTheme wins even when appTheme is set', () {
    _ensurePlexApp();
    PlexTheme.appTheme = ThemeData(
      useMaterial3: true,
      textTheme: const TextTheme(bodyLarge: TextStyle(fontFamily: 'Arial')),
    );
    PlexTheme.appTextTheme = const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Courier'),
    );

    final ThemeData theme = PlexTheme.getThemeByBrightness(Brightness.light);
    expect(theme.extension<PlexThemeData>(), isNotNull);
    expect(theme.textTheme.bodyLarge?.fontFamily, 'Courier');
  });

  test('isMaterial3 is always true; deprecated setMaterial3 does not switch M2', () {
    _ensurePlexApp();
    expect(PlexTheme.isMaterial3(), isTrue);
    // ignore: deprecated_member_use_from_same_package
    PlexTheme.setMaterial3(false);
    expect(PlexTheme.isMaterial3(), isTrue);

    final ThemeData theme = PlexTheme.getThemeByBrightness(Brightness.light);
    expect(theme.useMaterial3, isTrue);
  });

  test('forceMaterial3 does not produce Material 2', () {
    PlexApp(
      themeFromColor: PlexTheme.defaultSeedColor,
      // ignore: deprecated_member_use
      forceMaterial3: false,
      appInfo: PlexAppInfo(
        title: 'Test',
        appLogo: const SizedBox.shrink(),
        initialRoute: '/home',
      ),
      pages: [
        PlexRoute(
          route: '/home',
          title: 'Home',
          screen: (context, {data}) => const SizedBox.shrink(),
        ),
      ],
    );

    final ThemeData theme = PlexTheme.getThemeByBrightness(Brightness.dark);
    expect(theme.useMaterial3, isTrue);
  });

  test('static color getters prefer light tokens after dark theme is also built', () {
    _ensurePlexApp();
    final ThemeData light = PlexTheme.getThemeByBrightness(Brightness.light);
    PlexTheme.getThemeByBrightness(Brightness.dark);
    expect(PlexTheme.inputBackgroundColor, light.extension<PlexThemeData>()!.colors.surfaceSunken);
    expect(PlexTheme.inputBackgroundColor, isNot(const Color(0xFF2A323F)));
  });

  testWidgets('PlexThemeData.of falls back when extension is missing', (WidgetTester tester) async {
    late PlexThemeData resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Builder(
          builder: (BuildContext context) {
            resolved = PlexThemeData.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(resolved.colors.surfacePage, isNotNull);
    expect(resolved.fontFamily, 'Roboto');
  });
}
