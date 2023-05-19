import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_date_picker_widget.dart';
import 'package:plex/plex_widgets/plex_selection_list.dart';

class PlexInputWidget<T> extends StatefulWidget {
  static const typeInput = 0;
  static const typeDropdown = 1;
  static const typeDate = 2;
  static const typeButton = 3;

  const PlexInputWidget({
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

  final String? title;
  final int type;
  final bool editable;
  final String? helperText;
  final Color fieldColor;

  //Input Field
  final String? inputHint;
  final TextEditingController? inputController;
  final TextInputType inputKeyboardType;
  final bool isPassword;
  final Function(String)? inputOnSubmit;
  final Function(String)? inputOnChange;

  //Dropdown Field
  final List<T>? dropdownItems;
  final Widget Function(dynamic)? dropDownLeadingIcon;
  final Future<List<dynamic>>? dropdownAsyncItems;
  final Widget Function(dynamic)? dropdownItemWidget;
  final bool Function(String, dynamic)? dropdownOnSearch;
  final String Function(dynamic)? dropdownItemAsString;
  final Function(dynamic)? dropdownItemOnSelect;

  //Button Field
  final Color? buttonColor;
  final Icon? buttonIcon;
  final Function()? buttonClick;

  final PlexWidgetController<T>? dropdownSelectionController;

  @override
  State<PlexInputWidget> createState() => _PlexInputWidgetState<T>();
}

class _PlexInputWidgetState<T> extends State<PlexInputWidget> {

  PlexWidgetController<T>? _dropdownSelectionController;

  getDropDownController() {
    _dropdownSelectionController ??= (widget.dropdownSelectionController ?? PlexWidgetController<T>()) as PlexWidgetController<T>?;
    return _dropdownSelectionController;
  }

  @override
  Widget build(BuildContext context) {
    Widget inputWidget = Container();

    if (widget.type == PlexInputWidget.typeInput) {
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
    } else if (widget.type == PlexInputWidget.typeDropdown) {
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
                getDropDownController().setValue(c);
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
                  controller: getDropDownController() as PlexWidgetController<T>,
                  createWidget: (context, data) {
                    return Text(
                      data != null ? widget.dropdownItemAsString!(data) : "N/A",
                    );
                  },
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      );
    } else if (widget.type == PlexInputWidget.typeDate) {
      inputWidget = PlexDatePickerWidget(
        enabled: widget.editable,
        removePadding: true,
        startDate: getDropDownController().data,
        onDateSelected: (dateTime) {
          getDropDownController().setValue(dateTime);
        },
      );
    } else if (widget.type == PlexInputWidget.typeButton) {
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
        if (widget.type == PlexInputWidget.typeButton) ...{
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
