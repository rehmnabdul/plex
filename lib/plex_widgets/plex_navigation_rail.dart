import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_highlight_widget.dart';

enum PlexNavigationRailItemType { category, item }

class PlexNavigationRailItem {
  final PlexNavigationRailItemType type;
  final String category;
  final int? index;
  final PlexRoute? route;

  const PlexNavigationRailItem(this.type, this.category,
      {this.index, this.route});
}

class PlexNavigationRail extends StatelessWidget {
  /// Widget default — [PlexLayout.railCollapsed] (90). Not the 76 sidebar token.
  final double minWidth = PlexLayout.railCollapsed;

  /// Widget default — [PlexLayout.railExpanded] (260). Not the 264 sidebar token.
  final double maxWidth = PlexLayout.railExpanded;
  final bool extended;
  final Color backgroundColor;
  final List<Widget>? topWidgets;
  final List<Widget>? bottomWidgets;
  final List<PlexRoute> destinations;
  final int selectedDestination;
  final Function(int index) onSelectDestination;

  static const Key logoKey = Key('plex-nav-rail-logo');
  static const Key versionKey = Key('plex-nav-rail-version');

  const PlexNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedDestination,
    required this.onSelectDestination,
    this.extended = true,
    this.backgroundColor = Colors.transparent,
    this.topWidgets,
    this.bottomWidgets,
  });

  List<PlexNavigationRailItem> _getDestinationsList() {
    var menus = List<PlexNavigationRailItem>.empty(growable: true);
    String? prevCategory;
    for (var element in destinations.indexed) {
      var index = element.$1;
      var e = element.$2;
      if (extended) {
        if (prevCategory != e.category) {
          prevCategory = e.category;
          menus.add(PlexNavigationRailItem(
              PlexNavigationRailItemType.category, e.category));
        }
      }
      menus.add(PlexNavigationRailItem(
          PlexNavigationRailItemType.item, e.category,
          index: index, route: e));
    }
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final BorderRadius itemRadius = BorderRadius.circular(PlexRadius.md);

    return Container(
      color: backgroundColor,
      width: extended ? maxWidth : minWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: PlexDim.small, vertical: PlexDim.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!PlexApp.app.dashboardConfig!.hideNavigationRailLogo) ...{
              SizedBox(
                key: PlexNavigationRail.logoKey,
                height:
                    PlexApp.app.dashboardConfig!.hideNavigationRailLogoHeight,
                width: PlexApp.app.dashboardConfig!.hideNavigationRailLogoWidth,
                child: PlexApp.app.getLogo(context),
              ),
              spaceSmall(),
            },
            if (!PlexApp.app.dashboardConfig!.hideNavigationRailVersionInfo &&
                PlexApp.app.appInfo.versionName != null) ...[
              Text(
                "${PlexApp.app.appInfo.versionName}",
                key: PlexNavigationRail.versionKey,
                textAlign: TextAlign.center,
              ),
              spaceSmall(),
            ],
            ...?topWidgets,
            spaceSmall(),
            ..._getDestinationsList().map(
              (route) {
                if (route.type == PlexNavigationRailItemType.category) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(PlexDim.small,
                        PlexDim.medium, PlexDim.small, PlexDim.smallest),
                    child: Text(
                      route.category,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: PlexFontSize.smallest,
                        letterSpacing: 0.8,
                        color: colors.textMuted,
                      ),
                    ),
                  );
                }
                var isSelected = route.index == selectedDestination;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: PlexDim.mini, horizontal: PlexDim.smallest),
                  child: Material(
                    color:
                        isSelected ? colors.brandPrimary : Colors.transparent,
                    borderRadius: itemRadius,
                    child: InkWell(
                      canRequestFocus: true,
                      hoverColor: isSelected
                          ? colors.brandPrimaryHover.withValues(alpha: 0.24)
                          : colors.surfaceHover,
                      splashFactory: InkRipple.splashFactory,
                      highlightColor: isSelected
                          ? colors.brandPrimaryActive.withValues(alpha: 0.32)
                          : colors.brandPrimary.withValues(alpha: 0.12),
                      hoverDuration: Durations.short1,
                      enableFeedback: true,
                      borderRadius: itemRadius,
                      onTap: () {
                        if (route.route?.external == true) {
                          Plex.toNamed(route.route!.route);
                          return;
                        }
                        onSelectDestination.call(route.index!);
                      },
                      onHover: (value) {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: PlexDim.small,
                            horizontal: PlexDim.smallMedium),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                PlexHighlightWidget(
                                  enabled: route.route!.tag != null,
                                  tagBgColor: route.route!.tagBgColor,
                                  child: IconTheme(
                                    data: IconThemeData(
                                      size: 20,
                                      color: isSelected
                                          ? colors.textInverse
                                          : colors.textSecondary,
                                    ),
                                    child: createWidget(() {
                                      if (isSelected) {
                                        return route.route!.selectedLogo ??
                                            route.route!.logo ??
                                            const Icon(Icons.circle);
                                      }
                                      return route.route!.logo ??
                                          const Icon(Icons.circle_outlined);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            if (extended) ...{
                              spaceMedium(),
                              Expanded(
                                child: Text(
                                  route.route!.title,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    fontSize: PlexFontSize.small,
                                    overflow: TextOverflow.clip,
                                    color: isSelected
                                        ? colors.textInverse
                                        : colors.textSecondary,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              if (route.route!.tag != null) ...{
                                Tooltip(
                                  message: route.route!.tagDescription ?? "",
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: route.route!.tagBgColor ??
                                          (isSelected
                                              ? colors.textInverse
                                                  .withValues(alpha: 0.25)
                                              : PlexTheme.navigationTagColor),
                                      borderRadius: BorderRadius.circular(
                                          PlexRadius.pill),
                                    ),
                                    child: Text(
                                      route.route!.tag!,
                                      style: TextStyle(
                                        fontSize: PlexFontSize.smallest,
                                        color: route.route!.tagTextColor ??
                                            (isSelected
                                                ? colors.textInverse
                                                : PlexTheme
                                                    .navigationTagTextColor),
                                      ),
                                    ),
                                  ),
                                ),
                              },
                              Icon(
                                route.route?.external == true
                                    ? Icons.launch
                                    : Icons.arrow_right_outlined,
                                color: isSelected
                                    ? colors.textInverse.withValues(alpha: 0.7)
                                    : colors.textMuted,
                                size: 16,
                              ),
                            },
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            spaceMedium(),
            ...?bottomWidgets
          ],
        ),
      ),
    );
  }
}
