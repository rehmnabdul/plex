import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_shimmer.dart';

/// Node tint for an activity rail icon.
enum PlexActivityTone {
  neutral,
  info,
  success,
  warning,
  danger,
  brand,
}

/// One timeline entry for [PlexActivityFeed].
class PlexActivityItem {
  const PlexActivityItem({
    required this.id,
    required this.title,
    required this.time,
    this.body,
    this.icon,
    this.tone = PlexActivityTone.neutral,
  });

  final String id;
  final String title;
  final DateTime time;
  final String? body;
  final IconData? icon;
  final PlexActivityTone tone;
}

/// Timeline / feed of activity items (icon, title, time, body).
class PlexActivityFeed extends StatelessWidget {
  const PlexActivityFeed({
    super.key,
    required this.items,
    this.loading = false,
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage,
    this.groupByDay = true,
    this.now,
  });

  final List<PlexActivityItem> items;
  final bool loading;
  final String emptyTitle;
  final String? emptyMessage;
  final bool groupByDay;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final DateTime reference = now ?? DateTime.now();

    if (loading && items.isEmpty) {
      return Column(
        children: const [
          _SkeletonRow(),
          _SkeletonRow(),
          _SkeletonRow(),
        ],
      );
    }

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: PlexDim.extraLargeMinus),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, color: colors.textDisabled),
            const SizedBox(height: PlexDim.small),
            Text(
              emptyTitle,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: PlexFontSize.body,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (emptyMessage != null) ...[
              const SizedBox(height: PlexDim.smallest),
              Text(
                emptyMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: PlexFontSize.caption,
                ),
              ),
            ],
          ],
        ),
      );
    }

    final List<PlexActivityItem> sorted = List<PlexActivityItem>.of(items)
      ..sort((a, b) => b.time.compareTo(a.time));

    final List<Widget> children = <Widget>[];
    if (!groupByDay) {
      for (int i = 0; i < sorted.length; i++) {
        children.add(
          _ActivityRow(
            item: sorted[i],
            colors: colors,
            now: reference,
            last: i == sorted.length - 1,
          ),
        );
      }
      return Column(children: children);
    }

    final Map<String, List<PlexActivityItem>> groups =
        <String, List<PlexActivityItem>>{};
    for (final PlexActivityItem item in sorted) {
      final String key = DateTime(item.time.year, item.time.month, item.time.day)
          .toIso8601String();
      groups.putIfAbsent(key, () => <PlexActivityItem>[]).add(item);
    }

    final List<String> keys = groups.keys.toList();
    for (final String key in keys) {
      final List<PlexActivityItem> group = groups[key]!;
      children.add(_DayHeader(label: _dayLabel(group.first.time, reference), colors: colors));
      for (int i = 0; i < group.length; i++) {
        children.add(
          _ActivityRow(
            item: group[i],
            colors: colors,
            now: reference,
            last: i == group.length - 1,
          ),
        );
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }

  static String _dayLabel(DateTime time, DateTime now) {
    final DateTime day = DateTime(time.year, time.month, time.day);
    final DateTime today = DateTime(now.year, now.month, now.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat.yMMMd().format(time);
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label, required this.colors});

  final String label;
  final PlexColorTokens colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PlexDim.smallMedium),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: label == 'Today' ? colors.brandPrimary : colors.textMuted,
              fontSize: PlexFontSize.small,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: PlexDim.small),
          Expanded(child: Divider(color: colors.borderSubtle, height: 1)),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.item,
    required this.colors,
    required this.now,
    required this.last,
  });

  final PlexActivityItem item;
  final PlexColorTokens colors;
  final DateTime now;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ({Color background, Color foreground, Color border}) node =
        _nodeColors(colors, item.tone);

    return Padding(
      padding: const EdgeInsets.only(bottom: PlexDim.medium),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 34,
              child: Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: node.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: node.border),
                    ),
                    child: Icon(
                      item.icon ?? Icons.circle_outlined,
                      size: 15,
                      color: node.foreground,
                    ),
                  ),
                  if (!last)
                    Expanded(
                      child: Container(width: 2, color: colors.borderSubtle),
                    ),
                ],
              ),
            ),
            const SizedBox(width: PlexDim.medium),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: PlexDim.smallest),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: PlexFontSize.caption,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: PlexDim.small),
                        Text(
                          _relativeTime(item.time, now),
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: PlexFontSize.small,
                          ),
                        ),
                      ],
                    ),
                    if (item.body != null) ...[
                      const SizedBox(height: PlexDim.small),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(PlexDim.smallMedium),
                        decoration: BoxDecoration(
                          color: colors.surfaceSunken,
                          borderRadius: BorderRadius.circular(PlexRadius.md),
                          border: Border.all(color: colors.borderSubtle),
                        ),
                        child: Text(
                          item.body!,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: PlexFontSize.caption,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _relativeTime(DateTime time, DateTime now) {
    final int mins = now.difference(time).inMinutes;
    if (mins.abs() < 1) return 'just now';
    if (mins < 60) return '${mins}m ago';
    if (DateTime(time.year, time.month, time.day) ==
        DateTime(now.year, now.month, now.day)) {
      return '${now.difference(time).inHours}h ago';
    }
    return DateFormat.jm().format(time);
  }

  static ({Color background, Color foreground, Color border}) _nodeColors(
    PlexColorTokens colors,
    PlexActivityTone tone,
  ) {
    switch (tone) {
      case PlexActivityTone.info:
        return (
          background: colors.statusInfoSoft,
          foreground: colors.statusInfoInk,
          border: colors.statusInfo,
        );
      case PlexActivityTone.success:
        return (
          background: colors.statusSuccessSoft,
          foreground: colors.statusSuccessInk,
          border: colors.statusSuccess,
        );
      case PlexActivityTone.warning:
        return (
          background: colors.statusWarningSoft,
          foreground: colors.statusWarningInk,
          border: colors.statusWarning,
        );
      case PlexActivityTone.danger:
        return (
          background: colors.statusDangerSoft,
          foreground: colors.statusDangerInk,
          border: colors.statusDanger,
        );
      case PlexActivityTone.brand:
        return (
          background: colors.brand.shade100,
          foreground: colors.brandInk,
          border: colors.brandPrimary,
        );
      case PlexActivityTone.neutral:
        return (
          background: colors.surfaceCard,
          foreground: colors.textSecondary,
          border: colors.borderDefault,
        );
    }
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: PlexDim.medium),
      child: Row(
        children: [
          PlexSkeleton.circle(size: 34),
          SizedBox(width: PlexDim.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlexSkeleton.line(width: 180, height: 10),
                SizedBox(height: PlexDim.small),
                PlexSkeleton.line(width: 120, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
