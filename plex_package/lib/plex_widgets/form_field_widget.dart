import 'package:flutter/material.dart';
import 'package:plex_package/plex_theme.dart';
import 'package:plex_package/plex_utils/plex_dimensions.dart';
import 'package:plex_package/plex_widget.dart';
import 'package:plex_package/plex_widgets/plex_date_picker_widget.dart';
import 'package:plex_package/plex_widgets/plex_selection_list.dart';

class PlexInputWidget<T> extends StatefulWidget {
  static const TYPE_INPUT = 0;
  static const TYPE_DROPDOWN = 1;
  static const TYPE_DATE = 2;
  static const TYPE_BUTTON = 3;

  PlexInputWidget({
    Key? key,
    this.title,
    required this.type,
    this.helperText,
    this.editable = true,
    this.fieldColor = Colors.white,
    this.inputHint,
    this.inputController,
    this.inputKeyboardType = TextInputType.name,
    this.isPassword = false,
    this.inputOnChange,
    this.inputOnSubmit,
    this.dropdownItems,
    this.dropDownLeadingIcon,
    this.dropdownAsyncItems,
    this.dropdownItemWidget,
    this.dropdownOnSearch,
    this.dropdownItemAsString,
    this.dropdownItemOnSelect,
    this.dropdownSelectionController,
    this.buttonColor,
    this.buttonIcon,
    this.buttonClick,
  }) : super(key: key);

  String? title;
  int type;
  bool editable = true;
  String? helperText;
  Color fieldColor = Colors.white;

  //Input Field
  final String? inputHint;
  TextEditingController? inputController;
  TextInputType inputKeyboardType = TextInputType.name;
  bool isPassword = false;
  Function(String)? inputOnSubmit;
  Function(String)? inputOnChange;

  //Dropdown Field
  List<T>? dropdownItems;
  Widget Function(dynamic)? dropDownLeadingIcon;
  Future<List<dynamic>>? dropdownAsyncItems;
  Widget Function(dynamic)? dropdownItemWidget;
  bool Function(String, dynamic)? dropdownOnSearch;
  String Function(dynamic)? dropdownItemAsString;
  Function(dynamic)? dropdownItemOnSelect;

  //Button Field
  Color? buttonColor;
  Icon? buttonIcon;
  Function()? buttonClick;

  PlexWidgetController<T>? dropdownSelectionController;

  PlexWidgetController<T> getDropDownController() {
    dropdownSelectionController ??= PlexWidgetController<T>();
    return dropdownSelectionController!;
  }

  @override
  State<PlexInputWidget> createState() => _PlexInputWidgetState<T>();
}

class _PlexInputWidgetState<T> extends State<PlexInputWidget> {
  @override
  Widget build(BuildContext context) {
    Widget inputWidget = Container();

    if (widget.type == PlexInputWidget.TYPE_INPUT) {
      inputWidget = TextField(
        enabled: widget.editable,
        controller: widget.inputController,
        keyboardType: widget.inputKeyboardType,
        style: customTheme.textTheme.labelSmall!.copyWith(color: Colors.black),
        onSubmitted: (c) {
          widget.inputOnSubmit?.call(c.toString());
        },
        onChanged: (c) {
          widget.inputOnChange?.call(c.toString());
        },
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.inputHint,
        ),
      );
    } else if (widget.type == PlexInputWidget.TYPE_DROPDOWN) {
      inputWidget = SizedBox(
        height: 45,
        child: InkWell(
          onTap: () {
            if (!widget.editable) return;
            showSelectionList(
              context,
              items: widget.dropdownItems,
              asyncItems: widget.dropdownAsyncItems,
              leadingIcon: widget.dropDownLeadingIcon,
              itemText: (c) => widget.dropdownItemAsString!(c),
              onSelect: (c) {
                widget.getDropDownController().setValue(c);
                widget.dropdownItemOnSelect?.call(c);
              },
              onSearch: widget.dropdownOnSearch,
              itemWidget: widget.dropdownItemWidget,
            );
          },
          child: Row(
            children: [
              Expanded(
                child: PlexWidget<T>(
                  controller: widget.getDropDownController() as PlexWidgetController<T>,
                  createWidget: (context, data) {
                    return Text(
                      data != null ? widget.dropdownItemAsString!(data) : "N/A",
                      //TODO style: Styl.font_600_14.copyWith(color: Col.greyBlue),
                    );
                  },
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      );
    } else if (widget.type == PlexInputWidget.TYPE_DATE) {
      inputWidget = PlexDatePickerWidget(
        enabled: widget.editable,
        removePadding: true,
        startDate: widget.getDropDownController().data,
        onDateSelected: (dateTime) {
          widget.getDropDownController().setValue(dateTime);
        },
      );
    } else if (widget.type == PlexInputWidget.TYPE_BUTTON) {
      inputWidget = Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: Dim.medium),
        child: ElevatedButton(
          onPressed: () {
            widget.buttonClick?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor,
            foregroundColor: Colors.grey,
            textStyle: const TextStyle(fontSize: Dim.fontLarge),
          ),
          child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, alignment: WrapAlignment.center, children: [
            if (widget.buttonIcon != null) ...{
              Icon(widget.buttonIcon!.icon, color: customTheme.colorScheme.onPrimary),
            },
            if (widget.buttonIcon != null && widget.title != null) ...{
              spaceSmall(),
            },
            if (widget.title != null) ...{
              Text(
                widget.title!,
                style: TextStyle(color: customTheme.colorScheme.onPrimary),
              )
            },
          ]),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.type == PlexInputWidget.TYPE_BUTTON) ...{
          Padding(
            padding: const EdgeInsets.only(top: Dim.medium),
            child: inputWidget,
          ),
        } else ...{
          if (widget.title != null) ...{
            Padding(
              padding: const EdgeInsets.only(
                left: Dim.medium,
                right: Dim.medium,
                top: Dim.medium,
              ),
              child: Text(
                widget.title!,
                style: TextStyle(color: customTheme.primaryColor),
              ),
            ),
          },
          Container(
            decoration: BoxDecoration(color: widget.fieldColor, borderRadius: const BorderRadius.all(Radius.circular(Dim.small))),
            margin: const EdgeInsets.symmetric(vertical: Dim.small, horizontal: Dim.medium),
            padding: const EdgeInsets.symmetric(horizontal: Dim.small),
            child: inputWidget,
          ),
          if (widget.helperText != null) ...{
            Padding(
              padding: const EdgeInsets.only(
                left: Dim.medium,
                right: Dim.medium,
              ),
              child: Text(
                widget.helperText!,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          }
        },
      ],
    );
  }
}
