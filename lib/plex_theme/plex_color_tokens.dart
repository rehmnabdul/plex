import 'package:flutter/material.dart';
import 'package:plex/plex_theme/plex_brand_config.dart';

/// Generic professional blue-gray seed (Material Blue Grey 500, #607D8B).
///
/// Neutral package identity — not Interloop Just Blue (#30A8E0) and not
/// Interloop Gray Blue (#333B4A). Consuming apps override via
/// [PlexApp.themeFromColor] or [PlexBrandConfig.brandPrimary].
const Color plexDefaultSeedColor = Color(0xFF607D8B);

/// Dark page surface (~Interloop `.dark` `--background` / grayblue-950).
const Color plexDarkSurfacePage = Color(0xFF181D25);

/// Dark card surface (~Interloop `.dark` `--card` / grayblue-900).
const Color plexDarkSurfaceCard = Color(0xFF20262F);

/// Dark sunken / muted surface (~Interloop `.dark` `--secondary`).
const Color plexDarkSurfaceSunken = Color(0xFF2A323F);

/// Dark primary text (~Interloop `.dark` `--foreground`).
const Color plexDarkTextPrimary = Color(0xFFEEF0F4);

Color _lerp(Color a, Color b, double t) => Color.lerp(a, b, t)!;

/// 11-stop ramp (50–950), mirroring typical design-token structure.
class PlexColorRamp {
  const PlexColorRamp({
    required this.shade50,
    required this.shade100,
    required this.shade200,
    required this.shade300,
    required this.shade400,
    required this.shade500,
    required this.shade600,
    required this.shade700,
    required this.shade800,
    required this.shade900,
    required this.shade950,
  });

  final Color shade50;
  final Color shade100;
  final Color shade200;
  final Color shade300;
  final Color shade400;
  final Color shade500;
  final Color shade600;
  final Color shade700;
  final Color shade800;
  final Color shade900;
  final Color shade950;

  /// Tints and shades around [anchor] (typically shade 500 / 700).
  factory PlexColorRamp.fromAnchor(Color anchor, {double anchorStop = 0.5}) {
    return PlexColorRamp(
      shade50: _lerp(anchor, Colors.white, 0.94),
      shade100: _lerp(anchor, Colors.white, 0.88),
      shade200: _lerp(anchor, Colors.white, 0.72),
      shade300: _lerp(anchor, Colors.white, 0.52),
      shade400: _lerp(anchor, Colors.white, 0.28),
      shade500: anchorStop <= 0.55 ? anchor : _lerp(anchor, Colors.white, 0.12),
      shade600: _lerp(anchor, Colors.black, 0.18),
      shade700: _lerp(anchor, Colors.black, 0.32),
      shade800: _lerp(anchor, Colors.black, 0.48),
      shade900: _lerp(anchor, Colors.black, 0.62),
      shade950: _lerp(anchor, Colors.black, 0.74),
    );
  }

  PlexColorRamp lerp(PlexColorRamp other, double t) {
    return PlexColorRamp(
      shade50: _lerp(shade50, other.shade50, t),
      shade100: _lerp(shade100, other.shade100, t),
      shade200: _lerp(shade200, other.shade200, t),
      shade300: _lerp(shade300, other.shade300, t),
      shade400: _lerp(shade400, other.shade400, t),
      shade500: _lerp(shade500, other.shade500, t),
      shade600: _lerp(shade600, other.shade600, t),
      shade700: _lerp(shade700, other.shade700, t),
      shade800: _lerp(shade800, other.shade800, t),
      shade900: _lerp(shade900, other.shade900, t),
      shade950: _lerp(shade950, other.shade950, t),
    );
  }
}

/// Semantic color tokens: ramps plus surface / text / border / brand / status / ring.
///
/// Structure follows a typical admin design system. Hex values are generic
/// (or seed-derived), not a third-party brand identity.
class PlexColorTokens {
  const PlexColorTokens({
    required this.neutral,
    required this.brand,
    required this.surfacePage,
    required this.surfaceCard,
    required this.surfaceSunken,
    required this.surfaceHover,
    required this.surfaceInverse,
    required this.surfaceBrand,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.textInverse,
    required this.textLink,
    required this.textBrand,
    required this.brandPrimary,
    required this.brandPrimaryHover,
    required this.brandPrimaryActive,
    required this.brandInk,
    required this.brandInkHover,
    required this.borderSubtle,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderFocus,
    required this.statusSuccess,
    required this.statusSuccessSoft,
    required this.statusSuccessInk,
    required this.statusInfo,
    required this.statusInfoSoft,
    required this.statusInfoInk,
    required this.statusWarning,
    required this.statusWarningSoft,
    required this.statusWarningInk,
    required this.statusDanger,
    required this.statusDangerSoft,
    required this.statusDangerInk,
    required this.ring,
    required this.selection,
  });

  final PlexColorRamp neutral;
  final PlexColorRamp brand;

  final Color surfacePage;
  final Color surfaceCard;
  final Color surfaceSunken;
  final Color surfaceHover;
  final Color surfaceInverse;
  final Color surfaceBrand;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  final Color textInverse;
  final Color textLink;
  final Color textBrand;

  final Color brandPrimary;
  final Color brandPrimaryHover;
  final Color brandPrimaryActive;
  final Color brandInk;
  final Color brandInkHover;

  final Color borderSubtle;
  final Color borderDefault;
  final Color borderStrong;
  final Color borderFocus;

  final Color statusSuccess;
  final Color statusSuccessSoft;
  final Color statusSuccessInk;
  final Color statusInfo;
  final Color statusInfoSoft;
  final Color statusInfoInk;
  final Color statusWarning;
  final Color statusWarningSoft;
  final Color statusWarningInk;
  final Color statusDanger;
  final Color statusDangerSoft;
  final Color statusDangerInk;

  final Color ring;
  final Color selection;

  /// Generic Material-style status fallbacks (not Interloop Earth / Sun / Red).
  static const Color fallbackSuccess = Color(0xFF2E7D32);
  static const Color fallbackSuccessSoft = Color(0xFFE8F5E9);
  static const Color fallbackSuccessInk = Color(0xFF1B5E20);
  static const Color fallbackWarning = Color(0xFFED6C02);
  static const Color fallbackWarningSoft = Color(0xFFFFF3E0);
  static const Color fallbackWarningInk = Color(0xFFE65100);
  static const Color fallbackDanger = Color(0xFFD32F2F);
  static const Color fallbackDangerSoft = Color(0xFFFFEBEE);
  static const Color fallbackDangerInk = Color(0xFFB71C1C);

  static const Color _lightPage = Color(0xFFF5F7FA);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightSunken = Color(0xFFE8ECF1);
  static const Color _lightInk = Color(0xFF3E4C5A);

  /// Resolve tokens from optional widget/brand/seed layers.
  ///
  /// [widgetColors] is reserved for call sites that already computed a
  /// widget-level override; non-null fields on [brand] win over seed.
  static PlexColorTokens resolve({
    required Brightness brightness,
    Color? seed,
    ColorScheme? colorScheme,
    PlexBrandConfig? brand,
    PlexColorTokens? widgetColors,
  }) {
    if (widgetColors != null) return widgetColors;

    final Color resolvedSeed = brand?.brandPrimary ?? seed ?? plexDefaultSeedColor;
    final ColorScheme scheme = colorScheme ??
        ColorScheme.fromSeed(seedColor: resolvedSeed, brightness: brightness);
    final bool dark = brightness == Brightness.dark;

    final Color primary = brand?.brandPrimary ?? scheme.primary;
    final PlexColorRamp brandRamp = PlexColorRamp.fromAnchor(primary);
    final Color inkAnchor = brand?.brandInk ?? (dark ? plexDarkTextPrimary : _lightInk);
    final PlexColorRamp neutralRamp = PlexColorRamp.fromAnchor(inkAnchor, anchorStop: 0.7);

    final Color success = brand?.success ?? fallbackSuccess;
    final Color warning = brand?.warning ?? fallbackWarning;
    final Color danger = brand?.danger ?? scheme.error;
    final Color info = brand?.info ?? primary;

    final Color page = dark ? plexDarkSurfacePage : _lightPage;
    final Color card = dark ? plexDarkSurfaceCard : _lightCard;
    final Color sunken = dark ? plexDarkSurfaceSunken : _lightSunken;

    return PlexColorTokens(
      neutral: neutralRamp,
      brand: brandRamp,
      surfacePage: page,
      surfaceCard: card,
      surfaceSunken: sunken,
      surfaceHover: dark ? plexDarkSurfaceSunken : _lightPage,
      surfaceInverse: dark ? _lightSunken : neutralRamp.shade700,
      surfaceBrand: primary,
      textPrimary: dark ? plexDarkTextPrimary : inkAnchor,
      textSecondary: dark ? neutralRamp.shade300 : neutralRamp.shade500,
      textMuted: dark ? const Color(0xFFAEB4C0) : neutralRamp.shade400,
      textDisabled: dark ? neutralRamp.shade600 : neutralRamp.shade300,
      textInverse: dark ? plexDarkSurfacePage : Colors.white,
      textLink: dark ? brandRamp.shade400 : brandRamp.shade600,
      textBrand: dark ? brandRamp.shade400 : brandRamp.shade600,
      brandPrimary: primary,
      brandPrimaryHover: dark ? brandRamp.shade300 : brandRamp.shade600,
      brandPrimaryActive: dark ? brandRamp.shade200 : brandRamp.shade700,
      brandInk: inkAnchor,
      brandInkHover: dark ? _lerp(inkAnchor, Colors.white, 0.08) : _lerp(inkAnchor, Colors.black, 0.12),
      borderSubtle: dark ? const Color(0x1FFFFFFF) : neutralRamp.shade100,
      borderDefault: dark ? const Color(0x1FFFFFFF) : neutralRamp.shade200,
      borderStrong: dark ? const Color(0x29FFFFFF) : neutralRamp.shade300,
      borderFocus: primary,
      statusSuccess: dark ? _lerp(success, Colors.white, 0.18) : success,
      statusSuccessSoft: dark ? _lerp(success, card, 0.82) : fallbackSuccessSoft,
      statusSuccessInk: dark ? _lerp(fallbackSuccessInk, Colors.white, 0.55) : fallbackSuccessInk,
      statusInfo: dark ? _lerp(info, Colors.white, 0.18) : info,
      statusInfoSoft: dark ? _lerp(info, card, 0.82) : brandRamp.shade100,
      statusInfoInk: dark ? brandRamp.shade300 : brandRamp.shade700,
      statusWarning: dark ? _lerp(warning, Colors.white, 0.18) : warning,
      statusWarningSoft: dark ? _lerp(warning, card, 0.82) : fallbackWarningSoft,
      statusWarningInk: dark ? _lerp(fallbackWarningInk, Colors.white, 0.55) : fallbackWarningInk,
      statusDanger: dark ? _lerp(danger, Colors.white, 0.12) : danger,
      statusDangerSoft: dark ? _lerp(danger, card, 0.82) : fallbackDangerSoft,
      statusDangerInk: dark ? _lerp(fallbackDangerInk, Colors.white, 0.5) : fallbackDangerInk,
      ring: primary.withValues(alpha: 0.35),
      selection: dark ? primary.withValues(alpha: 0.35) : brandRamp.shade200,
    );
  }

  static PlexColorTokens fallback({Brightness brightness = Brightness.light}) {
    return PlexColorTokens.resolve(brightness: brightness);
  }

  PlexColorTokens lerp(PlexColorTokens other, double t) {
    return PlexColorTokens(
      neutral: neutral.lerp(other.neutral, t),
      brand: brand.lerp(other.brand, t),
      surfacePage: _lerp(surfacePage, other.surfacePage, t),
      surfaceCard: _lerp(surfaceCard, other.surfaceCard, t),
      surfaceSunken: _lerp(surfaceSunken, other.surfaceSunken, t),
      surfaceHover: _lerp(surfaceHover, other.surfaceHover, t),
      surfaceInverse: _lerp(surfaceInverse, other.surfaceInverse, t),
      surfaceBrand: _lerp(surfaceBrand, other.surfaceBrand, t),
      textPrimary: _lerp(textPrimary, other.textPrimary, t),
      textSecondary: _lerp(textSecondary, other.textSecondary, t),
      textMuted: _lerp(textMuted, other.textMuted, t),
      textDisabled: _lerp(textDisabled, other.textDisabled, t),
      textInverse: _lerp(textInverse, other.textInverse, t),
      textLink: _lerp(textLink, other.textLink, t),
      textBrand: _lerp(textBrand, other.textBrand, t),
      brandPrimary: _lerp(brandPrimary, other.brandPrimary, t),
      brandPrimaryHover: _lerp(brandPrimaryHover, other.brandPrimaryHover, t),
      brandPrimaryActive: _lerp(brandPrimaryActive, other.brandPrimaryActive, t),
      brandInk: _lerp(brandInk, other.brandInk, t),
      brandInkHover: _lerp(brandInkHover, other.brandInkHover, t),
      borderSubtle: _lerp(borderSubtle, other.borderSubtle, t),
      borderDefault: _lerp(borderDefault, other.borderDefault, t),
      borderStrong: _lerp(borderStrong, other.borderStrong, t),
      borderFocus: _lerp(borderFocus, other.borderFocus, t),
      statusSuccess: _lerp(statusSuccess, other.statusSuccess, t),
      statusSuccessSoft: _lerp(statusSuccessSoft, other.statusSuccessSoft, t),
      statusSuccessInk: _lerp(statusSuccessInk, other.statusSuccessInk, t),
      statusInfo: _lerp(statusInfo, other.statusInfo, t),
      statusInfoSoft: _lerp(statusInfoSoft, other.statusInfoSoft, t),
      statusInfoInk: _lerp(statusInfoInk, other.statusInfoInk, t),
      statusWarning: _lerp(statusWarning, other.statusWarning, t),
      statusWarningSoft: _lerp(statusWarningSoft, other.statusWarningSoft, t),
      statusWarningInk: _lerp(statusWarningInk, other.statusWarningInk, t),
      statusDanger: _lerp(statusDanger, other.statusDanger, t),
      statusDangerSoft: _lerp(statusDangerSoft, other.statusDangerSoft, t),
      statusDangerInk: _lerp(statusDangerInk, other.statusDangerInk, t),
      ring: _lerp(ring, other.ring, t),
      selection: _lerp(selection, other.selection, t),
    );
  }
}
