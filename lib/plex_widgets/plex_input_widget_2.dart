// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_date_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_selection_list.dart';

enum PlexInputWidgetType2 {
  typeInput,
  typeDropdown,
  typeDate,
  typeTime,
  typeDateTime,
  typeMultiSelect,
  typeAutoComplete,
  typeButton,
}

enum PlexFormFieldType {
  typeDate,
  typeTime,
  typeDateTime,
}

class PlexFormFieldGeneric {
  final String? title;
  final bool editable;
  final String? helperText;
  final bool useMargin;
  final EdgeInsets margin;

  const PlexFormFieldGeneric({
    this.title,
    this.editable = true,
    this.helperText,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
  });

  const PlexFormFieldGeneric.empty()
      : title = null,
        helperText = null,
        editable = true,
        useMargin = true,
        margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small);

  const PlexFormFieldGeneric.title(this.title)
      : helperText = null,
        editable = true,
        useMargin = true,
        margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small);
}

class PlexFormFieldInput extends StatelessWidget {
  const PlexFormFieldInput({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.inputHint,
    this.inputController,
    this.inputKeyboardType = TextInputType.name,
    this.isPassword = false,
    this.inputAction,
    this.inputOnSubmit,
    this.inputOnChange,
    this.inputFocusNode,
    this.prefixIcon,
    this.suffixIcon,
  });

  final PlexFormFieldGeneric properties;
  final String? inputHint;
  final TextEditingController? inputController;
  final TextInputType inputKeyboardType;
  final bool isPassword;
  final TextInputAction? inputAction;
  final Function(String value)? inputOnSubmit;
  final Function(String value)? inputOnChange;
  final FocusNode? inputFocusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    var inputWidget = TextField(
      enabled: properties.editable,
      controller: inputController,
      keyboardType: inputKeyboardType,
      textInputAction: inputAction ?? TextInputAction.next,
      onSubmitted: (c) {
        inputOnSubmit?.call(c.toString());
      },
      onChanged: (c) {
        inputOnChange?.call(c.toString());
      },
      focusNode: inputFocusNode,
      obscureText: isPassword,
      decoration: InputDecoration(
        // border: InputBorder.none,
        border: const OutlineInputBorder(),
        hintText: inputHint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: properties.title ?? "",
        helperText: properties.helperText,
        filled: true,
      ),
    );

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: inputWidget,
      );
    }
    return inputWidget;
  }
}

class PlexFormFieldDropdown<T> extends StatelessWidget {
  PlexFormFieldDropdown({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.dropdownItems,
    this.dropDownLeadingIcon,
    this.dropdownAsyncItems,
    this.dropdownItemWidget,
    this.dropdownOnSearch,
    this.dropdownItemAsString,
    this.dropdownItemOnSelect,
    this.dropdownSelectionController,
    this.dropdownCustomOnTap,
    this.inputFocusNode,
  });

  final PlexFormFieldGeneric properties;
  final List<T>? dropdownItems;
  final Widget Function(dynamic item)? dropDownLeadingIcon;
  final Future<List<dynamic>>? dropdownAsyncItems;
  final Widget Function(dynamic item)? dropdownItemWidget;
  final bool Function(String query, dynamic item)? dropdownOnSearch;
  final Function(dynamic item)? dropdownItemOnSelect;
  final Function? dropdownCustomOnTap;
  final PlexWidgetController<T?>? dropdownSelectionController;
  final FocusNode? inputFocusNode;

  String Function(dynamic item)? dropdownItemAsString = (item) => item.toString();
  PlexWidgetController<T?>? _dropdownSelectionController;

  PlexWidgetController<T?> getDropDownController() {
    _dropdownSelectionController ??= (dropdownSelectionController ?? PlexWidgetController<T?>()) as PlexWidgetController<T?>;
    return _dropdownSelectionController!;
  }

  @override
  Widget build(BuildContext context) {
    var inputWidget = InkWell(
      onTap: () {
        if (!properties.editable) return;

        if (dropdownCustomOnTap != null) {
          dropdownCustomOnTap?.call();
          return;
        }

        showSelectionList(
          context,
          items: dropdownItems,
          asyncItems: dropdownAsyncItems,
          leadingIcon: dropDownLeadingIcon,
          focusNode: inputFocusNode ?? FocusNode(),
          initialSelected: getDropDownController().data,
          itemText: (c) => dropdownItemAsString?.call(c) ?? c.toString(),
          onSelect: (c) {
            getDropDownController().setValue(c as T?);
            dropdownItemOnSelect?.call(c);
          },
          onSearch: dropdownOnSearch,
          itemWidget: dropdownItemWidget,
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
          padding: const EdgeInsets.symmetric(horizontal: PlexDim.small, vertical: PlexDim.small),
          child: Row(
            children: [
              Expanded(
                child: PlexWidget<T?>(
                  controller: getDropDownController(),
                  createWidget: (context, data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (properties.title != null) ...{
                          Text("${properties.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: PlexDim.small)),
                        },
                        Text(data != null ? dropdownItemAsString?.call(data) ?? data.toString() : "N/A"),
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

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: inputWidget,
      );
    }
    return inputWidget;
  }
}

class PlexFormFieldDate extends StatelessWidget {
  PlexFormFieldDate({
    super.key,
    required this.type,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.dropdownSelectionController,
    this.dropdownItemOnSelect,
  });

  final PlexFormFieldGeneric properties;
  final PlexFormFieldType type;
  final PlexWidgetController<DateTime?>? dropdownSelectionController;
  final Function(dynamic item)? dropdownItemOnSelect;
  PlexWidgetController<DateTime?>? _dropdownSelectionController;

  PlexWidgetController<DateTime?> getDropDownController() {
    _dropdownSelectionController ??= (dropdownSelectionController ?? PlexWidgetController<DateTime?>()) as PlexWidgetController<DateTime?>;
    return _dropdownSelectionController!;
  }

  @override
  Widget build(BuildContext context) {
    var inputWidget = Container(
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
              child: PlexWidget<DateTime?>(
                controller: getDropDownController(),
                createWidget: (context, data) {
                  return TextField(
                    readOnly: true,
                    showCursor: false,
                    onTap: () {
                      if (!properties.editable) return;
                      if (properties.editable == false) return;
                      if (type == PlexFormFieldType.typeDate) {
                        showDatePicker(
                          context: context,
                          initialDate: getDropDownController().data as DateTime? ?? DateTime.now(),
                          firstDate: DateTime(1970, 1, 1),
                          lastDate: DateTime(5000, 12, 31),
                          useRootNavigator: true,
                        ).then((value) {
                          if (value != null) {
                            getDropDownController().setValue(value as DateTime?);
                            dropdownItemOnSelect?.call(value);
                          }
                        });
                      } else if (type == PlexFormFieldType.typeTime) {
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
                            getDropDownController().setValue(dateTime as DateTime?);
                            dropdownItemOnSelect?.call(value);
                          }
                        });
                      } else if (type == PlexFormFieldType.typeDateTime) {
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
                                getDropDownController().setValue(dateTime as DateTime?);
                                dropdownItemOnSelect?.call(value);
                              }
                            });
                          }
                        });
                      }
                    },
                    enabled: properties.editable,
                    controller: TextEditingController(
                      text: type == PlexFormFieldType.typeDate
                          ? (data as DateTime?)?.toDateString()
                          : type == PlexFormFieldType.typeTime
                              ? (data as DateTime?)?.toTimeString()
                              : type == PlexFormFieldType.typeDateTime
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

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: inputWidget,
      );
    }
    return inputWidget;
  }
}

class PlexFormFieldMultiSelect<T> extends StatelessWidget {
  PlexFormFieldMultiSelect({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.dropdownItemOnSelect,
    this.inputFocusNode,
    this.dropdownAsyncItems,
    this.customMultiSelectedWidget,
    this.dropdownItemAsString,
    this.multiSelectionController,
    this.dropdownCustomOnTap,
    this.dropdownItems,
    this.dropDownLeadingIcon,
    this.dropdownOnSearch,
    this.dropdownItemWidget,
    this.multiInitialSelection,
  });

  final PlexFormFieldGeneric properties;
  final Function? dropdownCustomOnTap;
  final List<T>? dropdownItems;
  final Future<List<dynamic>>? dropdownAsyncItems;
  final Widget Function(dynamic item)? dropDownLeadingIcon;
  final Function(dynamic item)? dropdownItemAsString;
  final Function(dynamic item)? dropdownItemOnSelect;
  final Widget Function(dynamic item)? dropdownItemWidget;
  final bool Function(String query, dynamic item)? dropdownOnSearch;

  final List<T>? multiInitialSelection;
  final PlexWidgetController<List<T>?>? multiSelectionController;
  final FocusNode? inputFocusNode;
  final Widget Function(dynamic)? customMultiSelectedWidget;
  PlexWidgetController<List<T>?>? _multiSelectionController;

  PlexWidgetController<List<T>?> getMultiselectController() {
    if (_multiSelectionController == null || _multiSelectionController!.isDisposed) {
      _multiSelectionController = (multiSelectionController ?? PlexWidgetController<List<T>?>()) as PlexWidgetController<List<T>?>;
      _multiSelectionController!.setValue(multiInitialSelection?.cast<T>());
    }
    return _multiSelectionController!;
  }

  String getItemAsString(T item) => dropdownItemAsString?.call(item) ?? item.toString();

  @override
  Widget build(BuildContext context) {
    var inputWidget = InkWell(
      onTap: () {
        if (!properties.editable) return;

        if (dropdownCustomOnTap != null) {
          dropdownCustomOnTap?.call();
          return;
        }

        showMultiSelection(
          context,
          items: dropdownItems,
          asyncItems: dropdownAsyncItems,
          leadingIcon: dropDownLeadingIcon,
          initialSelection: getMultiselectController().data,
          focusNode: inputFocusNode ?? FocusNode(),
          itemText: (c) => getItemAsString(c),
          onSelect: (c) {
            getMultiselectController().setValue(c.cast<T>());
            dropdownItemOnSelect?.call(c);
          },
          onSearch: dropdownOnSearch,
          itemWidget: dropdownItemWidget,
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
                        if (properties.title != null) ...{
                          Text("${properties.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: PlexDim.small)),
                        },
                        spaceSmall(),
                        Wrap(
                          spacing: PlexDim.small,
                          runSpacing: PlexDim.small,
                          children: [
                            ...selectionData.map(
                              (e) =>
                                  customMultiSelectedWidget?.call(e) ??
                                  Chip(
                                    elevation: PlexDim.small,
                                    avatar: Icon(Icons.check_circle, color: Colors.green.shade500),
                                    label: Text(getItemAsString(e)),
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

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: inputWidget,
      );
    }
    return inputWidget;
  }
}

class PlexFormFieldAutoComplete<T> extends StatelessWidget {

  PlexFormFieldDropdown({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.dropdownItems,
    this.dropDownLeadingIcon,
    this.dropdownAsyncItems,
    this.dropdownItemWidget,
    this.dropdownOnSearch,
    this.dropdownItemAsString,
    this.dropdownItemOnSelect,
    this.dropdownSelectionController,
    this.dropdownCustomOnTap,
    this.inputFocusNode,
  });

  final PlexFormFieldGeneric properties;


  @override
  Widget build(BuildContext context) {
    var inputWidget = InkWell(
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

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: inputWidget,
      );
    }
    return inputWidget;
  }
}









// ignore: must_be_immutable
class PlexInputWidget2<T> extends StatefulWidget {
  PlexInputWidget2.input({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    this.inputHint,
    this.inputController,
    this.inputKeyboardType = TextInputType.name,
    this.isPassword = false,
    this.inputAction,
    this.inputOnChange,
    this.inputOnSubmit,
    this.inputFocusNode,
  }) {
    this.type = PlexInputWidgetType2.typeInput;
  }

  PlexInputWidget2.dropdown({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    this.dropdownItems,
    this.dropDownLeadingIcon,
    this.dropdownAsyncItems,
    this.dropdownItemWidget,
    this.dropdownOnSearch,
    this.dropdownItemAsString,
    this.dropdownItemOnSelect,
    this.dropdownSelectionController,
  }) {
    this.type = PlexInputWidgetType2.typeDropdown;
  }

  PlexInputWidget2.date({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    Function(dynamic item)? itemOnSelect,
    PlexWidgetController<T?>? selectionController,
  }) {
    this.type = PlexInputWidgetType2.typeDate;
    this.dropdownItemOnSelect = itemOnSelect;
    this.dropdownSelectionController = selectionController;
  }

  PlexInputWidget2.time({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    Function(dynamic item)? itemOnSelect,
    PlexWidgetController<T?>? selectionController,
  }) {
    this.type = PlexInputWidgetType2.typeTime;
    this.dropdownItemOnSelect = itemOnSelect;
    this.dropdownSelectionController = selectionController;
  }

  PlexInputWidget2.dateTime({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    Function(dynamic item)? itemOnSelect,
    PlexWidgetController<T?>? selectionController,
  }) {
    this.type = PlexInputWidgetType2.typeDateTime;
    this.dropdownItemOnSelect = itemOnSelect;
    this.dropdownSelectionController = selectionController;
  }

  PlexInputWidget2.multiSelect({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    this.dropdownItemAsString,
    this.dropdownItems,
    this.dropdownAsyncItems,
    this.dropdownOnSearch,
    this.dropdownItemWidget,
    this.dropDownLeadingIcon,
    this.multiInitialSelection,
    this.multiSelectionController,
  }) {
    this.type = PlexInputWidgetType2.typeMultiSelect;
  }

  PlexInputWidget2.autoComplete({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    this.autoCompleteItems,
    this.dropdownItemAsString,
    this.dropdownSelectionController,
    this.dropdownItemOnSelect,
  }) {
    this.type = PlexInputWidgetType2.typeAutoComplete;
  }

  PlexInputWidget2.button({
    super.key,
    this.title,
    this.useMargin = true,
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
    this.editable = true,
    this.helperText,
    this.buttonClick,
    this.buttonEnabled = true,
    this.buttonColor,
    this.buttonIcon,
  }) {
    this.type = PlexInputWidgetType2.typeAutoComplete;
  }

  late final PlexInputWidgetType2 type;

  final String? title;
  final bool useMargin;
  final EdgeInsets margin;
  final bool editable;
  final String? helperText;

  ///Input Field
  String? inputHint;
  TextEditingController? inputController;
  TextInputType inputKeyboardType = TextInputType.name;
  bool isPassword = false;
  TextInputAction? inputAction;
  Function(String value)? inputOnChange;
  Function(String value)? inputOnSubmit;
  FocusNode? inputFocusNode;

  ///Dropdown Field
  List<T>? dropdownItems;
  Widget Function(dynamic item)? dropDownLeadingIcon;
  Future<List<dynamic>>? dropdownAsyncItems;
  Widget Function(dynamic item)? dropdownItemWidget;
  bool Function(String query, dynamic item)? dropdownOnSearch;
  String Function(dynamic item)? dropdownItemAsString;
  Function(dynamic item)? dropdownItemOnSelect;
  Function? dropdownCustomOnTap;
  PlexWidgetController<T?>? dropdownSelectionController;

  ///AutoComplete Field
  Future<List<dynamic>> Function(String query)? autoCompleteItems;

  ///Multiselect Fields
  List<T>? multiInitialSelection;
  PlexWidgetController<List<T>?>? multiSelectionController;

  ///Button Field
  Color? buttonColor;
  Icon? buttonIcon;
  Function()? buttonClick;
  bool buttonEnabled = true;

  @override
  State<PlexInputWidget2> createState() => _PlexInputWidgetState2<T>();
}

class _PlexInputWidgetState2<T> extends State<PlexInputWidget2> {
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
    if (widget.type == PlexInputWidgetType2.typeInput) {
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
        focusNode: widget.inputFocusNode,
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
    } else if (widget.type == PlexInputWidgetType2.typeButton) {
      inputWidget = widget.buttonIcon == null
          ? FilledButton(
              onPressed: widget.buttonEnabled ? () => widget.buttonClick?.call() : null,
              child: Text(widget.title ?? ""),
            )
          : FilledButton.tonalIcon(
              onPressed: widget.buttonEnabled ? () => widget.buttonClick?.call() : null,
              icon: widget.buttonIcon!,
              label: Text(widget.title ?? ""),
            );
    } else if (widget.type == PlexInputWidgetType2.typeDropdown) {
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
            itemText: (c) => widget.dropdownItemAsString?.call(c) ?? c.toString(),
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
                          Text(data != null ? widget.dropdownItemAsString?.call(data) ?? data.toString() : "N/A"),
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
    } else if ([PlexInputWidgetType2.typeDate, PlexInputWidgetType2.typeDateTime, PlexInputWidgetType2.typeTime].contains(widget.type)) {
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
                        if (widget.type == PlexInputWidgetType2.typeDate) {
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
                        } else if (widget.type == PlexInputWidgetType2.typeTime) {
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
                        } else if (widget.type == PlexInputWidgetType2.typeDateTime) {
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
                        text: widget.type == PlexInputWidgetType2.typeDate
                            ? (data as DateTime?)?.toDateString()
                            : widget.type == PlexInputWidgetType2.typeTime
                                ? (data as DateTime?)?.toTimeString()
                                : widget.type == PlexInputWidgetType2.typeDateTime
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
    } else if (widget.type == PlexInputWidgetType2.typeMultiSelect) {
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
            itemText: (c) => widget.dropdownItemAsString?.call(c) ?? c.toString(),
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
                                (e) => Chip(
                                  elevation: PlexDim.small,
                                  avatar: Icon(Icons.check_circle, color: Colors.green.shade500),
                                  label: Text(widget.dropdownItemAsString?.call(e) ?? e.toString()),
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
    } else if (widget.type == PlexInputWidgetType2.typeAutoComplete) {
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
            itemText: (c) => widget.dropdownItemAsString?.call(c) ?? c.toString(),
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
                          Text(data != null ? widget.dropdownItemAsString?.call(data) ?? data.toString() : "N/A"),
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
