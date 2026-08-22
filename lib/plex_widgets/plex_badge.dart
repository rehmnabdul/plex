import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Semantic tone for [PlexBadge].
enum PlexBadgeTone {
  neutral,
  info,
  success,
  warning,
  danger,
}

/// Fill style for [PlexBadge].
enum PlexBadgeAppearance {
  soft,
  solid,
  outline,
}

/// Compact status or category label.
class PlexBadge extends StatelessWidget {
  const PlexBadge({
    super.key,
    required this.label,
    this.tone = PlexBadgeTone.neutral,
    this.appearance = PlexBadgeAppearance.soft,
    this.dot = false,
    this.square = false,
  });

  final String label;
  final PlexBadgeTone tone;
  final PlexBadgeAppearance appearance;
  final bool dot;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final ({Color background, Color foreground, Color border}) resolved =
        _colorsFor(colors);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: PlexDim.smallest,
      ),
      decoration: BoxDecoration(
        color: resolved.background,
        border: Border.all(color: resolved.border),
        borderRadius: BorderRadius.circular(
          square ? PlexRadius.sm : PlexRadius.pill,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: resolved.foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: resolved.foreground,
              fontSize: PlexFontSize.small,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  ({Color background, Color foreground, Color border}) _colorsFor(
    PlexColorTokens colors,
  ) {
    final Color fill;
    final Color ink;
    final Color outline;
    switch (tone) {
      case PlexBadgeTone.neutral:
        fill = colors.surfaceSunken;
        ink = colors.textSecondary;
        outline = colors.borderDefault;
        break;
      case PlexBadgeTone.info:
        fill = colors.statusInfoSoft;
        ink = colors.statusInfoInk;
        outline = colors.statusInfo;
        break;
      case PlexBadgeTone.success:
        fill = colors.statusSuccessSoft;
        ink = colors.statusSuccessInk;
        outline = colors.statusSuccess;
        break;
      case PlexBadgeTone.warning:
        fill = colors.statusWarningSoft;
        ink = colors.statusWarningInk;
        outline = colors.statusWarning;
        break;
      case PlexBadgeTone.danger:
        fill = colors.statusDangerSoft;
        ink = colors.statusDangerInk;
        outline = colors.statusDanger;
        break;
    }

    switch (appearance) {
      case PlexBadgeAppearance.soft:
        return (background: fill, foreground: ink, border: Colors.transparent);
      case PlexBadgeAppearance.solid:
        return (
          background: tone == PlexBadgeTone.neutral ? colors.brandInk : outline,
          foreground: colors.textInverse,
          border: Colors.transparent,
        );
      case PlexBadgeAppearance.outline:
        return (
          background: Colors.transparent,
          foreground: ink,
          border: outline,
        );
    }
  }
}
