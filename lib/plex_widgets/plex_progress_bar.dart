import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Bar thickness for [PlexProgressBar].
enum PlexProgressBarSize {
  sm,
  md,
  lg,
}

/// Fill color from the Plex semantic palette (not a third-party brand).
enum PlexProgressBarTone {
  brand,
  info,
  success,
  warning,
  danger,
}

/// Horizontal progress / completion bar with optional label and value.
class PlexProgressBar extends StatelessWidget {
  const PlexProgressBar({
    super.key,
    this.value = 0,
    this.max = 100,
    this.label,
    this.showValue = false,
    this.size = PlexProgressBarSize.md,
    this.tone = PlexProgressBarTone.brand,
    this.indeterminate = false,
  });

  /// Current value. Ignored when [indeterminate] is true. Defaults to 0.
  final double value;

  /// Maximum value. Defaults to 100.
  final double max;

  /// Label shown above the bar.
  final String? label;

  /// Show the percentage on the right.
  final bool showValue;

  /// Bar thickness. Defaults to [PlexProgressBarSize.md].
  final PlexProgressBarSize size;

  /// Fill color. Defaults to [PlexProgressBarTone.brand].
  final PlexProgressBarTone tone;

  /// When true, shows an animated bar with no determinate value.
  final bool indeterminate;

  double get _height {
    switch (size) {
      case PlexProgressBarSize.sm:
        return 6;
      case PlexProgressBarSize.md:
        return 9;
      case PlexProgressBarSize.lg:
        return 14;
    }
  }

  Color _fill(PlexColorTokens colors) {
    switch (tone) {
      case PlexProgressBarTone.info:
        return colors.statusInfo;
      case PlexProgressBarTone.success:
        return colors.statusSuccess;
      case PlexProgressBarTone.warning:
        return colors.statusWarning;
      case PlexProgressBarTone.danger:
        return colors.statusDanger;
      case PlexProgressBarTone.brand:
        return colors.brandPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final bool isIndeterminate = indeterminate;
    final double clampedMax = max <= 0 ? 1 : max;
    final double pct = isIndeterminate
        ? 0
        : ((value / clampedMax) * 100).clamp(0, 100).toDouble();
    final Color fill = _fill(colors);
    final Color track = colors.surfaceSunken;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null || (showValue && !isIndeterminate))
          Padding(
            padding: const EdgeInsets.only(bottom: PlexDim.mini + 2),
            child: Row(
              children: [
                if (label != null)
                  Expanded(
                    child: Text(
                      label!,
                      style: TextStyle(
                        fontSize: PlexFontSize.caption,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                if (showValue && !isIndeterminate)
                  Text(
                    '${pct.round()}%',
                    style: TextStyle(
                      fontSize: PlexFontSize.caption,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        Semantics(
          label: label,
          value: isIndeterminate ? null : '${pct.round()}%',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(PlexRadius.pill),
            child: LinearProgressIndicator(
              value: isIndeterminate ? null : pct / 100,
              minHeight: _height,
              color: fill,
              backgroundColor: track,
              borderRadius: BorderRadius.circular(PlexRadius.pill),
            ),
          ),
        ),
      ],
    );
  }
}
