import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Presence indicator for [PlexAvatar].
enum PlexAvatarStatus {
  online,
  busy,
  away,
  offline,
}

/// User avatar — image or auto-colored initials, with optional presence dot.
class PlexAvatar extends StatelessWidget {
  const PlexAvatar({
    super.key,
    this.name,
    this.image,
    this.size = 40,
    this.square = false,
    this.status,
    this.ring = false,
  });

  /// Full name — drives initials and the auto background color.
  final String? name;

  /// Image. When set, initials are not shown.
  final ImageProvider? image;

  /// Diameter in logical pixels. Defaults to 40.
  final double size;

  /// Rounded square instead of circle.
  final bool square;

  /// Optional presence indicator.
  final PlexAvatarStatus? status;

  /// Draw a surface-colored ring (for overlapping stacks).
  final bool ring;

  static String initialsFor(String name) {
    final List<String> parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final String first = parts.first[0];
    final String last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Color _toneFor(String seed, PlexColorTokens colors) {
    final List<Color> tones = <Color>[
      colors.brandPrimary,
      colors.brandInk,
      colors.statusInfo,
      colors.statusSuccess,
      colors.statusWarning,
    ];
    int hash = 0;
    for (final int unit in seed.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return tones[hash % tones.length];
  }

  Color _statusColor(PlexColorTokens colors) {
    switch (status!) {
      case PlexAvatarStatus.online:
        return colors.statusSuccess;
      case PlexAvatarStatus.busy:
        return colors.statusDanger;
      case PlexAvatarStatus.away:
        return colors.statusWarning;
      case PlexAvatarStatus.offline:
        return colors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final String resolvedName = name ?? '';
    final String initials = initialsFor(resolvedName);
    final Color background =
        image == null ? _toneFor(resolvedName, colors) : colors.surfaceSunken;
    final BorderRadius radius = BorderRadius.circular(
      square ? PlexRadius.md : PlexRadius.pill,
    );
    final double statusSize = (size * 0.3).clamp(8.0, size);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: background,
              borderRadius: radius,
              boxShadow: ring
                  ? <BoxShadow>[
                      BoxShadow(
                        color: colors.surfaceCard,
                        spreadRadius: 2,
                        blurRadius: 0,
                      ),
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: image != null
                ? Image(
                    image: image!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    semanticLabel: resolvedName.isEmpty ? null : resolvedName,
                  )
                : Text(
                    initials,
                    style: TextStyle(
                      color: colors.textInverse,
                      fontWeight: FontWeight.w700,
                      fontSize: size * 0.4,
                      height: 1,
                    ),
                  ),
          ),
          if (status != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: statusSize,
                height: statusSize,
                decoration: BoxDecoration(
                  color: _statusColor(colors),
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surfaceCard, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
