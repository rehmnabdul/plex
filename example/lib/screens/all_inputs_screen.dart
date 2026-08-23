import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_avatar.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_icon_button.dart';
import 'package:plex/plex_widgets/plex_info_dialog.dart';
import 'package:plex_app/screens/example_chrome.dart';

/// Full catalog of form field widgets. Focused visual QA lives under Design system.
class AllInputsScreen extends StatefulWidget {
  const AllInputsScreen({super.key});

  @override
  State<AllInputsScreen> createState() => _AllInputsScreenState();
}

class _AllInputsScreenState extends State<AllInputsScreen> {
  final _textEditingController = TextEditingController(text: "Initial Text");
  final _errorController =
      PlexWidgetController(data: "This is an error message");
  final _dateController = PlexWidgetController<DateTime?>();
  final _timeController = PlexWidgetController<DateTime?>();
  final _dateTimeController = PlexWidgetController<DateTime?>();
  final _dropdownController = PlexWidgetController<String?>();
  final _multiSelectController =
      PlexWidgetController<List<String>?>(data: ['Option 2']);
  final _autoCompleteController = PlexWidgetController<String?>();
  bool _accepted = true;
  bool _notify = true;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScrollPage(
      children: [
        ExampleCard(
          title: "Dialogs",
          actions: const PlexBadge(label: "Catalog", tone: PlexBadgeTone.info),
          child: PlexFormFieldButton(
            properties: const PlexFormFieldGeneric(
              title: "Show PlexInfoDialog",
              useMargin: false,
            ),
            buttonType: PlexButtonType.text,
            buttonClick: () {
              PlexInfoDialog.show(context: context);
            },
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexFormFieldInput",
          child: Column(
            children: [
              PlexFormFieldInput(
                properties: const PlexFormFieldGeneric(
                  title: "Text input",
                  useMargin: false,
                ),
                inputHint: "Enter some text",
                inputController: _textEditingController,
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldInput(
                properties: const PlexFormFieldGeneric(
                  title: "Password",
                  useMargin: false,
                ),
                inputHint: "Enter your password",
                isPassword: true,
                maxInputLength: 20,
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldInput(
                properties: const PlexFormFieldGeneric(
                  title: "Numeric",
                  useMargin: false,
                ),
                inputHint: "Enter a number",
                inputKeyboardType: TextInputType.number,
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldInput(
                properties: const PlexFormFieldGeneric(
                  title: "Prefix / suffix",
                  useMargin: false,
                ),
                prefixIcon: const Icon(Icons.person),
                suffixIcon: const Icon(Icons.info_outline),
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldInput(
                properties: const PlexFormFieldGeneric(
                  title: "Disabled",
                  enabled: false,
                  useMargin: false,
                ),
                inputHint: "This field is disabled",
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldInput(
                properties: const PlexFormFieldGeneric(
                  title: "With error",
                  useMargin: false,
                ),
                errorController: _errorController,
                inputHint: "This field has an error",
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexFormFieldDate",
          child: Column(
            children: [
              PlexFormFieldDate(
                type: PlexFormFieldDateType.typeDate,
                properties: const PlexFormFieldGeneric(
                  title: "Date",
                  useMargin: false,
                ),
                selectionController: _dateController,
                minDatetime: DateTime.now().subtract(const Duration(days: 30)),
                maxDatetime: DateTime.now().add(const Duration(days: 30)),
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldDate(
                type: PlexFormFieldDateType.typeTime,
                properties: const PlexFormFieldGeneric(
                  title: "Time",
                  useMargin: false,
                ),
                selectionController: _timeController,
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldDate(
                type: PlexFormFieldDateType.typeDateTime,
                properties: const PlexFormFieldGeneric(
                  title: "Date & time",
                  useMargin: false,
                ),
                selectionController: _dateTimeController,
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Dropdown, multi-select, autocomplete",
          child: Column(
            children: [
              PlexFormFieldDropdown<String>(
                properties: const PlexFormFieldGeneric(
                  title: "Dropdown",
                  useMargin: false,
                ),
                dropdownItems: const [
                  "Option 1",
                  "Option 2",
                  "Option 3",
                  "Another Option with a long name"
                ],
                dropdownSelectionController: _dropdownController,
                initialSelection: "Option 1",
                dropdownItemAsString: (item) => item.toUpperCase(),
                showClearButton: true,
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldMultiSelect<String>(
                properties: const PlexFormFieldGeneric(
                  title: "Multi-select",
                  useMargin: false,
                ),
                dropdownItems: const [
                  "Option A",
                  "Option B",
                  "Option C",
                  "Option D"
                ],
                multiSelectionController: _multiSelectController,
                dropdownItemAsString: (item) => "Item: $item",
              ),
              const SizedBox(height: PlexDim.small),
              PlexFormFieldAutoComplete<String>(
                properties: const PlexFormFieldGeneric(
                  title: "Autocomplete",
                  useMargin: false,
                ),
                dropdownSelectionController: _autoCompleteController,
                autoCompleteItems: (query) async {
                  await Future<void>.delayed(const Duration(milliseconds: 500));
                  const items = [
                    "Apple",
                    "Banana",
                    "Cherry",
                    "Date",
                    "Elderberry"
                  ];
                  if (query.isEmpty) return items;
                  return items
                      .where((item) =>
                          item.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                },
                inputDelay: 300,
                showBarCode: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "Checkbox / switch",
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
          title: "Buttons, icon buttons, badge, avatar",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: PlexDim.small,
                runSpacing: PlexDim.small,
                children: [
                  for (final type in [
                    PlexButtonType.elevated,
                    PlexButtonType.text,
                    PlexButtonType.outlined,
                    PlexButtonType.filled,
                    PlexButtonType.filledTonal,
                    PlexButtonType.ink,
                    PlexButtonType.danger,
                  ])
                    PlexFormFieldButton(
                      properties: PlexFormFieldGeneric(
                        title: type.name,
                        useMargin: false,
                      ),
                      buttonType: type,
                      buttonClick: () {
                        context.showMessage("${type.name} clicked",
                            title: "Button");
                      },
                    ),
                  PlexFormFieldButton(
                    properties: const PlexFormFieldGeneric(
                      title: "Loading",
                      useMargin: false,
                    ),
                    loading: true,
                    buttonClick: () {},
                  ),
                ],
              ),
              const SizedBox(height: PlexDim.medium),
              Row(
                children: [
                  PlexIconButton(
                    icon: const Icon(Icons.more_vert),
                    label: "More",
                    onPressed: () {},
                  ),
                  PlexIconButton(
                    icon: const Icon(Icons.add),
                    variant: PlexIconButtonVariant.solid,
                    label: "Add",
                    onPressed: () {},
                  ),
                  PlexIconButton(
                    icon: const Icon(Icons.filter_list),
                    variant: PlexIconButtonVariant.outline,
                    label: "Filter",
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: PlexDim.medium),
              const Wrap(
                spacing: PlexDim.small,
                runSpacing: PlexDim.small,
                children: [
                  PlexBadge(label: "Neutral"),
                  PlexBadge(
                      label: "Info", tone: PlexBadgeTone.info, dot: true),
                  PlexBadge(label: "Success", tone: PlexBadgeTone.success),
                  PlexBadge(
                    label: "Warning",
                    tone: PlexBadgeTone.warning,
                    appearance: PlexBadgeAppearance.outline,
                  ),
                  PlexBadge(
                    label: "Danger",
                    tone: PlexBadgeTone.danger,
                    appearance: PlexBadgeAppearance.solid,
                  ),
                ],
              ),
              const SizedBox(height: PlexDim.medium),
              const Row(
                children: [
                  PlexAvatar(name: "Ada Lovelace"),
                  SizedBox(width: PlexDim.small),
                  PlexAvatar(
                    name: "Grace Hopper",
                    size: 32,
                    square: true,
                    status: PlexAvatarStatus.online,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
