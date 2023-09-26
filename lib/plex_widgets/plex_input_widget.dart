import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_date_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_selection_list.dart';

// ignore: must_be_immutable
class PlexInputWidget<T> extends StatefulWidget {
  static const typeInput = 0;
  static const typeDropdown = 1;
  static const typeDate = 2;
  static const typeMultiSelect = 3;
  static const typeButton = 4;

  PlexInputWidget({
    Key? key,
    this.title,
    required this.type,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: Dim.medium, vertical: Dim.small),
    this.helperText,
    this.editable = true,
    this.fieldColor = Colors.white,
    this.inputHint,
    this.inputController,
    this.inputKeyboardType = TextInputType.name,
    this.isPassword = false,
    this.inputAction,
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
    this.multiSelectionController,
    this.multiInitialSelection,
    this.dropdownCustomOnTap,
    this.buttonColor,
    this.buttonIcon,
    this.buttonClick,
  }) : super(key: key);

  final String? title;
  final int type;
  final bool editable;
  final String? helperText;
  final Color fieldColor;
  final bool useMargin;
  final EdgeInsets margin;

  ///Input Field
  final String? inputHint;
  final TextEditingController? inputController;
  final TextInputType inputKeyboardType;
  final bool isPassword;
  final TextInputAction? inputAction;
  final Function(String value)? inputOnSubmit;
  final Function(String value)? inputOnChange;

  ///Dropdown Field
  final List<T>? dropdownItems;
  final Widget Function(dynamic item)? dropDownLeadingIcon;
  final Future<List<dynamic>>? dropdownAsyncItems;
  final Widget Function(dynamic item)? dropdownItemWidget;
  final bool Function(String query, dynamic item)? dropdownOnSearch;
  String Function(dynamic item)? dropdownItemAsString = (item) => item.toString();
  final Function(dynamic item)? dropdownItemOnSelect;
  final Function? dropdownCustomOnTap;

  ///Multiselect Fields
  final List<T>? multiInitialSelection;

  ///Button Field
  final Color? buttonColor;
  final Icon? buttonIcon;
  final Function()? buttonClick;

  final PlexWidgetController<T?>? dropdownSelectionController;
  final PlexWidgetController<List<T>?>? multiSelectionController;

  @override
  State<PlexInputWidget> createState() => _PlexInputWidgetState<T>();
}

class _PlexInputWidgetState<T> extends State<PlexInputWidget> {
  PlexWidgetController<T?>? _dropdownSelectionController;
  PlexWidgetController<List<T>?>? _multiSelectionController;

  getDropDownController() {
    _dropdownSelectionController ??= (widget.dropdownSelectionController ?? PlexWidgetController<T?>()) as PlexWidgetController<T?>?;
    return _dropdownSelectionController;
  }

  getMultiselectController() {
    _multiSelectionController ??= (widget.multiSelectionController ?? PlexWidgetController<List<T>?>()) as PlexWidgetController<List<T>?>?;
    return _multiSelectionController;
  }

  @override
  Widget build(BuildContext context) {
    Widget inputWidget = Container();
    if (widget.type == PlexInputWidget.typeInput) {
      inputWidget = TextField(
        enabled: widget.editable,
        controller: widget.inputController,
        keyboardType: widget.inputKeyboardType,
        textInputAction: widget.inputAction ?? TextInputAction.next,
        onSubmitted: (c) {
          widget.inputOnSubmit?.call(c.toString());
        },
        onChanged: (c) {
          widget.inputOnChange?.call(c.toString());
        },
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          // border: InputBorder.none,
          border: const OutlineInputBorder(),
          hintText: widget.inputHint,
          //prefixIcon: const Icon(Icons.search),
          //suffixIcon: _ClearButton(controller: _controllerFilled),
          labelText: widget.title ?? "",
          helperText: widget.helperText,
          filled: true,
        ),
      );
    } else if (widget.type == PlexInputWidget.typeButton) {
      inputWidget = widget.buttonIcon == null
          ? FilledButton(
              onPressed: () => widget.buttonClick?.call(),
              child: Text(widget.title ?? ""),
            )
          : FilledButton.tonalIcon(
              onPressed: () => widget.buttonClick?.call(),
              icon: widget.buttonIcon!,
              label: Text(widget.title ?? ""),
            );
    } else if (widget.type == PlexInputWidget.typeDropdown) {
      inputWidget = InkWell(
        onTap: () {
          if (!widget.editable) return;

          if (widget.dropdownCustomOnTap != null) {
            widget.dropdownCustomOnTap?.call();
            return;
          }

          showSelectionList(
            context,
            items: widget.dropdownItems,
            asyncItems: widget.dropdownAsyncItems,
            leadingIcon: widget.dropDownLeadingIcon,
            initialSelected: (getDropDownController() as PlexWidgetController<T?>).data,
            itemText: (c) => widget.dropdownItemAsString!(c),
            onSelect: (c) {
              getDropDownController().setValue(c);
              widget.dropdownItemOnSelect?.call(c);
            },
            onSearch: widget.dropdownOnSearch,
            itemWidget: widget.dropdownItemWidget,
          );
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(Dim.smallest)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dim.small, vertical: Dim.medium),
            child: Row(
              children: [
                Expanded(
                  child: PlexWidget<T?>(
                    controller: getDropDownController() as PlexWidgetController<T?>,
                    createWidget: (context, data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...{
                            Text("${widget.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: Dim.small)),
                          },
                          Text(data != null ? widget.dropdownItemAsString!(data) : "N/A"),
                        ],
                      );
                    },
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    } else if (widget.type == PlexInputWidget.typeDate) {
      inputWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(Dim.smallest),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dim.small, vertical: Dim.smallest),
          child: Row(
            children: [
              Expanded(
                child: PlexWidget<T?>(
                  controller: getDropDownController(),
                  createWidget: (context, data) {
                    return TextField(
                      readOnly: true,
                      showCursor: false,
                      onTap: () {
                        if (!widget.editable) return;
                        if (widget.editable == false) return;
                        showDatePicker(
                          context: context,
                          initialDate: getDropDownController().data ?? DateTime.now(),
                          firstDate: DateTime(2020, 1, 1),
                          lastDate: DateTime(2050, 12, 31),
                          useRootNavigator: true,
                        ).then((value) {
                          if (value != null) {
                            getDropDownController().setValue(value);
                          }
                        });
                      },
                      enabled: widget.editable,
                      controller: TextEditingController(text: (data as DateTime?)?.getFormattedStringFromDate() ?? "N/A"),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    );
                  },
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      );
    } else if (widget.type == PlexInputWidget.typeMultiSelect) {
      getMultiselectController().setValue(widget.multiInitialSelection);
      inputWidget = InkWell(
        onTap: () {
          if (!widget.editable) return;

          if (widget.dropdownCustomOnTap != null) {
            widget.dropdownCustomOnTap?.call();
            return;
          }

          showMultiSelection(
            context,
            items: widget.dropdownItems,
            asyncItems: widget.dropdownAsyncItems,
            leadingIcon: widget.dropDownLeadingIcon,
            initialSelection: widget.multiInitialSelection,
            itemText: (c) => widget.dropdownItemAsString!(c),
            onSelect: (c) {
              getMultiselectController().setValue(c);
              widget.dropdownItemOnSelect?.call(c);
            },
            onSearch: widget.dropdownOnSearch,
            itemWidget: widget.dropdownItemWidget,
          );
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(Dim.smallest)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dim.small, vertical: Dim.medium),
            child: Row(
              children: [
                Expanded(
                  child: PlexWidget<List<T>?>(
                    controller: getMultiselectController() as PlexWidgetController<List<T>?>,
                    createWidget: (context, data) {
                      List<T> selectionData = data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...{
                            Text("${widget.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: Dim.small)),
                          },
                          Text(data != null ? selectionData.map((e) => widget.dropdownItemAsString!(e)).join(", ") : "N/A"),
                        ],
                      );
                    },
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }
    if (widget.useMargin) {
      return Padding(
        padding: widget.margin,
        child: inputWidget,
      );
    }
    return inputWidget;
  }
}
