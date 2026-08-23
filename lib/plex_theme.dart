import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_sp.dart';
import 'package:plex/plex_theme/plex_color_tokens.dart';
import 'package:plex/plex_theme/plex_theme_data.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_material.dart';

export 'package:plex/plex_theme/plex_brand_config.dart';
export 'package:plex/plex_theme/plex_color_tokens.dart';
export 'package:plex/plex_theme/plex_theme_data.dart';

///This class will hold theme related information
class PlexTheme {
  PlexTheme._();

  /// Generic professional blue-gray seed (Material Blue Grey 500, #607D8B).
  ///
  /// Neutral package identity — not Interloop Just Blue (#30A8E0) and not
  /// Interloop Gray Blue (#333B4A). Consuming apps override via
  /// [PlexApp.themeFromColor] or [PlexBrandConfig.brandPrimary].
  static const Color defaultSeedColor = plexDefaultSeedColor;

  static const String defaultFontFamily = 'Roboto';

  /// Extensions produced by [getThemeByBrightness], keyed by brightness.
  /// Context-free getters prefer light so GetMaterialApp building dark last
  /// does not leak dark surfaces into widgets that still use static colors.
  static final Map<Brightness, PlexThemeData> _extensionsByBrightness =
      <Brightness, PlexThemeData>{};

  static PlexThemeData? get _resolvedExtension =>
      _extensionsByBrightness[Brightness.light] ??
      _extensionsByBrightness[Brightness.dark];

  static void _storeExtension(Brightness brightness, PlexThemeData data) {
    _extensionsByBrightness[brightness] = data;
  }

  static Color get selectionColor =>
      _resolvedExtension?.colors.selection ?? const Color(0xFFACCEF7);

  static Color get navigationTagColor =>
      _resolvedExtension?.colors.statusSuccess ?? Colors.lightGreen;

  static Color get navigationTagTextColor =>
      _resolvedExtension?.colors.statusSuccessInk ?? Colors.black;

  static Color get inputErrorColor =>
      _resolvedExtension?.colors.statusDanger ?? const Color(0xFFba1a1a);

  /// Input fill is a surface token. Previously this was accidentally the same
  /// red as [inputErrorColor].
  static Color get inputBackgroundColor =>
      _resolvedExtension?.colors.surfaceSunken ?? const Color(0xFFE8ECF1);

  static ThemeData? appTheme;
  static TextTheme? appTextTheme;

  /// Theme is always Material 3. Prefs key `UseMaterial3` is ignored.
  static bool isMaterial3() => true;

  /// Deprecated no-op. Material 2 is no longer supported.
  @Deprecated(
      'Material 2 is no longer supported. Theme is always Material 3. This is a no-op.')
  static void setMaterial3(bool value) {
    // Intentionally ignored so existing apps still compile without hitting prefs.
  }

  ///Check theme is dark or light
  static bool isDarkMode(BuildContext context) {
    var brightnessMode = getBrightnessMode();
    if (brightnessMode == ThemeMode.system) {
      brightnessMode =
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? ThemeMode.light
              : ThemeMode.dark;
    }
    return brightnessMode == ThemeMode.dark;
  }

  ///Check theme is brightness
  static ThemeMode getBrightnessMode() {
    var themeMode = PlexSp.instance.getInt("UseBrightnessMode") ?? 0;
    return themeMode == 0
        ? ThemeMode.system
        : themeMode == 1
            ? ThemeMode.light
            : ThemeMode.dark;
  }

  ///Set theme brightness
  static void setBrightnessMode(ThemeMode value) {
    PlexSp.instance.setInt(
        "UseBrightnessMode",
        value == ThemeMode.system
            ? 0
            : value == ThemeMode.light
                ? 1
                : 2);
  }

  ///Initial theme data for the app
  static ThemeData getActiveTheme(BuildContext context) => getThemeByBrightness(
      isDarkMode(context) ? Brightness.dark : Brightness.light);

  static TextTheme getTextTheme(BuildContext context) =>
      getActiveTheme(context).textTheme;

  static ThemeData getThemeByBrightness(Brightness brightness) {
    final PlexBrandConfig? brand = _maybeBrandConfig();
    final Color? colorSchemeSeed = _colorSchemeSeed(brightness);
    final ColorScheme? colorScheme = _imageColorScheme(brightness);
    final PlexThemeData plexExtension = _buildExtension(
      brightness,
      seed: colorSchemeSeed,
      colorScheme: colorScheme,
      brand: brand,
    );
    _storeExtension(brightness, plexExtension);

    if (PlexTheme.appTheme != null) {
      return _mergeExtensionOnto(
        PlexTheme.appTheme!,
        plexExtension,
        brightness,
      );
    }

    Color? textColor = Brightness.dark == brightness ? Colors.white : null;

    return ThemeData(
      colorSchemeSeed: colorSchemeSeed,
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: plexExtension.fontFamily,
      visualDensity: plexExtension.visualDensity,
      scaffoldBackgroundColor: plexExtension.colors.surfacePage,
      appBarTheme: AppBarTheme(
        toolbarHeight: PlexLayout.topbarHeight,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: plexExtension.colors.surfaceCard,
        foregroundColor: plexExtension.colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: plexExtension.colors.borderSubtle),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
          labelTextStyle:
              const TextStyle(fontSize: PlexFontSize.smallest).getState()),
      brightness: brightness,
      textTheme: _textThemeFor(brightness, textColor),
      extensions: <ThemeExtension<dynamic>>[plexExtension],
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: plexExtension.colors.brandPrimary,
          foregroundColor: plexExtension.colors.textInverse,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PlexRadius.md),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: plexExtension.colors.brandPrimary,
          foregroundColor: plexExtension.colors.textInverse,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PlexRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: plexExtension.colors.brandPrimary,
          side: BorderSide(color: plexExtension.colors.borderDefault),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PlexRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: plexExtension.colors.brandPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: plexExtension.colors.surfaceSunken,
        errorStyle: TextStyle(color: plexExtension.colors.statusDanger),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PlexRadius.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PlexRadius.md),
          borderSide:
              BorderSide(color: plexExtension.colors.borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PlexRadius.md),
          borderSide: BorderSide(color: plexExtension.colors.statusDanger),
        ),
      ),
      cardTheme: CardThemeData(
        color: plexExtension.colors.surfaceCard,
        surfaceTintColor: Colors.transparent,
        shadowColor: plexExtension.colors.brandInk.withValues(alpha: 0.12),
        elevation: PlexElevation.sm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PlexRadius.lg),
          side: BorderSide(color: plexExtension.colors.borderSubtle),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: plexExtension.colors.surfaceCard,
        surfaceTintColor: Colors.transparent,
        elevation: PlexElevation.lg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PlexRadius.lg),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: plexExtension.colors.surfaceCard,
        surfaceTintColor: Colors.transparent,
        elevation: PlexElevation.lg,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(PlexRadius.xl)),
        ),
      ),
    );
  }

  static Color randomColor() {
    var colorLimit = 225;
    return ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, Random().nextInt(colorLimit),
                Random().nextInt(colorLimit), Random().nextInt(colorLimit)))
        .primary;
  }

  static PlexThemeData _buildExtension(
    Brightness brightness, {
    Color? seed,
    ColorScheme? colorScheme,
    PlexBrandConfig? brand,
  }) {
    return PlexThemeData.resolve(
      brightness: brightness,
      seed: seed ?? _colorSchemeSeed(brightness) ?? defaultSeedColor,
      colorScheme: colorScheme ?? _imageColorScheme(brightness),
      brand: brand ?? _maybeBrandConfig(),
    );
  }

  static ThemeData _mergeExtensionOnto(
    ThemeData base,
    PlexThemeData fallbackExtension,
    Brightness brightness,
  ) {
    final PlexThemeData existing =
        base.extension<PlexThemeData>() ?? fallbackExtension;
    final PlexThemeData merged = PlexThemeData(
      colors: existing.colors,
      fontFamily: existing.fontFamily,
      density: existing.density,
    );
    _storeExtension(brightness, merged);
    final List<ThemeExtension<dynamic>> extensions =
        <ThemeExtension<dynamic>>[];
    for (final ThemeExtension<dynamic> ext in base.extensions.values) {
      if (ext is! PlexThemeData) {
        extensions.add(ext);
      }
    }
    extensions.add(merged);
    ThemeData result = base.copyWith(
      extensions: extensions,
    );
    if (PlexTheme.appTextTheme != null) {
      Color? textColor = Brightness.dark == brightness ? Colors.white : null;
      result = result.copyWith(textTheme: _textThemeFor(brightness, textColor));
    }
    return result;
  }

  static TextTheme? _textThemeFor(Brightness brightness, Color? textColor) {
    final TextTheme? base = PlexTheme.appTextTheme;
    if (base == null) return null;
    if (textColor == null) return base;
    return base.apply(bodyColor: textColor, displayColor: textColor);
  }

  static PlexBrandConfig? _maybeBrandConfig() {
    try {
      return PlexApp.app.brandConfig;
    } catch (_) {
      return null;
    }
  }

  static Color? _colorSchemeSeed(Brightness brightness) {
    try {
      return brightness == Brightness.dark
          ? PlexApp.app.themeFromColor
          : PlexApp.app.themeFromImage == null
              ? PlexApp.app.themeFromColor
              : null;
    } catch (_) {
      return defaultSeedColor;
    }
  }

  static ColorScheme? _imageColorScheme(Brightness brightness) {
    try {
      return brightness == Brightness.dark
          ? null
          : PlexApp.app.themeFromImage == null
              ? null
              : PlexApp.app.imageColorScheme;
    } catch (_) {
      return null;
    }
  }
}
