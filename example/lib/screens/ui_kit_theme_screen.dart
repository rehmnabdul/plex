import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_card_glass.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitThemeScreen extends StatelessWidget {
  const UiKitThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plex = PlexThemeData.of(context);
    final colors = plex.colors;
    final brightness = Theme.of(context).brightness;

    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "Active theme",
          subtitle: "Resolved from PlexApp.themeFromColor + PlexBrandConfig",
          actions: PlexBadge(
            label: brightness == Brightness.dark ? "Dark" : "Light",
            tone: PlexBadgeTone.info,
            dot: true,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv("Seed", "PlexTheme.defaultSeedColor (#607D8B)"),
              _kv("Density", plex.density.name),
              _kv("Font family", plex.fontFamily),
              _kv("Material 3", "Always on — M2 flags are no-ops"),
              _kv("Lookup", "PlexThemeData.of(context)"),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Brand config",
          subtitle: "Optional additive overrides. Logos stay on PlexAppInfo.",
          child: Text(
            "This example passes density: PlexDensity.comfortable and leaves "
            "brandPrimary, brandInk, and status colors null so seed fallbacks apply.",
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        const ExampleSectionTitle("Surfaces"),
        Wrap(
          spacing: PlexDim.small,
          runSpacing: PlexDim.small,
          children: [
            _Swatch("surfacePage", colors.surfacePage),
            _Swatch("surfaceCard", colors.surfaceCard),
            _Swatch("surfaceSunken", colors.surfaceSunken),
            _Swatch("surfaceHover", colors.surfaceHover),
            _Swatch("brandPrimary", colors.brandPrimary),
            _Swatch("brandInk", colors.brandInk),
          ],
        ),
        const SizedBox(height: PlexDim.medium),
        const ExampleSectionTitle("Status"),
        Wrap(
          spacing: PlexDim.small,
          runSpacing: PlexDim.small,
          children: [
            _Swatch("success", colors.statusSuccess),
            _Swatch("info", colors.statusInfo),
            _Swatch("warning", colors.statusWarning),
            _Swatch("danger", colors.statusDanger),
          ],
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Flat vs glass",
          subtitle: "Default chrome is flat. Glass is opt-in via PlexCardGlassEffect or useBackground.",
          child: Row(
            children: [
              Expanded(
                child: ExampleCard(
                  title: "Flat",
                  child: Text(
                    "PlexCard elevation 0 + token border",
                    style: TextStyle(color: colors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: PlexDim.medium),
              Expanded(
                child: PlexCardGlassEffect(
                  child: Padding(
                    padding: const EdgeInsets.all(PlexDim.medium),
                    child: Text(
                      "PlexCardGlassEffect (opt-in)",
                      style: TextStyle(color: colors.textPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PlexDim.small),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(PlexRadius.md),
              border: Border.all(color: colors.borderSubtle),
            ),
          ),
          const SizedBox(height: PlexDim.mini),
          Text(label, style: TextStyle(fontSize: PlexFontSize.caption, color: colors.textMuted)),
        ],
      ),
    );
  }
}
