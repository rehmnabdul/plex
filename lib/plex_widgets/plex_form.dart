// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

abstract class PlexForm {
  List<PlexFormField> getFields();
}

class PlexFormField {
  static const TYPE_INPUT = 0;
  static const TYPE_DROPDOWN = 1;
  static const TYPE_MULTISELECT = 2;
  int fieldType = 0;

  String title;
  dynamic initialValue;
  List<dynamic>? initialSelection;
  late Type type;
  bool isPassword = false;
  TextInputType? inputType;
  TextInputAction? inputAction;

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
    this.initialSelection,
    this.items,
    this.itemsAsync,
  }) {
    if (items == null && itemsAsync == null) {
      throw Exception("Items must be initialized or async item function must be initialized");
    }
    fieldType = TYPE_MULTISELECT;
  }
}

class PlexFormWidget<T> extends StatefulWidget {
  const PlexFormWidget({Key? key, required this.entity, required this.onSubmit}) : super(key: key);

  final PlexForm entity;
  final void Function(T entity) onSubmit;

  @override
  State<PlexFormWidget> createState() => _PlexFormWidgetState();
}

class _PlexFormWidgetState extends State<PlexFormWidget> {
  List<Widget> getFields() {
    var fields = [
      for (var value in widget.entity.getFields()) ...{
        if (value.fieldType == PlexFormField.TYPE_INPUT) ...{
          if (value.type == String) ...{
            PlexInputWidget<String>(
              title: value.title.toUpperCase(),
              type: PlexInputWidget.typeInput,
              isPassword: value.isPassword,
              inputKeyboardType: value.inputType ?? TextInputType.text,
              inputAction: value.inputAction,
              inputController: TextEditingController(text: value.initialValue?.toString()),
              inputOnChange: (v) => value.onChange(v.toString()),
            ),
          },
          if (value.type == int) ...{
            PlexInputWidget<int>(
              title: value.title.toUpperCase(),
              type: PlexInputWidget.typeInput,
              inputKeyboardType: value.inputType ?? const TextInputType.numberWithOptions(decimal: false, signed: false),
              inputOnChange: (v) => value.onChange(int.tryParse(v)),
              inputAction: value.inputAction,
              inputController: TextEditingController(text: value.initialValue?.toString()),
              isPassword: value.isPassword,
            ),
          },
          if (value.type == double) ...{
            PlexInputWidget<double>(
              title: value.title.toUpperCase(),
              type: PlexInputWidget.typeInput,
              inputKeyboardType: value.inputType ?? const TextInputType.numberWithOptions(decimal: true, signed: false),
              inputAction: value.inputAction,
              inputOnChange: (v) => value.onChange(v),
              inputController: TextEditingController(text: value.initialValue?.toString()),
              isPassword: value.isPassword,
            ),
          },
          if (value.type == bool) ...{
            PlexInputWidget<bool>(
              title: value.title.toUpperCase(),
              type: PlexInputWidget.typeDropdown,
              dropdownSelectionController: PlexWidgetController(data: value.initialValue),
              dropdownItems: const [true, false],
              dropdownItemAsString: (v) => v ? "True" : "False",
              dropdownItemOnSelect: (v) => value.onChange(v),
            ),
          },
          if (value.type == DateTime) ...{
            PlexInputWidget<DateTime>(
              title: value.title.toUpperCase(),
              type: PlexInputWidget.typeDate,
              dropdownSelectionController: PlexWidgetController(data: value.initialValue),
              dropdownItemOnSelect: (v) => value.onChange(v),
            ),
          },
        } else if (value.fieldType == PlexFormField.TYPE_DROPDOWN) ...{
          PlexInputWidget(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeDropdown,
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
          PlexInputWidget(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeMultiSelect,
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
            multiInitialSelection: value.initialSelection,
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
          PlexInputWidget(
            type: PlexInputWidget.typeButton,
            title: "Save",
            buttonClick: () => widget.onSubmit(widget.entity),
            buttonIcon: const Icon(Icons.save),
          ),
          spaceMedium(),
        ],
      ),
    );
  }
}
