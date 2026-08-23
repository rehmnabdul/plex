import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_lookup.dart';
import 'package:plex/plex_widgets/plex_tag.dart';
import 'package:plex_app/screens/example_chrome.dart';

class _WarehouseSku {
  const _WarehouseSku(this.sku, this.warehouse);

  final String sku;
  final String warehouse;
}

class UiKitLookupTagsScreen extends StatefulWidget {
  const UiKitLookupTagsScreen({super.key});

  @override
  State<UiKitLookupTagsScreen> createState() => _UiKitLookupTagsScreenState();
}

class _UiKitLookupTagsScreenState extends State<UiKitLookupTagsScreen> {
  static const List<_WarehouseSku> _skus = [
    _WarehouseSku("A-1042", "Warehouse North"),
    _WarehouseSku("B-881", "Warehouse South"),
    _WarehouseSku("C-220", "Warehouse East"),
    _WarehouseSku("D-019", "Warehouse West"),
  ];

  _WarehouseSku? _selected;
  String? _tappedTag;
  List<String> _tags = ["Priority", "Fragile"];

  @override
  Widget build(BuildContext context) {
    final colors = PlexThemeData.of(context).colors;

    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "Lookup & tags",
          subtitle:
              "PlexLookup is a searchable picker. PlexTag is a chip, not a badge.",
          child: Text(
            "Tokens come from PlexThemeData. Filter matches SKU or warehouse.",
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexLookup",
          subtitle: "Warehouse / SKU strings",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlexLookup<_WarehouseSku>(
                items: _skus,
                labelOf: (item) => item.sku,
                subtitleOf: (item) => item.warehouse,
                value: _selected,
                hint: "Search",
                label: "SKU",
                onChanged: (value) => setState(() => _selected = value),
              ),
              const SizedBox(height: PlexDim.small),
              Text(
                _selected == null
                    ? "No SKU selected."
                    : "Selected ${_selected!.sku} at ${_selected!.warehouse}.",
                style: TextStyle(color: colors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexTag",
          subtitle: "Compact chips. Selected uses brandPrimary tint.",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: PlexDim.small,
                runSpacing: PlexDim.small,
                children: [
                  const PlexTag(label: "Draft"),
                  const PlexTag(label: "Priority", selected: true),
                  PlexTag(
                    label: "Fragile",
                    color: colors.statusInfo,
                    onTap: () => setState(() => _tappedTag = "Fragile"),
                  ),
                  PlexTag(
                    label: "Hold",
                    onDeleted: () =>
                        setState(() => _tappedTag = "Hold removed"),
                  ),
                ],
              ),
              if (_tappedTag != null) ...[
                const SizedBox(height: PlexDim.small),
                Text(
                  _tappedTag!,
                  style: TextStyle(color: colors.textSecondary),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexTagInput",
          subtitle:
              "Enter appends a unique trimmed tag. Delete copies the list.",
          child: PlexTagInput(
            tags: _tags,
            hint: "Add tag",
            label: "Line tags",
            onChanged: (tags) => setState(() => _tags = tags),
          ),
        ),
      ],
    );
  }
}
