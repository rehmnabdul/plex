import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';

void main() {
  test('dark semantic surfaces follow Interloop-like page/card mapping', () {
    final PlexColorTokens dark = PlexColorTokens.resolve(
      brightness: Brightness.dark,
      seed: plexDefaultSeedColor,
    );

    expect(dark.surfacePage, const Color(0xFF181D25));
    expect(dark.surfaceCard, const Color(0xFF20262F));
    expect(dark.surfaceSunken, const Color(0xFF2A323F));
    expect(dark.textPrimary, const Color(0xFFEEF0F4));
  });

  test('light and dark semantic surfaces swap', () {
    final PlexColorTokens light = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: plexDefaultSeedColor,
    );
    final PlexColorTokens dark = PlexColorTokens.resolve(
      brightness: Brightness.dark,
      seed: plexDefaultSeedColor,
    );

    expect(light.surfacePage, isNot(dark.surfacePage));
    expect(light.surfaceCard, isNot(dark.surfaceCard));
    expect(light.surfacePage.computeLuminance(), greaterThan(dark.surfacePage.computeLuminance()));
    expect(light.surfaceCard, const Color(0xFFFFFFFF));
    expect(dark.surfacePage, plexDarkSurfacePage);
    expect(dark.surfaceCard, plexDarkSurfaceCard);
  });

  test('dark primary is lightened versus light primary from the same seed', () {
    const Color seed = Color(0xFF607D8B);
    final PlexColorTokens light = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: seed,
    );
    final PlexColorTokens dark = PlexColorTokens.resolve(
      brightness: Brightness.dark,
      seed: seed,
    );

    expect(dark.brandPrimary.computeLuminance(), greaterThan(light.brandPrimary.computeLuminance()));
    expect(
      dark.brandPrimary,
      ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark).primary,
    );
  });

  test('dark text is light on dark surfaces', () {
    final PlexColorTokens dark = PlexColorTokens.resolve(
      brightness: Brightness.dark,
      seed: plexDefaultSeedColor,
    );

    expect(dark.textPrimary.computeLuminance(), greaterThan(dark.surfacePage.computeLuminance()));
    expect(dark.textInverse.computeLuminance(), lessThan(dark.textPrimary.computeLuminance()));
  });
}
