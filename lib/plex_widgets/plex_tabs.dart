import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Token-styled tab strip plus view. Does not replace [PlexScreen.getTabBar].
///
/// Screens that already return a Material [TabBar] from [PlexScreen.getTabBar]
/// can keep that path. New screens can embed [PlexTabs] in the body instead.
class PlexTabs extends StatelessWidget {
  const PlexTabs({
    super.key,
    required this.tabs,
    required this.children,
    this.controller,
    this.initialIndex = 0,
  });

  final List<Tab> tabs;
  final List<Widget> children;
  final TabController? controller;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    assert(tabs.length == children.length);

    final Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PlexTabBar(tabs: tabs, controller: controller),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: children,
          ),
        ),
      ],
    );

    if (controller != null) return column;
    return DefaultTabController(
      length: tabs.length,
      initialIndex: initialIndex,
      child: column,
    );
  }
}

class _PlexTabBar extends StatelessWidget {
  const _PlexTabBar({required this.tabs, this.controller});

  final List<Tab> tabs;
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    return Material(
      color: colors.surfaceCard,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        isScrollable: tabs.length > 4,
        labelColor: colors.textBrand,
        unselectedLabelColor: colors.textMuted,
        indicatorColor: colors.brandPrimary,
        indicatorWeight: 2.5,
        dividerColor: colors.borderSubtle,
        overlayColor: WidgetStatePropertyAll<Color>(
          colors.brandPrimary.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

/// Surface-padded panel for a single tab's body. Use as a [PlexTabs] child.
class PlexTabPanel extends StatelessWidget {
  const PlexTabPanel({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    return ColoredBox(
      color: colors.surfacePage,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(PlexDim.medium),
        child: child,
      ),
    );
  }
}
