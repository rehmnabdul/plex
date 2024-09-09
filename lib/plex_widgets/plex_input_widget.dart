import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_date_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_selection_list.dart';

enum PlexInputWidgetType {
  typeInput,
  typeDropdown,
  typeDate,
  typeTime,
  typeDateTime,
  typeMultiSelect,
  typeButton,
  typeAutoComplete,
}

// ignore: must_be_immutable
class PlexInputWidget<T> extends StatefulWidget {
  PlexInputWidget({
    super.key,
    this.title,
    required this.type,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
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
    this.inputFocusNode,
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
    this.customMultiSelectedWidget,
    this.dropdownCustomOnTap,
    this.autoCompleteItems,
    this.buttonStyle,
    this.buttonIcon,
    this.buttonClick,
    this.buttonEnabled = true,
  });

  final String? title;
  final PlexInputWidgetType type;
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
  final FocusNode? inputFocusNode;

  ///Dropdown Field
  final List<T>? dropdownItems;
  final Widget Function(dynamic item)? dropDownLeadingIcon;
  final Future<List<dynamic>>? dropdownAsyncItems;
  final Widget Function(dynamic item)? dropdownItemWidget;
  final bool Function(String query, dynamic item)? dropdownOnSearch;
  String Function(dynamic item)? dropdownItemAsString = (item) => item.toString();
  final Function(dynamic item)? dropdownItemOnSelect;
  final Function? dropdownCustomOnTap;

  ///AutoComplete Field
  final Future<List<dynamic>> Function(String query)? autoCompleteItems;

  ///Multiselect Fields
  final List<T>? multiInitialSelection;
  final Widget Function(dynamic)? customMultiSelectedWidget;

  ///Button Field
  final Widget? buttonIcon;
  final Function()? buttonClick;
  final bool buttonEnabled;
  final ButtonStyle? buttonStyle;

  final PlexWidgetController<T?>? dropdownSelectionController;
  final PlexWidgetController<List<T>?>? multiSelectionController;

  bool isIconButton() {
    return buttonIcon != null && title == null;
  }

  @override
  State<PlexInputWidget> createState() => _PlexInputWidgetState<T>();
}

class _PlexInputWidgetState<T> extends State<PlexInputWidget> {
  PlexWidgetController<T?>? _dropdownSelectionController;
  PlexWidgetController<List<T>?>? _multiSelectionController;

  PlexWidgetController<T?> getDropDownController() {
    _dropdownSelectionController ??= (widget.dropdownSelectionController ?? PlexWidgetController<T?>()) as PlexWidgetController<T?>;
    return _dropdownSelectionController!;
  }

  PlexWidgetController<List<T>?> getMultiselectController() {
    if (_multiSelectionController == null || _multiSelectionController!.isDisposed) {
      _multiSelectionController = (widget.multiSelectionController ?? PlexWidgetController<List<T>?>()) as PlexWidgetController<List<T>?>;
      _multiSelectionController!.setValue(widget.multiInitialSelection?.cast<T>());
    }
    return _multiSelectionController!;
  }

  @override
  Widget build(BuildContext context) {
    Widget inputWidget = Container();
    if (widget.type == PlexInputWidgetType.typeInput) {
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
        focusNode: widget?.inputFocusNode,
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
    } else if (widget.type == PlexInputWidgetType.typeButton) {
      inputWidget = widget.buttonIcon == null
          ? ElevatedButton(
              style: widget.buttonStyle ??
                  ButtonStyle(
                    elevation: WidgetStateProperty.resolveWith(
                      (states) {
                        return states.contains(WidgetState.disabled) ? 0 : PlexDim.small;
                      },
                    ),
                  ),
              onPressed: widget.buttonEnabled ? () => widget.buttonClick?.call() : null,
              child: Text(widget.title ?? ""),
            )
          : ElevatedButton.icon(
              style: widget.buttonStyle ??
                  ButtonStyle(
                    elevation: WidgetStateProperty.resolveWith(
                      (states) {
                        return states.contains(WidgetState.disabled) ? 0 : PlexDim.small;
                      },
                    ),
                  ),
              onPressed: widget.buttonEnabled ? () => widget.buttonClick?.call() : null,
              icon: widget.isIconButton() ? null : widget.buttonIcon!,
              label: widget.title != null  ? Text(widget.title ?? "") : widget.buttonIcon!,
            );
    } else if (widget.type == PlexInputWidgetType.typeDropdown) {
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
            focusNode: widget.inputFocusNode ?? FocusNode(),
            initialSelected: getDropDownController().data,
            itemText: (c) => widget.dropdownItemAsString!(c),
            onSelect: (c) {
              getDropDownController().setValue(c as T?);
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
              borderRadius: BorderRadius.circular(PlexDim.smallest)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PlexDim.small, vertical: PlexDim.medium),
            child: Row(
              children: [
                Expanded(
                  child: PlexWidget<T?>(
                    controller: getDropDownController(),
                    createWidget: (context, data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...{
                            Text("${widget.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: PlexDim.small)),
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
    } else if ([PlexInputWidgetType.typeDate, PlexInputWidgetType.typeDateTime, PlexInputWidgetType.typeTime].contains(widget.type)) {
      inputWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(PlexDim.smallest),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PlexDim.small, vertical: PlexDim.smallest),
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
                        if (widget.type == PlexInputWidgetType.typeDate) {
                          showDatePicker(
                            context: context,
                            initialDate: getDropDownController().data as DateTime? ?? DateTime.now(),
                            firstDate: DateTime(1970, 1, 1),
                            lastDate: DateTime(5000, 12, 31),
                            useRootNavigator: true,
                          ).then((value) {
                            if (value != null) {
                              getDropDownController().setValue(value as T?);
                              widget.dropdownItemOnSelect?.call(value);
                            }
                          });
                        } else if (widget.type == PlexInputWidgetType.typeTime) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(getDropDownController().data as DateTime? ?? DateTime.now()),
                            useRootNavigator: true,
                          ).then((value) {
                            if (value != null) {
                              DateTime dateTime = getDropDownController().data as DateTime? ?? DateTime.now();
                              dateTime = DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                value.hour,
                                value.minute,
                              );
                              getDropDownController().setValue(dateTime as T?);
                              widget.dropdownItemOnSelect?.call(value);
                            }
                          });
                        } else if (widget.type == PlexInputWidgetType.typeDateTime) {
                          showDatePicker(
                            context: context,
                            initialDate: getDropDownController().data as DateTime? ?? DateTime.now(),
                            firstDate: DateTime(1970, 1, 1),
                            lastDate: DateTime(5000, 12, 31),
                            useRootNavigator: true,
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(selectedDate),
                                useRootNavigator: true,
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                if (value != null) {
                                  var dateTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    value.hour,
                                    value.minute,
                                  );
                                  getDropDownController().setValue(dateTime as T?);
                                  widget.dropdownItemOnSelect?.call(value);
                                }
                              });
                            }
                          });
                        }
                      },
                      enabled: widget.editable,
                      controller: TextEditingController(
                        text: widget.type == PlexInputWidgetType.typeDate
                            ? (data as DateTime?)?.toDateString()
                            : widget.type == PlexInputWidgetType.typeTime
                                ? (data as DateTime?)?.toTimeString()
                                : widget.type == PlexInputWidgetType.typeDateTime
                                    ? (data as DateTime?)?.toDateTimeString()
                                    : "N/A",
                      ),
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
    } else if (widget.type == PlexInputWidgetType.typeMultiSelect) {
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
            initialSelection: getMultiselectController().data,
            focusNode: widget.inputFocusNode ?? FocusNode(),
            itemText: (c) => widget.dropdownItemAsString!(c),
            onSelect: (c) {
              getMultiselectController().setValue(c.cast<T>());
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
              borderRadius: BorderRadius.circular(PlexDim.smallest)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PlexDim.small, vertical: PlexDim.medium),
            child: Row(
              children: [
                Expanded(
                  child: PlexWidget<List<T>?>(
                    controller: getMultiselectController(),
                    createWidget: (context, data) {
                      List<T> selectionData = data ?? List<T>.empty();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...{
                            Text("${widget.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: PlexDim.small)),
                          },
                          spaceSmall(),
                          Wrap(
                            spacing: PlexDim.small,
                            runSpacing: PlexDim.small,
                            children: [
                              ...selectionData.map(
                                (e) => widget.customMultiSelectedWidget?.call(e) ?? Chip(
                                  elevation: PlexDim.small,
                                  avatar: Icon(Icons.check_circle, color: Colors.green.shade500),
                                  label: Text(widget.dropdownItemAsString!(e)),
                                ),
                              ),
                            ],
                          ),
                          // Text(data != null ? selectionData.map((e) => widget.dropdownItemAsString!(e)).join(", ") : "N/A"),
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
    } else if (widget.type == PlexInputWidgetType.typeAutoComplete) {
      inputWidget = InkWell(
        onTap: () {
          if (!widget.editable) return;

          if (widget.dropdownCustomOnTap != null) {
            widget.dropdownCustomOnTap?.call();
            return;
          }

          showAutoCompleteSelectionList(
            context,
            asyncItems: widget.autoCompleteItems!,
            leadingIcon: widget.dropDownLeadingIcon,
            itemText: (c) => widget.dropdownItemAsString!(c),
            focusNode: widget.inputFocusNode,
            onSelect: (c) {
              getDropDownController().setValue(c as T?);
              widget.dropdownItemOnSelect?.call(c);
            },
            itemWidget: widget.dropdownItemWidget,
          );
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(PlexDim.smallest)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PlexDim.small, vertical: PlexDim.medium),
            child: Row(
              children: [
                Expanded(
                  child: PlexWidget<T?>(
                    controller: getDropDownController(),
                    createWidget: (context, data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...{
                            Text("${widget.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: PlexDim.small)),
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
