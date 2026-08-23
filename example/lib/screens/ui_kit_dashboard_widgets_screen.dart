import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_activity_feed.dart';
import 'package:plex/plex_widgets/plex_data_list.dart';
import 'package:plex/plex_widgets/plex_mini_table.dart';
import 'package:plex/plex_widgets/plex_stat_card.dart';
import 'package:plex/plex_widgets/plex_widget_card.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitDashboardWidgetsScreen extends StatelessWidget {
  const UiKitDashboardWidgetsScreen({super.key});

  static final DateTime _now = DateTime(2026, 8, 23, 15, 30);

  @override
  Widget build(BuildContext context) {
    return ExampleScrollPage(
      children: [
        const ExampleSectionTitle(
          "PlexStatGrid",
          detail: "KPI tiles. PlexStatCard is the bordered standalone variant.",
        ),
        const PlexStatGrid(
          columns: 4,
          minWidth: 180,
          children: [
            PlexStatTile(
              label: "Open orders",
              value: "128",
              delta: "+6.1%",
              direction: PlexStatDirection.up,
              icon: Icons.shopping_bag_outlined,
            ),
            PlexStatTile(
              label: "On time",
              value: "94",
              unit: "%",
              hint: "this week",
              progress: 94,
              icon: Icons.schedule_outlined,
              iconTone: PlexStatIconTone.success,
            ),
            PlexStatTile(
              label: "Defects",
              value: "3",
              delta: "-1",
              direction: PlexStatDirection.down,
              invert: true,
              icon: Icons.report_outlined,
              iconTone: PlexStatIconTone.danger,
              stripe: PlexStatStripe.danger,
            ),
            PlexStatTile(
              label: "Capacity",
              value: "72",
              unit: "%",
              icon: Icons.factory_outlined,
            ),
          ],
        ),
        const SizedBox(height: PlexDim.medium),
        const PlexStatCard(
          label: "Revenue",
          value: "84.2k",
          unit: "USD",
          delta: "+4.2%",
          direction: PlexStatDirection.up,
          hint: "vs last week",
          icon: Icons.payments_outlined,
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle(
          "PlexProgressRing",
          detail: "Circular completion. Distinct from PlexProgressBar.",
        ),
        const Center(
          child: PlexProgressRing(
            value: 72,
            label: "Capacity",
            caption: "Line 3 vs weekly target",
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle(
          "PlexWidgetCard + PlexMiniTable",
          detail: "Dashboard shell. MiniTable is not a DataGrid replacement.",
        ),
        const PlexWidgetCard(
          eyebrow: "Operations",
          title: "Late SKUs",
          subtitle: "Compact read-only lines",
          flush: true,
          rule: true,
          child: PlexMiniTable(
            zebra: true,
            columns: [
              PlexMiniTableColumn(id: "sku", header: "Sku"),
              PlexMiniTableColumn(id: "line", header: "Line"),
              PlexMiniTableColumn(
                id: "qty",
                header: "Qty",
                numeric: true,
                align: PlexMiniTableAlign.right,
              ),
            ],
            rows: [
              ["A-1042", "Cut", "240"],
              ["B-881", "Sew", "96"],
              ["C-12", "Pack", "18"],
            ],
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("PlexDataList"),
        const PlexWidgetCard(
          title: "Work orders",
          child: PlexDataList(
            items: [
              PlexDataListItem(
                title: "WO-1042",
                subtitle: "Cutting",
                value: "240 pcs",
                tag: "Hot",
                tone: PlexDataListTone.warning,
              ),
              PlexDataListItem(
                title: "WO-1043",
                subtitle: "Sewing",
                value: "96 pcs",
                delta: "+12%",
                direction: PlexDataListDirection.up,
              ),
              PlexDataListItem(
                title: "WO-1044",
                subtitle: "Packing",
                value: "18 pcs",
                meta: "due today",
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle("PlexActivityFeed"),
        PlexWidgetCard(
          title: "Floor activity",
          child: PlexActivityFeed(
            now: _now,
            items: [
              PlexActivityItem(
                id: "1",
                title: "QA approved lot A-1042",
                time: _now.subtract(const Duration(minutes: 12)),
                body: "All measurements within tolerance.",
                icon: Icons.verified_outlined,
                tone: PlexActivityTone.success,
              ),
              PlexActivityItem(
                id: "2",
                title: "Comment on WO-1043",
                time: _now.subtract(const Duration(hours: 2)),
                body: "Needle change scheduled at 16:00.",
                icon: Icons.chat_bubble_outline,
                tone: PlexActivityTone.info,
              ),
              PlexActivityItem(
                id: "3",
                title: "Shipment delayed",
                time: _now.subtract(const Duration(days: 1, hours: 3)),
                icon: Icons.warning_amber_outlined,
                tone: PlexActivityTone.warning,
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.large),
        const ExampleSectionTitle(
          "Loading and empty",
          detail: "PlexWidgetCard body slots. Not the reactive PlexWidget.",
        ),
        const PlexWidgetCard(
          title: "Syncing",
          loading: true,
          child: Text("Hidden"),
        ),
        const SizedBox(height: PlexDim.medium),
        PlexWidgetCard(
          title: "Exceptions",
          empty: true,
          emptyTitle: "No exceptions",
          emptyMessage: "Floor exceptions will appear here.",
          footer: Text(
            "Updated just now",
            style: TextStyle(color: PlexThemeData.of(context).colors.textMuted),
          ),
          child: const Text("Hidden"),
        ),
      ],
    );
  }
}
