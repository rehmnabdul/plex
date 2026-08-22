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

  test('explicit danger, ink, and fontFamily override seed', () {
    const Color danger = Color(0xFFCC0000);
    const Color ink = Color(0xFF111111);
    const Color seed = Color(0xFF607D8B);

    final PlexColorTokens tokens = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: seed,
      brand: const PlexBrandConfig(
        danger: danger,
        brandInk: ink,
        fontFamily: 'Courier',
      ),
    );

    expect(tokens.statusDanger, danger);
    expect(tokens.brandInk, ink);
    expect(tokens.textPrimary, ink);

    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: seed);
    expect(tokens.statusDanger, isNot(scheme.error));
  });

  test('null brand falls back to seed-derived colors and Roboto', () {
    _ensurePlexApp(seed: plexDefaultSeedColor);
    final ThemeData theme = PlexTheme.getThemeByBrightness(Brightness.light);
    final PlexThemeData ext = theme.extension<PlexThemeData>()!;
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: plexDefaultSeedColor);

    expect(ext.colors.brandPrimary, scheme.primary);
    expect(ext.fontFamily, 'Roboto');
    expect(ext.density, PlexDensity.comfortable);
  });

  test('brandPrimary and status colors override seed on the extension', () {
    const Color primary = Color(0xFF0055AA);
    const Color danger = Color(0xFF990000);
    const Color success = Color(0xFF006600);
    const Color warning = Color(0xFFCC8800);
    const Color info = Color(0xFF0044CC);

    _ensurePlexApp(
      seed: plexDefaultSeedColor,
      brand: const PlexBrandConfig(
        brandPrimary: primary,
        danger: danger,
        success: success,
        warning: warning,
        info: info,
        fontFamily: 'Courier',
        density: PlexDensity.compact,
      ),
    );

    final ThemeData theme = PlexTheme.getThemeByBrightness(Brightness.light);
    final PlexThemeData ext = theme.extension<PlexThemeData>()!;

    expect(ext.colors.brandPrimary, primary);
    expect(ext.colors.statusDanger, danger);
    expect(ext.colors.statusSuccess, success);
    expect(ext.colors.statusWarning, warning);
    expect(ext.colors.statusInfo, info);
    expect(ext.fontFamily, 'Courier');
    expect(ext.density, PlexDensity.compact);
    expect(theme.textTheme.bodyLarge?.fontFamily, 'Courier');
    expect(theme.visualDensity, VisualDensity.compact);
  });

  test('widget-level color tokens win over brand and seed', () {
    final PlexColorTokens widgetTokens = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: const Color(0xFF00AA00),
    );
    final PlexColorTokens tokens = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: plexDefaultSeedColor,
      brand: const PlexBrandConfig(brandPrimary: Color(0xFFAA0000)),
      widgetColors: widgetTokens,
    );

    expect(tokens.brandPrimary, widgetTokens.brandPrimary);
    expect(tokens.brandPrimary, isNot(const Color(0xFFAA0000)));
  });
}
