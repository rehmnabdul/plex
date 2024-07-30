import 'package:flutter/material.dart';
import 'package:plex/plex_package.dart';
import 'package:plex/plex_route.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

enum PlexNavigationRailItemType { category, item }

class PlexNavigationRailItem {
  final PlexNavigationRailItemType type;
  final String category;
  final int? index;
  final PlexRoute? route;

  const PlexNavigationRailItem(this.type, this.category, {this.index, this.route});
}

class PlexNavigationRail extends StatelessWidget {
  final minWidth = 90.0;
  final maxWidth = 260.0;
  final bool extended;
  final Color backgroundColor;
  final List<Widget>? topWidgets;
  final List<Widget>? bottomWidgets;
  final List<PlexRoute> destinations;
  final int selectedDestination;
  final Function(int index) onSelectDestination;

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
      if(extended) {
        if (prevCategory != e.category) {
          prevCategory = e.category;
          menus.add(PlexNavigationRailItem(PlexNavigationRailItemType.category, e.category));
        }
      }
      menus.add(PlexNavigationRailItem(PlexNavigationRailItemType.item, e.category, index: index, route: e));
    }
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: extended ? maxWidth : minWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dim.medium, vertical: Dim.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!PlexApp.app.dashboardConfig!.hideNavigationRailLogo) ...{
              SizedBox(
                height: PlexApp.app.dashboardConfig!.hideNavigationRailLogoHeight,
                width: PlexApp.app.dashboardConfig!.hideNavigationRailLogoWidth,
                child: PlexApp.app.getLogo(context),
              ),
              spaceSmall(),
            },
            if (!PlexApp.app.dashboardConfig!.hideNavigationRailVersionInfo && PlexApp.app.appInfo.versionName != null) ...[
              Text("${PlexApp.app.appInfo.versionName}", textAlign: TextAlign.center),
              spaceSmall(),
            ],
            ...?topWidgets,
            spaceSmall(),
            ..._getDestinationsList().map(
                  (route) {
                if (route.type == PlexNavigationRailItemType.category) {
                  return Text(
                    route.category,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }
                var isSelected = route.index == selectedDestination;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dim.zero, horizontal: Dim.zero),
                  child: InkWell(
                    canRequestFocus: true,
                    hoverColor: PlexTheme
                        .getActiveTheme(context)
                        .primaryColor
                        .withOpacity(0.1),
                    splashFactory: InkRipple.splashFactory,
                    highlightColor: PlexTheme
                        .getActiveTheme(context)
                        .primaryColor
                        .withOpacity(0.5),
                    hoverDuration: Durations.short1,
                    enableFeedback: true,
                    borderRadius: BorderRadius.circular(Dim.large),
                    onTap: () {
                      onSelectDestination.call(route.index!);
                    },
                    onHover: (value) {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dim.small, horizontal: Dim.medium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: isSelected ? 1.2 : 0.7,
                            child: createWidget(
                                  () {
                                if (isSelected) {
                                  return route.route!.selectedLogo ?? route.route!.logo ?? const Icon(Icons.circle);
                                }
                                return route.route!.logo ?? const Icon(Icons.circle_outlined);
                              },
                            ),
                          ),
                          if (extended) ...{
                            spaceMedium(),
                            Expanded(
                              child: Text(
                                route.route!.title,
                                style: TextStyle(fontWeight: isSelected ? FontWeight.bold : null, fontSize: 12, overflow: TextOverflow.clip),
                                maxLines: 1,
                              ),
                            ),
                            Icon(Icons.arrow_right_outlined, color: Colors.grey.shade500)
                          },
                        ],
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
