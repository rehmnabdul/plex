import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex_app/screens/example_chrome.dart';

class UiKitFormsScreen extends StatefulWidget {
  const UiKitFormsScreen({super.key});

  @override
  State<UiKitFormsScreen> createState() => _UiKitFormsScreenState();
}

class _UiKitFormsScreenState extends State<UiKitFormsScreen> {
  final _textController = TextEditingController(text: "Warehouse A");
  final _dropdownController = PlexWidgetController<String?>(data: "Draft");
  final _multiSelectController =
      PlexWidgetController<List<String>?>(data: ["Priority"]);
  final _autoCompleteController = PlexWidgetController<String?>();
  bool _accepted = true;
  bool _notify = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "Text, date, dropdown",
          subtitle: "Restyled PlexFormField* using theme tokens",
          child: Column(
            children: [
              PlexFormFieldInput(
                properties: const PlexFormFieldGeneric(
                  title: "Location",
                  helperText: "Shown on the shipment label",
                  useMargin: false,
                ),
                inputHint: "Enter a location",
                inputController: _textController,
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldDate(
                type: PlexFormFieldDateType.typeDate,
                properties: const PlexFormFieldGeneric(
                  title: "Ship date",
                  useMargin: false,
                ),
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldDropdown<String>(
                properties: const PlexFormFieldGeneric(
                  title: "Status",
                  useMargin: false,
                ),
                dropdownItems: const ["Draft", "Open", "Closed"],
                dropdownSelectionController: _dropdownController,
                showClearButton: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Checkbox & switch",
          subtitle: "Phase 2 — PlexFormFieldCheckbox / PlexFormFieldSwitch",
          child: Column(
            children: [
              PlexFormFieldCheckbox(
                properties: const PlexFormFieldGeneric(
                  title: "Accept terms",
                  helperText: "Required to continue",
                  useMargin: false,
                ),
                value: _accepted,
                onChanged: (value) {
                  setState(() => _accepted = value ?? false);
                },
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldSwitch(
                properties: const PlexFormFieldGeneric(
                  title: "Email notifications",
                  helperText: "Apply immediately",
                  useMargin: false,
                ),
                value: _notify,
                onChanged: (value) {
                  setState(() => _notify = value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Multi-select & autocomplete",
          child: Column(
            children: [
              PlexFormFieldMultiSelect<String>(
                properties: const PlexFormFieldGeneric(
                  title: "Tags",
                  useMargin: false,
                ),
                dropdownItems: const ["Priority", "Fragile", "Export"],
                multiSelectionController: _multiSelectController,
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldAutoComplete<String>(
                properties: const PlexFormFieldGeneric(
                  title: "Customer",
                  useMargin: false,
                ),
                dropdownSelectionController: _autoCompleteController,
                autoCompleteItems: (query) async {
                  await Future<void>.delayed(const Duration(milliseconds: 250));
                  const items = ["Acme Co", "Northwind", "Contoso"];
                  if (query.isEmpty) return items;
                  return items
                      .where((item) =>
                          item.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
