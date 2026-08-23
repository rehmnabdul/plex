import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// One SKU / line for [PlexMobileList].
///
/// [qty] is display-only. The parent owns increments and decrements.
class PlexMobileTallyItem {
  const PlexMobileTallyItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.qty = 0,
    this.unit,
  });

  final String id;
  final String title;
  final String? subtitle;
  final int qty;
  final String? unit;
}

/// Dense shop-floor tally list (title, qty, +/−).
///
/// Does not replace [PlexDataList]. Qty is not edited in place; [onIncrement]
/// and [onDecrement] receive the tapped [PlexMobileTallyItem].
class PlexMobileList extends StatelessWidget {
  const PlexMobileList({
    super.key,
    required this.items,
    this.onIncrement,
    this.onDecrement,
    this.onTap,
  });

  final List<PlexMobileTallyItem> items;
  final ValueChanged<PlexMobileTallyItem>? onIncrement;
  final ValueChanged<PlexMobileTallyItem>? onDecrement;
  final ValueChanged<PlexMobileTallyItem>? onTap;

  static const double _kTapMin = 40;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: PlexDim.large),
        child: Center(
          child: Text(
            'No items',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: PlexFontSize.body,
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: PlexDim.small),
          _TallyTile(
            item: items[i],
            colors: colors,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onTap: onTap,
          ),
        ],
      ],
    );
  }
}

class _TallyTile extends StatelessWidget {
  const _TallyTile({
    required this.item,
    required this.colors,
    this.onIncrement,
    this.onDecrement,
    this.onTap,
  });

  final PlexMobileTallyItem item;
  final PlexColorTokens colors;
  final ValueChanged<PlexMobileTallyItem>? onIncrement;
  final ValueChanged<PlexMobileTallyItem>? onDecrement;
  final ValueChanged<PlexMobileTallyItem>? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key('plex-mobile-item-${item.id}'),
      color: colors.surfaceCard,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlexRadius.md),
        side: BorderSide(color: colors.borderSubtle),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap == null ? null : () => onTap!(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PlexDim.smallMedium,
            vertical: PlexDim.small,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: PlexFontSize.body,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: PlexDim.mini),
                      Text(
                        item.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: PlexFontSize.caption,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: PlexDim.small),
              Text(
                '${item.qty}',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: PlexFontSize.large,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures()
                  ],
                ),
              ),
              if (item.unit != null && item.unit!.isNotEmpty) ...[
                const SizedBox(width: PlexDim.smallest),
                Text(
                  item.unit!,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: PlexFontSize.caption,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(width: PlexDim.smallest),
              _QtyButton(
                key: Key('plex-mobile-dec-${item.id}'),
                icon: Icons.remove,
                colors: colors,
                onPressed:
                    onDecrement == null ? null : () => onDecrement!(item),
              ),
              _QtyButton(
                key: Key('plex-mobile-inc-${item.id}'),
                icon: Icons.add,
                colors: colors,
                onPressed:
                    onIncrement == null ? null : () => onIncrement!(item),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    super.key,
    required this.icon,
    required this.colors,
    this.onPressed,
  });

  final IconData icon;
  final PlexColorTokens colors;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: PlexFontSize.large,
      tooltip: icon == Icons.add ? 'Increment' : 'Decrement',
      style: IconButton.styleFrom(
        foregroundColor: colors.brandPrimary,
        disabledForegroundColor: colors.textMuted,
        minimumSize: const Size.square(PlexMobileList._kTapMin),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
