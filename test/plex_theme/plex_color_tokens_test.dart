import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plex/plex_theme.dart';

void main() {
  test('seed derives primary from ColorScheme.fromSeed', () {
    const Color seed = Color(0xFF607D8B);
    final PlexColorTokens tokens = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: seed,
    );
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: seed);

    expect(tokens.brandPrimary, scheme.primary);
    expect(tokens.surfaceBrand, scheme.primary);
    expect(tokens.borderFocus, scheme.primary);
    expect(tokens.statusDanger, scheme.error);
    expect(tokens.statusInfo, scheme.primary);
  });

  test('different seeds derive different primaries', () {
    final PlexColorTokens blueGray = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: const Color(0xFF607D8B),
    );
    final PlexColorTokens red = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: const Color(0xFFB71C1C),
    );

    expect(blueGray.brandPrimary, isNot(red.brandPrimary));
    expect(blueGray.statusInfo, isNot(red.statusInfo));
  });

  test('null seed falls back to generic default seed', () {
    final PlexColorTokens tokens = PlexColorTokens.resolve(
      brightness: Brightness.light,
    );
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: plexDefaultSeedColor);

    expect(tokens.brandPrimary, scheme.primary);
    expect(plexDefaultSeedColor, const Color(0xFF607D8B));
  });

  test('semantic roles exist for surface text border brand status ring', () {
    final PlexColorTokens tokens = PlexColorTokens.resolve(
      brightness: Brightness.light,
      seed: plexDefaultSeedColor,
    );

    expect(tokens.surfacePage, isNot(tokens.surfaceCard));
    expect(tokens.textPrimary, isNot(tokens.textMuted));
    expect(tokens.borderDefault, isNot(tokens.borderFocus));
    expect(tokens.brandPrimary, isNot(tokens.brandInk));
    expect(tokens.statusSuccess, isNot(tokens.statusDanger));
    expect(tokens.ring, isNot(tokens.surfacePage));
    expect(tokens.neutral.shade50, isNot(tokens.neutral.shade950));
    expect(tokens.brand.shade500, isNot(tokens.brand.shade50));
  });

  test('input fill fallback is a surface, not error red', () {
    expect(PlexTheme.inputBackgroundColor, isNot(const Color(0xFFba1a1a)));
    expect(PlexTheme.inputBackgroundColor, const Color(0xFFE8ECF1));
    expect(PlexTheme.inputErrorColor, const Color(0xFFba1a1a));
  });
}
