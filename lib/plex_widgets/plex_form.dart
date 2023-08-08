import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

abstract class PlexForm {
  List<PlexField> getFields();
}

class PlexField {
  bool thirdParty = false;

  String title;
  dynamic initialVaue;
  late Type type;
  bool isPassword = false;

  String Function(dynamic item)? itemAsString = (item) => item.toString();
  List<dynamic>? dropDownItems;
  Future<List<dynamic>>? dropDownItemsAsync;
  bool Function(String, dynamic)? onSearch;
  Widget Function(dynamic)? dropdownWidget;
  Widget Function(dynamic)? dropdownLeadingWidget;

  Function(dynamic value) onChange;

  PlexField.input({
    required this.title,
    required this.type,
    required this.onChange,
    this.isPassword = false,
    this.initialVaue,
  }) {
    thirdParty = false;
  }

  PlexField.dropDown({
    required this.title,
    required this.onChange,
    this.itemAsString,
    this.dropDownItems,
    this.dropDownItemsAsync,
    this.onSearch,
    this.dropdownWidget,
    this.dropdownLeadingWidget,
    this.initialVaue,
  }) {
    if (dropDownItems == null && dropDownItemsAsync == null) {
      throw Exception("Items must be initialized or async item function must be initialized");
    }
    itemAsString ??= (item) => item.toString();
    thirdParty = true;
  }
}

class PlexFormWidget extends StatefulWidget {
  const PlexFormWidget({Key? key, required this.entity, required this.onSubmit}) : super(key: key);

  final PlexForm entity;
  final Function onSubmit;

  @override
  State<PlexFormWidget> createState() => _PlexFormWidgetState();
}

class _PlexFormWidgetState extends State<PlexFormWidget> {
  List<Widget> getFields() {

    var fields = [
      for (var value in widget.entity.getFields()) ...{
        if (!value.thirdParty && value.type == String) ...{
          PlexInputWidget<String>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeInput,
            isPassword: value.isPassword,
            inputController: TextEditingController(text: value.initialVaue?.toString()),
            inputOnChange: (v) {
              value.onChange(v.toString());
            },
          ),
        },
        if (!value.thirdParty && value.type == int) ...{
          PlexInputWidget<int>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeInput,
            inputKeyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
            inputOnChange: (v) => value.onChange(int.tryParse(v)),
            inputController: TextEditingController(text: value.initialVaue?.toString()),
            isPassword: value.isPassword,
          ),
        },
        if (!value.thirdParty && value.type == double) ...{
          PlexInputWidget<double>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeInput,
            inputKeyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputOnChange: (v) => value.onChange(double.tryParse(v)),
            inputController: TextEditingController(text: value.initialVaue?.toString()),
            isPassword: value.isPassword,
          ),
        },
        if (!value.thirdParty && value.type == bool) ...{
          PlexInputWidget<bool>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeDropdown,
            dropdownSelectionController: PlexWidgetController(data: value.initialVaue),
            dropdownItems: const [true, false],
            dropdownItemAsString: (v) => v ? "True" : "False",
            dropdownItemOnSelect: (v) => value.onChange(v),
          ),
        },
        if (!value.thirdParty && value.type == DateTime) ...{
          PlexInputWidget<DateTime>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeDate,
            dropdownSelectionController: PlexWidgetController(data: value.initialVaue),
            dropdownItemOnSelect: (v) => value.onChange(v),
          ),
        },
        if (value.thirdParty) ...{
          PlexInputWidget(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.typeDropdown,
            dropdownSelectionController: PlexWidgetController(data: value.initialVaue),
            dropdownItemOnSelect: (p) => value.onChange(p),
            dropdownItemAsString: (p) => value.itemAsString!(p),
            dropdownItems: value.dropDownItems,
            dropdownAsyncItems: value.dropDownItemsAsync,
            dropdownOnSearch: value.onSearch,
            dropdownItemWidget: value.dropdownWidget,
            dropDownLeadingIcon: value.dropdownLeadingWidget,
          ),
        },
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
            buttonClick: () => widget.onSubmit(),
            buttonIcon: const Icon(Icons.save),
          ),
          spaceMedium(),
        ],
      ),
    );
  }
}
