import 'package:flutter/material.dart';

/// Configuration for Plex accessibility features.
class PlexAccessibilityConfig {
  /// Forces high-contrast [ColorScheme].
  final bool highContrast;

  /// Applies 1.3× text scale factor.
  final bool largeText;

  /// Disables PlexBackground animations.
  final bool reduceMotion;

  const PlexAccessibilityConfig({
    this.highContrast = false,
    this.largeText = false,
    this.reduceMotion = false,
  });

  /// Default config with all options disabled.
  static const PlexAccessibilityConfig defaults = PlexAccessibilityConfig();
}

/// [InheritedWidget] that provides [PlexAccessibilityConfig] to the subtree.
class PlexAccessibilityWidget extends InheritedWidget {
  final PlexAccessibilityConfig config;

  const PlexAccessibilityWidget({
    super.key,
    required this.config,
    required super.child,
  });

  static PlexAccessibilityConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PlexAccessibilityWidget>()?.config;
  }

  @override
  bool updateShouldNotify(PlexAccessibilityWidget oldWidget) =>
      config.highContrast != oldWidget.config.highContrast ||
      config.largeText != oldWidget.config.largeText ||
      config.reduceMotion != oldWidget.config.reduceMotion;
}

/// Extension to access [PlexAccessibilityConfig] from [BuildContext].
extension PlexA11y on BuildContext {
  /// Returns [PlexAccessibilityConfig] from the nearest [PlexAccessibilityWidget],
  /// or [PlexAccessibilityConfig.defaults] when absent.
  PlexAccessibilityConfig get plexA11y =>
      PlexAccessibilityWidget.of(this) ?? PlexAccessibilityConfig.defaults;
}
