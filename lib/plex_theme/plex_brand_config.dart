import 'package:flutter/material.dart';

/// Visual density for Plex Material themes. Apps opt in via [PlexBrandConfig].
enum PlexDensity {
  comfortable,
  compact,
}

/// Optional additive brand overrides for [PlexApp].
///
/// Logos stay on [PlexAppInfo.appLogo] / [PlexAppInfo.appLogoDark] — this
/// config does not duplicate logo fields.
///
/// Resolution order for colors: widget-level → [PlexBrandConfig] →
/// ColorScheme / seed → generic fallbacks.
class PlexBrandConfig {
  const PlexBrandConfig({
    this.brandPrimary,
    this.brandInk,
    this.success,
    this.warning,
    this.danger,
    this.info,
    this.fontFamily,
    this.density,
  });

  final Color? brandPrimary;
  final Color? brandInk;
  final Color? success;
  final Color? warning;
  final Color? danger;
  final Color? info;

  /// When null, the package default font family (Roboto) is used.
  /// [PlexTheme.appTextTheme] still wins over this when set.
  final String? fontFamily;

  final PlexDensity? density;
}
