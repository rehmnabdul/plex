import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_tabs.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitTabsScreen extends StatelessWidget {
  const UiKitTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlexTabs(
      tabs: const [
        Tab(text: "Overview"),
        Tab(text: "Activity"),
        Tab(text: "Settings"),
      ],
      children: [
        PlexTabPanel(
          child: ExampleCard(
            title: "Overview",
            subtitle: "PlexTabs + PlexTabPanel",
            actions: const PlexBadge(label: "Phase 4", tone: PlexBadgeTone.info),
            child: Text(
              "PlexTabs is a body-level tab strip. It does not replace "
              "PlexScreen.getTabBar() for screens that already host a Material TabBar.",
              style: TextStyle(color: PlexThemeData.of(context).colors.textSecondary),
            ),
          ),
        ),
        PlexTabPanel(
          child: ExampleCard(
            title: "Activity",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent events",
                  style: TextStyle(
                    color: PlexThemeData.of(context).colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: PlexDim.small),
                const Text("Shipment #1042 marked as shipped."),
                const Text("User Ada updated warehouse settings."),
              ],
            ),
          ),
        ),
        const PlexTabPanel(
          child: ExampleCard(
            title: "Settings",
            child: Text("Placeholder panel — wire real settings in your app."),
          ),
        ),
      ],
    );
  }
}
