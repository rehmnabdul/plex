import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_avatar.dart';
import 'package:plex/plex_widgets/plex_badge.dart';

/// Leading treatment for [PlexDataList] rows.
enum PlexDataListVariant {
  plain,
  ranked,
  people,
  icon,
  swatch,
  check,
}

/// Row density for [PlexDataList].
enum PlexDataListDensity {
  comfortable,
  compact,
}

/// Icon / tag tone.
enum PlexDataListTone {
  neutral,
  info,
  success,
  warning,
  danger,
}

/// Signed change direction for a list delta.
enum PlexDataListDirection {
  up,
  down,
  flat,
}

/// One row in [PlexDataList].
class PlexDataListItem {
  const PlexDataListItem({
    this.id,
    required this.title,
    this.subtitle,
    this.trailing,
    this.value,
    this.meta,
    this.delta,
    this.direction = PlexDataListDirection.flat,
    this.progress,
    this.icon,
    this.tone = PlexDataListTone.neutral,
    this.avatarName,
    this.tag,
    this.done = false,
    this.color,
  });

  final String? id;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? value;
  final String? meta;
  final String? delta;
  final PlexDataListDirection direction;
  final double? progress;
  final IconData? icon;
  final PlexDataListTone tone;
  final String? avatarName;
  final String? tag;
  final bool done;
  final Color? color;
}

/// Title / subtitle / trailing list for dashboard tiles.
class PlexDataList extends StatelessWidget {
  const PlexDataList({
    super.key,
    required this.items,
    this.variant = PlexDataListVariant.plain,
    this.divided = true,
    this.density = PlexDataListDensity.comfortable,
    this.onItemTap,
    this.onToggle,
  });

  final List<PlexDataListItem> items;
  final PlexDataListVariant variant;
  final bool divided;
  final PlexDataListDensity density;
  final void Function(PlexDataListItem item, int index)? onItemTap;
  final void Function(PlexDataListItem item, int index)? onToggle;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final bool compact = density == PlexDataListDensity.compact;

    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          DecoratedBox(
            decoration: BoxDecoration(
              border: divided && i > 0
                  ? Border(top: BorderSide(color: colors.borderSubtle))
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onItemTap == null ? null : () => onItemTap!(items[i], i),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: compact ? PlexDim.small : PlexDim.smallMedium,
                  ),
                  child: _row(context, colors, items[i], i),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    PlexColorTokens colors,
    PlexDataListItem item,
    int index,
  ) {
    final TextStyle titleStyle = TextStyle(
      color: item.done ? colors.textMuted : colors.textPrimary,
      fontSize: PlexFontSize.caption,
      fontWeight: FontWeight.w700,
      decoration: item.done ? TextDecoration.lineThrough : null,
    );

    return Row(
      children: [
        if (variant == PlexDataListVariant.check) ...[
          Checkbox(
            value: item.done,
            visualDensity: VisualDensity.compact,
            onChanged: onToggle == null ? null : (_) => onToggle!(item, index),
          ),
          const SizedBox(width: PlexDim.smallest),
        ],
        if (variant == PlexDataListVariant.ranked) ...[
          _rankChip(colors, index),
          const SizedBox(width: PlexDim.smallMedium),
        ],
        if (variant == PlexDataListVariant.people) ...[
          PlexAvatar(name: item.avatarName ?? item.title, size: 36),
          const SizedBox(width: PlexDim.smallMedium),
        ],
        if (variant == PlexDataListVariant.icon && item.icon != null) ...[
          _iconTile(colors, item),
          const SizedBox(width: PlexDim.smallMedium),
        ],
        if (variant == PlexDataListVariant.swatch) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: item.color ?? colors.brandPrimary,
              borderRadius: BorderRadius.circular(PlexRadius.xs),
            ),
          ),
          const SizedBox(width: PlexDim.smallMedium),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(child: Text(item.title, style: titleStyle)),
                  if (item.tag != null) ...[
                    const SizedBox(width: PlexDim.small),
                    PlexBadge(
                      label: item.tag!,
                      tone: _badgeTone(item.tone),
                    ),
                  ],
                ],
              ),
              if (item.subtitle != null) ...[
                const SizedBox(height: PlexDim.mini),
                Text(
                  item.subtitle!,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: PlexFontSize.small,
                  ),
                ),
              ],
              if (item.progress != null) ...[
                const SizedBox(height: PlexDim.small),
                ClipRRect(
                  borderRadius: BorderRadius.circular(PlexRadius.xs),
                  child: LinearProgressIndicator(
                    value: (item.progress! / 100).clamp(0.0, 1.0),
                    minHeight: 5,
                    backgroundColor: colors.surfaceSunken,
                    color: item.color ?? colors.brandPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (item.trailing != null) ...[
          const SizedBox(width: PlexDim.small),
          item.trailing!,
        ] else if (item.value != null || item.meta != null || item.delta != null) ...[
          const SizedBox(width: PlexDim.small),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.value != null)
                Text(
                  item.value!,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: PlexFontSize.caption,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (item.delta != null)
                Text(
                  item.delta!,
                  style: TextStyle(
                    color: _deltaColor(colors, item.direction),
                    fontSize: PlexFontSize.small,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (item.meta != null)
                Text(
                  item.meta!,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: PlexFontSize.small,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _rankChip(PlexColorTokens colors, int index) {
    final Color bg;
    final Color fg;
    if (index == 0) {
      bg = colors.brandPrimary;
      fg = colors.textInverse;
    } else if (index == 1) {
      bg = colors.statusInfoSoft;
      fg = colors.statusInfoInk;
    } else if (index == 2) {
      bg = colors.surfaceSunken;
      fg = colors.textSecondary;
    } else {
      bg = colors.surfaceSunken;
      fg = colors.textSecondary;
    }
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(PlexRadius.sm),
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(
          color: fg,
          fontSize: PlexFontSize.small,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _iconTile(PlexColorTokens colors, PlexDataListItem item) {
    final Color bg;
    final Color fg;
    switch (item.tone) {
      case PlexDataListTone.success:
        bg = colors.statusSuccessSoft;
        fg = colors.statusSuccessInk;
      case PlexDataListTone.warning:
        bg = colors.statusWarningSoft;
        fg = colors.statusWarningInk;
      case PlexDataListTone.danger:
        bg = colors.statusDangerSoft;
        fg = colors.statusDangerInk;
      case PlexDataListTone.info:
        bg = colors.statusInfoSoft;
        fg = colors.statusInfoInk;
      case PlexDataListTone.neutral:
        bg = colors.surfaceSunken;
        fg = colors.textSecondary;
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(PlexRadius.md),
      ),
      child: Icon(item.icon, size: 17, color: fg),
    );
  }

  Color _deltaColor(PlexColorTokens colors, PlexDataListDirection direction) {
    switch (direction) {
      case PlexDataListDirection.up:
        return colors.statusSuccessInk;
      case PlexDataListDirection.down:
        return colors.statusDangerInk;
      case PlexDataListDirection.flat:
        return colors.textMuted;
    }
  }

  PlexBadgeTone _badgeTone(PlexDataListTone tone) {
    switch (tone) {
      case PlexDataListTone.info:
        return PlexBadgeTone.info;
      case PlexDataListTone.success:
        return PlexBadgeTone.success;
      case PlexDataListTone.warning:
        return PlexBadgeTone.warning;
      case PlexDataListTone.danger:
        return PlexBadgeTone.danger;
      case PlexDataListTone.neutral:
        return PlexBadgeTone.neutral;
    }
  }
}
