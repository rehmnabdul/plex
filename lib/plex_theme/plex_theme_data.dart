import 'package:flutter/material.dart';
import 'package:plex/plex_theme/plex_brand_config.dart';
import 'package:plex/plex_theme/plex_color_tokens.dart';

/// Theme extension attached to [ThemeData] by [PlexTheme.getThemeByBrightness].
///
/// Named [PlexThemeData] to match Flutter's [ThemeData] convention and avoid
/// colliding with the existing [PlexTheme] facade class.
class PlexThemeData extends ThemeExtension<PlexThemeData> {
  const PlexThemeData({
    required this.colors,
    this.fontFamily = 'Roboto',
    this.density = PlexDensity.comfortable,
  });

  final PlexColorTokens colors;
  final String fontFamily;
  final PlexDensity density;

  /// Never-null lookup: missing extension yields generic fallbacks.
  static PlexThemeData of(BuildContext context) {
    return Theme.of(context).extension<PlexThemeData>() ??
        PlexThemeData.fallback(brightness: Theme.of(context).brightness);
  }

  static PlexThemeData fallback({Brightness brightness = Brightness.light}) {
    return PlexThemeData(
      colors: PlexColorTokens.fallback(brightness: brightness),
    );
  }

  /// Build tokens from brand / seed / scheme. [existing] wins field-by-field
  /// where it is already populated (merge with fallbacks).
  static PlexThemeData resolve({
    required Brightness brightness,
    Color? seed,
    ColorScheme? colorScheme,
    PlexBrandConfig? brand,
    PlexThemeData? existing,
    PlexColorTokens? widgetColors,
  }) {
    final PlexColorTokens colors = existing?.colors ??
        PlexColorTokens.resolve(
          brightness: brightness,
          seed: seed,
          colorScheme: colorScheme,
          brand: brand,
          widgetColors: widgetColors,
        );
    return PlexThemeData(
      colors: colors,
      fontFamily: existing?.fontFamily ?? brand?.fontFamily ?? 'Roboto',
      density: existing?.density ?? brand?.density ?? PlexDensity.comfortable,
    );
  }

  VisualDensity get visualDensity {
    return density == PlexDensity.compact ? VisualDensity.compact : VisualDensity.standard;
  }

  @override
  PlexThemeData copyWith({
    PlexColorTokens? colors,
    String? fontFamily,
    PlexDensity? density,
  }) {
    return PlexThemeData(
      colors: colors ?? this.colors,
      fontFamily: fontFamily ?? this.fontFamily,
      density: density ?? this.density,
    );
  }

  @override
  PlexThemeData lerp(ThemeExtension<PlexThemeData>? other, double t) {
    if (other is! PlexThemeData) return this;
    return PlexThemeData(
      colors: colors.lerp(other.colors, t),
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      density: t < 0.5 ? density : other.density,
    );
  }
}
