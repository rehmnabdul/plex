/// Dashboard KPI widgets. Anatomy inspired by a typical admin design system;
/// tokens from [PlexThemeData].
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Signed change direction for a KPI delta.
enum PlexStatDirection {
  up,
  down,
  flat,
}

/// Fill treatment for [PlexStatCard] / [PlexStatTile].
enum PlexStatSurface {
  standard,
  brand,
  accent,
}

/// Icon tile tint.
enum PlexStatIconTone {
  info,
  success,
  warning,
  danger,
}

/// Optional left-edge accent stripe.
enum PlexStatStripe {
  brand,
  success,
  warning,
  danger,
}

/// Standalone KPI card (bordered shell around [PlexStatTile] anatomy).
class PlexStatCard extends StatelessWidget {
  const PlexStatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.hint,
    this.delta,
    this.direction = PlexStatDirection.flat,
    this.invert = false,
    this.icon,
    this.iconTone = PlexStatIconTone.info,
    this.tone = PlexStatSurface.standard,
    this.stripe,
    this.progress,
    this.onTap,
    this.child,
  });

  final String label;
  final String value;
  final String? unit;
  final String? hint;
  final String? delta;
  final PlexStatDirection direction;
  final bool invert;
  final IconData? icon;
  final PlexStatIconTone iconTone;
  final PlexStatSurface tone;
  final PlexStatStripe? stripe;
  final double? progress;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _PlexStatBody(
      label: label,
      value: value,
      unit: unit,
      hint: hint,
      delta: delta,
      direction: direction,
      invert: invert,
      icon: icon,
      iconTone: iconTone,
      tone: tone,
      stripe: stripe,
      progress: progress,
      onTap: onTap,
      extra: child,
      card: true,
      dense: false,
    );
  }
}

/// Denser KPI tile without card chrome — use inside [PlexStatGrid].
class PlexStatTile extends StatelessWidget {
  const PlexStatTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.hint,
    this.delta,
    this.direction = PlexStatDirection.flat,
    this.invert = false,
    this.icon,
    this.iconTone = PlexStatIconTone.info,
    this.tone = PlexStatSurface.standard,
    this.stripe,
    this.progress,
    this.onTap,
    this.child,
  });

  final String label;
  final String value;
  final String? unit;
  final String? hint;
  final String? delta;
  final PlexStatDirection direction;
  final bool invert;
  final IconData? icon;
  final PlexStatIconTone iconTone;
  final PlexStatSurface tone;
  final PlexStatStripe? stripe;
  final double? progress;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _PlexStatBody(
      label: label,
      value: value,
      unit: unit,
      hint: hint,
      delta: delta,
      direction: direction,
      invert: invert,
      icon: icon,
      iconTone: iconTone,
      tone: tone,
      stripe: stripe,
      progress: progress,
      onTap: onTap,
      extra: child,
      card: false,
      dense: true,
    );
  }
}

/// Hairline-divided responsive grid of KPI tiles.
class PlexStatGrid extends StatelessWidget {
  const PlexStatGrid({
    super.key,
    required this.children,
    this.columns = 4,
    this.minWidth = 200,
  });

  final List<Widget> children;
  final int columns;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border.all(color: colors.borderSubtle),
        borderRadius: BorderRadius.circular(PlexRadius.lg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PlexRadius.lg),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int maxCols = columns < 1 ? 1 : columns;
            final int fit = constraints.maxWidth.isFinite
                ? (constraints.maxWidth / minWidth).floor().clamp(1, maxCols)
                : maxCols;
            final List<Widget> rows = <Widget>[];
            for (int i = 0; i < children.length; i += fit) {
              final List<Widget> cells = <Widget>[];
              for (int j = 0; j < fit; j++) {
                final int index = i + j;
                cells.add(
                  Expanded(
                    child: index < children.length
                        ? children[index]
                        : const SizedBox.shrink(),
                  ),
                );
                if (j < fit - 1) {
                  cells.add(
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: colors.borderSubtle,
                    ),
                  );
                }
              }
              if (rows.isNotEmpty) {
                rows.add(Divider(height: 1, thickness: 1, color: colors.borderSubtle));
              }
              rows.add(
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cells,
                  ),
                ),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: rows,
            );
          },
        ),
      ),
    );
  }
}

/// Circular percentage. Distinct from the horizontal [PlexProgressBar].
class PlexProgressRing extends StatelessWidget {
  const PlexProgressRing({
    super.key,
    required this.value,
    this.max = 100,
    this.size = 132,
    this.thickness = 12,
    this.label,
    this.caption,
    this.display,
  });

  final double value;
  final double max;
  final double size;
  final double thickness;
  final String? label;
  final String? caption;
  final String? display;

  double get _pct {
    if (max <= 0) return 0;
    return (value / max).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final int percent = (_pct * 100).round();
    final String centre = display ?? '$percent%';

    return Semantics(
      label: '$percent percent',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size.square(size),
                  painter: _PlexProgressRingPainter(
                    progress: _pct,
                    track: colors.surfaceSunken,
                    arc: colors.brandPrimary,
                    thickness: thickness,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      centre,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: PlexFontSize.extraLarge,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    if (label != null) ...[
                      const SizedBox(height: PlexDim.mini),
                      Text(
                        label!,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: PlexFontSize.smallest,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: PlexDim.small),
            Text(
              caption!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: PlexFontSize.small,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlexStatBody extends StatelessWidget {
  const _PlexStatBody({
    required this.label,
    required this.value,
    required this.unit,
    required this.hint,
    required this.delta,
    required this.direction,
    required this.invert,
    required this.icon,
    required this.iconTone,
    required this.tone,
    required this.stripe,
    required this.progress,
    required this.onTap,
    required this.extra,
    required this.card,
    required this.dense,
  });

  final String label;
  final String value;
  final String? unit;
  final String? hint;
  final String? delta;
  final PlexStatDirection direction;
  final bool invert;
  final IconData? icon;
  final PlexStatIconTone iconTone;
  final PlexStatSurface tone;
  final PlexStatStripe? stripe;
  final double? progress;
  final VoidCallback? onTap;
  final Widget? extra;
  final bool card;
  final bool dense;

  bool? get _good {
    if (direction == PlexStatDirection.flat) return null;
    final bool upIsGood = !invert;
    return direction == PlexStatDirection.up ? upIsGood : !upIsGood;
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final ({Color background, Color foreground, Color muted}) surface =
        _surfaceColors(colors);

    Widget content = Padding(
      padding: EdgeInsets.all(dense ? PlexDim.smallMedium : PlexDim.mediumPlus),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        color: surface.muted,
                        fontSize: PlexFontSize.smallest,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: PlexDim.small),
                    Text.rich(
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          color: surface.foreground,
                          fontSize: dense
                              ? PlexFontSize.extraLarge
                              : PlexFontSize.displaySmall,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                        children: [
                          if (unit != null)
                            TextSpan(
                              text: ' $unit',
                              style: TextStyle(
                                fontSize: PlexFontSize.body,
                                fontWeight: FontWeight.w700,
                                color: surface.muted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (delta != null || hint != null) ...[
                      const SizedBox(height: PlexDim.small),
                      Wrap(
                        spacing: PlexDim.small,
                        runSpacing: PlexDim.smallest,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (delta != null) _deltaChip(colors, surface),
                          if (hint != null)
                            Text(
                              hint!,
                              style: TextStyle(
                                color: surface.muted,
                                fontSize: PlexFontSize.small,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: PlexDim.small),
                _iconTile(colors, surface),
              ],
            ],
          ),
          if (extra != null) ...[
            const SizedBox(height: PlexDim.smallMedium),
            extra!,
          ],
          if (progress != null) ...[
            const SizedBox(height: PlexDim.smallMedium),
            _progressBar(colors),
          ],
        ],
      ),
    );

    if (stripe != null) {
      content = Stack(
        children: [
          content,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              color: _stripeColor(colors),
            ),
          ),
        ],
      );
    }

    if (card) {
      content = Material(
        color: surface.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PlexRadius.lg),
          side: BorderSide(color: colors.borderSubtle),
        ),
        clipBehavior: Clip.hardEdge,
        child: content,
      );
    } else {
      content = ColoredBox(color: surface.background, child: content);
    }

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }

  Widget _deltaChip(
    PlexColorTokens colors,
    ({Color background, Color foreground, Color muted}) surface,
  ) {
    final Color bg;
    final Color fg;
    final bool? good = _good;
    if (good == true) {
      bg = colors.statusSuccessSoft;
      fg = colors.statusSuccessInk;
    } else if (good == false) {
      bg = colors.statusDangerSoft;
      fg = colors.statusDangerInk;
    } else {
      bg = colors.surfaceSunken;
      fg = colors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlexDim.small,
        vertical: PlexDim.mini,
      ),
      decoration: BoxDecoration(
        color: tone == PlexStatSurface.standard ? bg : surface.foreground.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PlexRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (direction != PlexStatDirection.flat)
            Icon(
              direction == PlexStatDirection.up
                  ? Icons.north_east
                  : Icons.south_east,
              size: 12,
              color: tone == PlexStatSurface.standard ? fg : surface.foreground,
            ),
          if (direction != PlexStatDirection.flat)
            const SizedBox(width: PlexDim.mini),
          Text(
            delta!,
            style: TextStyle(
              color: tone == PlexStatSurface.standard ? fg : surface.foreground,
              fontSize: PlexFontSize.small,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconTile(
    PlexColorTokens colors,
    ({Color background, Color foreground, Color muted}) surface,
  ) {
    final Color bg;
    final Color fg;
    if (tone != PlexStatSurface.standard) {
      bg = surface.foreground.withValues(alpha: 0.16);
      fg = surface.foreground;
    } else {
      switch (iconTone) {
        case PlexStatIconTone.success:
          bg = colors.statusSuccessSoft;
          fg = colors.statusSuccessInk;
        case PlexStatIconTone.warning:
          bg = colors.statusWarningSoft;
          fg = colors.statusWarningInk;
        case PlexStatIconTone.danger:
          bg = colors.statusDangerSoft;
          fg = colors.statusDangerInk;
        case PlexStatIconTone.info:
          bg = colors.statusInfoSoft;
          fg = colors.statusInfoInk;
      }
    }
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(PlexRadius.md),
      ),
      child: Icon(icon, size: 20, color: fg),
    );
  }

  Widget _progressBar(PlexColorTokens colors) {
    final double pct = (progress ?? 0).clamp(0, 100) / 100;
    return ClipRRect(
      borderRadius: BorderRadius.circular(PlexRadius.xs),
      child: SizedBox(
        height: 5,
        child: Stack(
          children: [
            ColoredBox(
              color: tone == PlexStatSurface.standard
                  ? colors.surfaceSunken
                  : colors.textInverse.withValues(alpha: 0.2),
              child: const SizedBox.expand(),
            ),
            FractionallySizedBox(
              widthFactor: pct,
              child: ColoredBox(
                color: tone == PlexStatSurface.standard
                    ? colors.brandPrimary
                    : colors.textInverse,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _stripeColor(PlexColorTokens colors) {
    switch (stripe!) {
      case PlexStatStripe.brand:
        return colors.brandPrimary;
      case PlexStatStripe.success:
        return colors.statusSuccess;
      case PlexStatStripe.warning:
        return colors.statusWarning;
      case PlexStatStripe.danger:
        return colors.statusDanger;
    }
  }

  ({Color background, Color foreground, Color muted}) _surfaceColors(
    PlexColorTokens colors,
  ) {
    switch (tone) {
      case PlexStatSurface.brand:
        return (
          background: colors.surfaceInverse,
          foreground: colors.textInverse,
          muted: colors.textInverse.withValues(alpha: 0.64),
        );
      case PlexStatSurface.accent:
        return (
          background: colors.brandPrimary,
          foreground: colors.textInverse,
          muted: colors.textInverse.withValues(alpha: 0.78),
        );
      case PlexStatSurface.standard:
        return (
          background: colors.surfaceCard,
          foreground: colors.textPrimary,
          muted: colors.textMuted,
        );
    }
  }
}

class _PlexProgressRingPainter extends CustomPainter {
  _PlexProgressRingPainter({
    required this.progress,
    required this.track,
    required this.arc,
    required this.thickness,
  });

  final double progress;
  final Color track;
  final Color arc;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.shortestSide / 2) - (thickness / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);

    final Paint arcPaint = Paint()
      ..color = arc
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlexProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.track != track ||
        oldDelegate.arc != arc ||
        oldDelegate.thickness != thickness;
  }
}
