import 'package:flutter/material.dart';
import 'package:plex/plex_widgets/plex_dashboard_card.dart';

/// A responsive grid of [PlexDashboardCard] widgets.
class PlexDashboardGrid extends StatelessWidget {
  const PlexDashboardGrid({
    super.key,
    required this.cards,
    this.crossAxisCount,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
  });

  final List<PlexDashboardCard> cards;
  final int? crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  int _getCrossAxisCount(double width) {
    if (crossAxisCount != null) return crossAxisCount!;
    if (width >= 1200) return 4;
    if (width >= 768) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = _getCrossAxisCount(constraints.maxWidth);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: 1.5,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) => cards[index],
        );
      },
    );
  }
}
