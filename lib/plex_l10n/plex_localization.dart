import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'plex_strings.dart';

/// Configuration for Plex localization.
class PlexLocalizationConfig {
  /// Locales supported by the app.
  final List<Locale> supportedLocales;

  /// Loads [PlexStrings] for the given [locale].
  final PlexStrings Function(Locale locale) translationLoader;

  const PlexLocalizationConfig({
    required this.supportedLocales,
    required this.translationLoader,
  });
}

/// [LocalizationsDelegate] that loads [PlexStrings] via [PlexLocalizationConfig].
class PlexL10nDelegate extends LocalizationsDelegate<PlexStrings> {
  final PlexLocalizationConfig config;

  const PlexL10nDelegate(this.config);

  @override
  bool isSupported(Locale locale) =>
      config.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<PlexStrings> load(Locale locale) =>
      SynchronousFuture<PlexStrings>(config.translationLoader(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<PlexStrings> old) => false;
}

/// Extension to access [PlexStrings] from [BuildContext].
extension PlexL10n on BuildContext {
  /// Returns [PlexStrings] for the current locale, or default English if not found.
  PlexStrings get plexStrings =>
      Localizations.of<PlexStrings>(this, PlexStrings) ?? PlexStrings();
}
