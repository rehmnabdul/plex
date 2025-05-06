// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

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
  }) {
    if (items == null && itemsAsync == null) {
      throw Exception("Items must be initialized or async item function must be initialized");
    }
    fieldType = TYPE_MULTISELECT;
  }

  PlexFormField.dateTime({
    required this.title,
    required this.onChange,
  }) {
    fieldType = TYPE_DATETIME;
  }
}

class PlexFormWidget<T> extends StatefulWidget {
  const PlexFormWidget({super.key, required this.entity, required this.onSubmit});

  final PlexForm entity;
  final void Function(T entity) onSubmit;

  @override
  State<PlexFormWidget> createState() => _PlexFormWidgetState();
}

class _PlexFormWidgetState extends State<PlexFormWidget> {
  List<Widget> getFields() {
    var fields = [
      for (var value in widget.entity.getFields(this)) ...{
        if (value.fieldType == PlexFormField.TYPE_INPUT) ...{
          if (value.type == String) ...{
            PlexFormFieldInput(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              isPassword: value.isPassword,
              inputKeyboardType: value.inputType ?? TextInputType.text,
              inputAction: value.inputAction,
              inputController: TextEditingController(text: value.initialValue?.toString()),
              inputOnChange: (v) => value.onChange(v.toString()),
            ),
          },
          if (value.type == int) ...{
            PlexFormFieldInput(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              inputKeyboardType: value.inputType ?? const TextInputType.numberWithOptions(decimal: false, signed: false),
              inputOnChange: (v) => value.onChange(int.tryParse(v)),
              inputAction: value.inputAction,
              inputController: TextEditingController(text: value.initialValue?.toString()),
              isPassword: value.isPassword,
            ),
          },
          if (value.type == double) ...{
            PlexFormFieldInput(
              properties: PlexFormFieldGeneric(title: value.title.toUpperCase(), enabled: value.editable),
              inputKeyboardType: value.inputType ?? const TextInputType.numberWithOptions(decimal: true, signed: false),
              inputAction: value.inputAction,
              inputOnChange: (v) => value.onChange(v),
              inputController: TextEditingController(text: value.initialValue?.toString()),
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
      }
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
            properties: PlexFormFieldGeneric.title("Save"),
            buttonClick: () => widget.onSubmit(widget.entity),
            buttonIcon: const Icon(Icons.save),
          ),
          spaceMedium(),
        ],
      ),
    );
  }
}
