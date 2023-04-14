import 'package:flutter/material.dart';
import 'package:plex_package/plex_utils/plex_dimensions.dart';
import 'package:plex_package/plex_widget.dart';
import 'package:plex_package/plex_widgets/form_field_widget.dart';

abstract class PlexForm {
  List<PlexField> getFields();
}

class PlexField {
  bool thirdParty = false;

  String title;
  dynamic initialVaue;
  late Type type;
  bool isPassword = false;

  String Function(dynamic item) itemAsString = (item) => item.toString();
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
    required this.itemAsString,
    this.dropDownItems,
    this.dropDownItemsAsync,
    this.onSearch,
    this.dropdownWidget,
    this.dropdownLeadingWidget,
    this.initialVaue,
  }) {
    if(dropDownItems == null && dropDownItemsAsync == null) {
     throw Exception("Items must be initialized or asycn item function must be initialized");
    }
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
    var controllers = [];

    var fields = [
      for (var value in widget.entity.getFields()) ...{
        if (!value.thirdParty && value.type == String) ...{
          PlexInputWidget<String>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.TYPE_INPUT,
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
            type: PlexInputWidget.TYPE_INPUT,
            inputKeyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
            inputOnChange: (v) => value.onChange(int.tryParse(v)),
            inputController: TextEditingController(text: value.initialVaue?.toString()),
            isPassword: value.isPassword,
          ),
        },
        if (!value.thirdParty && value.type == double) ...{
          PlexInputWidget<double>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.TYPE_INPUT,
            inputKeyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputOnChange: (v) => value.onChange(double.tryParse(v)),
            inputController: TextEditingController(text: value.initialVaue?.toString()),
            isPassword: value.isPassword,
          ),
        },
        if (!value.thirdParty && value.type == bool) ...{
          PlexInputWidget<bool>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.TYPE_DROPDOWN,
            dropdownSelectionController: PlexWidgetController(data: value.initialVaue),
            dropdownItems: const [true, false],
            dropdownItemAsString: (v) => v ? "True" : "False",
            dropdownItemOnSelect: (v) => value.onChange(v),
          ),
        },
        if (!value.thirdParty && value.type == DateTime) ...{
          PlexInputWidget<DateTime>(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.TYPE_DATE,
            dropdownSelectionController: PlexWidgetController(data: value.initialVaue),
            dropdownItemOnSelect: (v) => value.onChange(v),
          ),
        },
        if (value.thirdParty) ...{
          PlexInputWidget(
            title: value.title.toUpperCase(),
            type: PlexInputWidget.TYPE_DROPDOWN,
            dropdownSelectionController: PlexWidgetController(data: value.initialVaue),
            dropdownItemOnSelect: (p) => value.onChange(p),
            dropdownItemAsString: (p) => value.itemAsString(p),
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
            type: PlexInputWidget.TYPE_BUTTON,
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
