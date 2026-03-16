// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:plex/plex_database/plex_database.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_l10n/plex_localization.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

abstract mixin class PlexForm {
  List<PlexFormField> getFields(State<StatefulWidget> context);
}

class PlexFormField {
  static const TYPE_INPUT = 0;
  static const TYPE_DROPDOWN = 1;
  static const TYPE_MULTISELECT = 2;
  static const TYPE_DATE = 3;
  static const TYPE_TIME = 4;
  static const TYPE_DATETIME = 5;
  int fieldType = 0;

  String title;
  dynamic initialValue;
  bool Function(dynamic formState)? showWhen;
  List<dynamic>? initialSelection;
  late Type type;
  bool isPassword = false;
  TextInputType? inputType;
  TextInputAction? inputAction;
  bool editable = true;

  String Function(dynamic item)? itemAsString = (item) => item.toString();
  List<dynamic>? items;
  Future<List<dynamic>>? itemsAsync;
  bool Function(String, dynamic)? onSearch;
  Widget Function(dynamic)? dropdownWidget;
  Widget Function(dynamic)? dropdownLeadingWidget;

  Function(dynamic value) onChange;

  PlexFormField.input({
    required this.title,
    required this.type,
    required this.onChange,
    this.editable = true,
    this.inputType,
    this.inputAction,
    this.isPassword = false,
    this.initialValue,
    this.showWhen,
  }) {
    fieldType = TYPE_INPUT;
  }

  PlexFormField.dropDown({
    required this.title,
    required this.onChange,
    this.editable = true,
    this.itemAsString,
    this.items,
    this.itemsAsync,
    this.onSearch,
    this.dropdownWidget,
    this.dropdownLeadingWidget,
    this.initialValue,
    this.showWhen,
  }) {
    if (items == null && itemsAsync == null) {
      throw Exception("Items must be initialized or async item function must be initialized");
    }
    itemAsString ??= (item) => item.toString();
    fieldType = TYPE_DROPDOWN;
  }

  PlexFormField.multiselect({
    required this.title,
    required this.onChange,
    this.itemAsString,
    this.editable = true,
    this.initialSelection,
    this.items,
    this.itemsAsync,
    this.dropdownWidget,
    this.dropdownLeadingWidget,
    this.showWhen,
  }) {
    if (items == null && itemsAsync == null) {
      throw Exception("Items must be initialized or async item function must be initialized");
    }
    fieldType = TYPE_MULTISELECT;
  }

  PlexFormField.dateTime({
    required this.title,
    required this.onChange,
    this.showWhen,
  }) {
    fieldType = TYPE_DATETIME;
  }
}

class PlexFormWidget<T> extends StatefulWidget {
  const PlexFormWidget({
    super.key,
    required this.entity,
    required this.onSubmit,
    this.persistenceKey,
    this.db,
  });

  final PlexForm entity;
  final void Function(T entity) onSubmit;
  final String? persistenceKey;
  final PlexDb? db;

  @override
  State<PlexFormWidget> createState() => _PlexFormWidgetState();
}

class _PlexFormWidgetState extends State<PlexFormWidget> {
  Map<String, dynamic>? _restoredState;

  @override
  void initState() {
    super.initState();
    if (widget.persistenceKey != null && widget.db != null) {
      _loadDraft();
    }
  }

  Future<void> _loadDraft() async {
    final key = 'form_draft:${widget.persistenceKey}';
    final data = await widget.db!.getFromCache(key);
    if (data != null && mounted) {
      for (var field in widget.entity.getFields(this)) {
        if (data.containsKey(field.title)) {
          field.onChange(data[field.title]);
        }
      }
      setState(() => _restoredState = data);
    }
  }

  Future<void> _saveDraft(Map<String, dynamic> state) async {
    if (widget.persistenceKey == null || widget.db == null) return;
    final key = 'form_draft:${widget.persistenceKey}';
    await widget.db!.putInCache(key, state);
  }

  void _onFieldChange(String title, dynamic value) {
    if (widget.persistenceKey != null && widget.db != null) {
      final state = Map<String, dynamic>.from(_restoredState ?? {});
      state[title] = value;
      _restoredState = state;
      _saveDraft(state);
    }
  }

  List<Widget> getFields() {
    final formState = widget.entity;
    var fields = [
      for (var value in widget.entity.getFields(this))
        if (value.showWhen != null && !value.showWhen!(formState))
          const SizedBox.shrink()
        else ...[
          if (value.fieldType == PlexFormField.TYPE_INPUT) ...{
          if (value.type == String) ...{
            PlexFormFieldInput(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              isPassword: value.isPassword,
              inputKeyboardType: value.inputType ?? TextInputType.text,
              inputAction: value.inputAction,
              inputController: TextEditingController(text: (_restoredState?[value.title] ?? value.initialValue)?.toString()),
              inputOnChange: (v) {
                value.onChange(v.toString());
                _onFieldChange(value.title, v.toString());
              },
            ),
          },
          if (value.type == int) ...{
            PlexFormFieldInput(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              inputKeyboardType: value.inputType ?? const TextInputType.numberWithOptions(decimal: false, signed: false),
              inputOnChange: (v) {
                final parsed = int.tryParse(v);
                value.onChange(parsed);
                _onFieldChange(value.title, parsed);
              },
              inputAction: value.inputAction,
              inputController: TextEditingController(text: (_restoredState?[value.title] ?? value.initialValue)?.toString()),
              isPassword: value.isPassword,
            ),
          },
          if (value.type == double) ...{
            PlexFormFieldInput(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              inputKeyboardType: value.inputType ?? const TextInputType.numberWithOptions(decimal: true, signed: false),
              inputAction: value.inputAction,
              inputOnChange: (v) {
                value.onChange(v);
                _onFieldChange(value.title, v);
              },
              inputController: TextEditingController(text: (_restoredState?[value.title] ?? value.initialValue)?.toString()),
              isPassword: value.isPassword,
            ),
          },
          if (value.type == bool) ...{
            PlexFormFieldDropdown<bool>(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              dropdownSelectionController: PlexWidgetController(data: value.initialValue),
              dropdownItems: const [true, false],
              dropdownItemAsString: (v) => v ? "True" : "False",
              dropdownItemOnSelect: (v) => value.onChange(v),
            ),
          },
          if (value.type == DateTime) ...{
            PlexFormFieldDate(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              type: PlexFormFieldDateType.typeDateTime,
              selectionController: PlexWidgetController(data: value.initialValue),
              onSelect: (v) => value.onChange(v),
            ),
          },
        } else if (value.fieldType == PlexFormField.TYPE_DROPDOWN) ...{
          PlexFormFieldDropdown(
            properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
            dropdownSelectionController: PlexWidgetController(data: value.initialValue),
            dropdownItemOnSelect: (p) {
              setState(() {
                value.onChange(p);
              });
            },
            dropdownItemAsString: (p) => value.itemAsString!(p),
            dropdownItems: value.items,
            dropdownAsyncItems: value.itemsAsync,
            dropdownOnSearch: value.onSearch,
            dropdownItemWidget: value.dropdownWidget,
            dropDownLeadingIcon: value.dropdownLeadingWidget,
          ),
        } else if (value.fieldType == PlexFormField.TYPE_MULTISELECT) ...{
          PlexFormFieldMultiSelect<dynamic>(
            properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
            multiSelectionController: PlexWidgetController(data: value.initialValue),
            dropdownItemOnSelect: (p) {
              setState(() {
                value.onChange(p);
              });
            },
            dropdownItemAsString: (p) => value.itemAsString!(p),
            dropdownItems: value.items,
            dropdownAsyncItems: value.itemsAsync,
            dropdownOnSearch: value.onSearch,
            dropdownItemWidget: value.dropdownWidget,
            dropDownLeadingIcon: value.dropdownLeadingWidget,
            multiInitialSelection: value.initialSelection,
          ),
        } else if (value.fieldType == PlexFormField.TYPE_DATETIME) ...{
          PlexFormFieldDate(
            properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
            type: PlexFormFieldDateType.typeDateTime,
            selectionController: PlexWidgetController(data: value.initialValue),
            onSelect: (p) {
              setState(() {
                value.onChange(p);
              });
            },
          ),
        }
        ]
    ];
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...getFields(),
          PlexFormFieldButton(
            properties: PlexFormFieldGeneric.title(context.plexStrings.formSave),
            buttonClick: () => widget.onSubmit(widget.entity),
            buttonIcon: const Icon(Icons.save),
          ),
          spaceMedium(),
        ],
      ),
    );
  }
}
