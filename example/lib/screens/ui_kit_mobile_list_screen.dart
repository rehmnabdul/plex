import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_mobile_list.dart';
import 'package:plex/plex_widgets/plex_mobile_tally.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitMobileListScreen extends StatefulWidget {
  const UiKitMobileListScreen({super.key});

  @override
  State<UiKitMobileListScreen> createState() => _UiKitMobileListScreenState();
}

class _UiKitMobileListScreenState extends State<UiKitMobileListScreen> {
  final Map<String, int> _qty = <String, int>{
    "A-1042": 12,
    "B-881": 4,
    "C-220": 0,
    "D-019": 36,
  };

  List<PlexMobileTallyItem> _items() {
    return [
      PlexMobileTallyItem(
        id: "A-1042",
        title: "A-1042",
        subtitle: "Cotton rib knit · Line 2",
        qty: _qty["A-1042"] ?? 0,
        unit: "pcs",
      ),
      PlexMobileTallyItem(
        id: "B-881",
        title: "B-881",
        subtitle: "Twill tape · Pack",
        qty: _qty["B-881"] ?? 0,
        unit: "pcs",
      ),
      PlexMobileTallyItem(
        id: "C-220",
        title: "C-220",
        subtitle: "Zipper #5 · Cut",
        qty: _qty["C-220"] ?? 0,
        unit: "ea",
      ),
      PlexMobileTallyItem(
        id: "D-019",
        title: "D-019",
        subtitle: "Carton blank · Ship",
        qty: _qty["D-019"] ?? 0,
        unit: "ctn",
      ),
    ];
  }

  void _bump(PlexMobileTallyItem item, int delta) {
    setState(() {
      final int next = (_qty[item.id] ?? item.qty) + delta;
      _qty[item.id] = next < 0 ? 0 : next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;

    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "PlexMobileList",
          subtitle:
              "Shop-floor tally. Qty is display-only; parent owns the map.",
          actions: const PlexBadge(label: "Lite", tone: PlexBadgeTone.info),
          child: Text(
            "Does not replace PlexDataList. Tap a row, or use + / −.",
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Floor tally",
          subtitle: "Four SKUs",
          child: PlexMobileList(
            items: _items(),
            onIncrement: (item) => _bump(item, 1),
            onDecrement: (item) => _bump(item, -1),
            onTap: (item) => context.showMessage(item.title, title: "SKU"),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexMobileTally",
          subtitle: "Same lines plus scan / typed code",
          child: PlexMobileTally(
            enableScanner: false,
            items: _items(),
            onIncrement: (item) => _bump(item, 1),
            onDecrement: (item) => _bump(item, -1),
          ),
        ),
      ],
    );
  }
}
