// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_date_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_selection_list.dart';

enum PlexFormFieldDateType {
  typeDate,
  typeTime,
  typeDateTime,
}

enum PlexButtonType {
  elevated,
  text,
  outlined,
  filled,
  filledTonal,
  ink,
  danger,
}

/// Visual size for [PlexFormFieldButton]. Defaults to [md] (Material ~40px).
enum PlexButtonSize {
  sm,
  md,
  lg,
}

class PlexFormFieldGeneric {
  final String? title;
  final bool enabled;
  final String? helperText;
  final bool useMargin;
  final EdgeInsets margin;
  final double cornerRadius;

  const PlexFormFieldGeneric({
    this.title,
    this.enabled = true,
    this.helperText,
    this.useMargin = true,
    this.cornerRadius = PlexDim.small,
    this.margin = const EdgeInsets.symmetric(
        horizontal: PlexDim.medium, vertical: PlexDim.small),
  });

  const PlexFormFieldGeneric.empty()
      : title = null,
        helperText = null,
        enabled = true,
        useMargin = true,
        cornerRadius = PlexDim.small,
        margin = const EdgeInsets.symmetric(
            horizontal: PlexDim.medium, vertical: PlexDim.small);

  const PlexFormFieldGeneric.title(this.title)
      : helperText = null,
        enabled = true,
        useMargin = true,
        cornerRadius = PlexDim.small,
        margin = const EdgeInsets.symmetric(
            horizontal: PlexDim.medium, vertical: PlexDim.small);
}

InputDecoration _plexFormInputDecoration(
  BuildContext context, {
  required PlexFormFieldGeneric properties,
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? errorText,
}) {
  final PlexColorTokens colors = PlexThemeData.of(context).colors;
  final BorderRadius radius = BorderRadius.circular(properties.cornerRadius);
  return InputDecoration(
    filled: true,
    fillColor: colors.surfaceSunken,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    labelText: properties.title ?? "",
    helperText: properties.helperText,
    errorText: errorText,
    errorStyle: TextStyle(color: colors.statusDanger),
    border:
        OutlineInputBorder(gapPadding: PlexDim.smallest, borderRadius: radius),
    enabledBorder: OutlineInputBorder(
      gapPadding: PlexDim.smallest,
      borderRadius: radius,
      borderSide: BorderSide(color: colors.borderDefault),
    ),
    focusedBorder: OutlineInputBorder(
      gapPadding: PlexDim.smallest,
      borderRadius: radius,
      borderSide: BorderSide(color: colors.borderFocus, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      gapPadding: PlexDim.smallest,
      borderRadius: radius,
      borderSide: BorderSide(color: colors.statusDanger),
    ),
    focusedErrorBorder: OutlineInputBorder(
      gapPadding: PlexDim.smallest,
      borderRadius: radius,
      borderSide: BorderSide(color: colors.statusDanger, width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      gapPadding: PlexDim.smallest,
      borderRadius: radius,
      borderSide: BorderSide(color: colors.borderSubtle),
    ),
  );
}

BoxDecoration _plexFormSelectDecoration(
  BuildContext context, {
  required PlexFormFieldGeneric properties,
  bool hasError = false,
}) {
  final PlexColorTokens colors = PlexThemeData.of(context).colors;
  return BoxDecoration(
    color: colors.surfaceSunken,
    border: Border.all(
      color: hasError
          ? colors.statusDanger
          : (properties.enabled ? colors.borderDefault : colors.borderSubtle),
    ),
    borderRadius: BorderRadius.circular(properties.cornerRadius),
  );
}

Widget _wrapFormFieldMargin(PlexFormFieldGeneric properties, Widget child) {
  if (properties.useMargin) {
    return Padding(padding: properties.margin, child: child);
  }
  return child;
}

class PlexFormFieldInput extends StatelessWidget {
  const PlexFormFieldInput({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.inputHint,
    this.inputController,
    this.errorController,
    this.inputKeyboardType = TextInputType.name,
    this.isPassword = false,
    this.inputAction,
    this.inputOnSubmit,
    this.inputOnChange,
    this.inputFocusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.maxInputLength,
    this.maxLines,
    this.minLines,
  });

  final PlexFormFieldGeneric properties;
  final String? inputHint;
  final TextEditingController? inputController;
  final PlexWidgetController? errorController;
  final TextInputType inputKeyboardType;
  final bool isPassword;
  final TextInputAction? inputAction;
  final Function(String value)? inputOnSubmit;
  final Function(String value)? inputOnChange;
  final FocusNode? inputFocusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxInputLength;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    var inputWidget = PlexWidget(
        controller: errorController ?? PlexWidgetController(),
        createWidget: (context, data) {
          return TextField(
            enabled: properties.enabled,
            controller: inputController,
            keyboardType: inputKeyboardType,
            textInputAction: inputAction ?? TextInputAction.next,
            onSubmitted: (c) {
              inputOnSubmit?.call(c.toString());
            },
            onChanged: (c) {
              inputOnChange?.call(c.toString());
            },
            maxLines: isPassword ? 1 : maxLines,
            minLines: isPassword ? 1 : minLines,
            maxLength: maxInputLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            focusNode: inputFocusNode,
            obscureText: isPassword,
            decoration: _plexFormInputDecoration(
              context,
              properties: properties,
              hintText: inputHint,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              errorText: errorController?.data?.toString(),
            ),
          );
        });

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
    this.selectionController,
    this.onSelect,
    this.minDatetime,
    this.maxDatetime,
    this.cancellable = true,
    this.errorController,
  });

  final PlexFormFieldGeneric properties;
  final PlexFormFieldDateType type;
  final PlexWidgetController<DateTime?>? selectionController;
  final PlexWidgetController<String?>? errorController;
  final Function(dynamic item)? onSelect;
  final DateTime? minDatetime;
  final DateTime? maxDatetime;
  final bool cancellable;
  PlexWidgetController<DateTime?>? _selectionController;

  PlexWidgetController<DateTime?> getController() {
    _selectionController ??=
        (selectionController ?? PlexWidgetController<DateTime?>());
    return _selectionController!;
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    Widget inputWidget = Container(
      decoration: _plexFormSelectDecoration(
        context,
        properties: properties,
        hasError: errorController?.data != null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: PlexDim.small, vertical: PlexDim.smallest),
        child: Row(
          children: [
            Expanded(
              child: PlexWidget<DateTime?>(
                controller: getController(),
                createWidget: (context, data) {
                  return TextField(
                    readOnly: true,
                    showCursor: false,
                    onTap: () {
                      if (!properties.enabled) return;
                      if (properties.enabled == false) return;
                      if (type == PlexFormFieldDateType.typeDate) {
                        showDatePicker(
                          context: context,
                          initialDate: getController().data ?? DateTime.now(),
                          firstDate: minDatetime ?? DateTime(1970, 1, 1),
                          lastDate: maxDatetime ?? DateTime(5000, 12, 31),
                          useRootNavigator: true,
                        ).then((value) {
                          if (value != null) {
                            getController().setValue(value as DateTime?);
                            onSelect?.call(value);
                          }
                        });
                      } else if (type == PlexFormFieldDateType.typeTime) {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              getController().data ?? DateTime.now()),
                          useRootNavigator: true,
                        ).then((value) {
                          if (value != null) {
                            DateTime dateTime =
                                getController().data ?? DateTime.now();
                            dateTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              value.hour,
                              value.minute,
                            );
                            if (minDatetime != null &&
                                dateTime.isBefore(minDatetime!)) {
                              context
                                  .showMessageError("Invalid Time Selection");
                              return;
                            }
                            if (maxDatetime != null &&
                                dateTime.isAfter(maxDatetime!)) {
                              context
                                  .showMessageError("Invalid Time Selection");
                              return;
                            }
                            getController().setValue(dateTime as DateTime?);
                            onSelect?.call(value);
                          }
                        });
                      } else if (type == PlexFormFieldDateType.typeDateTime) {
                        showDatePicker(
                          context: context,
                          initialDate: getController().data ?? DateTime.now(),
                          firstDate: minDatetime ?? DateTime(1970, 1, 1),
                          lastDate: maxDatetime ?? DateTime(5000, 12, 31),
                          useRootNavigator: true,
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(selectedDate),
                              useRootNavigator: true,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
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
                                if (minDatetime != null &&
                                    dateTime.isBefore(minDatetime!)) {
                                  context.showMessageError(
                                      "Invalid Time Selection");
                                  return;
                                }
                                if (maxDatetime != null &&
                                    dateTime.isAfter(maxDatetime!)) {
                                  context.showMessageError(
                                      "Invalid Time Selection");
                                  return;
                                }
                                getController().setValue(dateTime as DateTime?);
                                onSelect?.call(value);
                              }
                            });
                          }
                        });
                      }
                    },
                    enabled: properties.enabled,
                    controller: TextEditingController(
                      text: type == PlexFormFieldDateType.typeDate
                          ? (data as DateTime?)?.toDateString()
                          : type == PlexFormFieldDateType.typeTime
                              ? (data as DateTime?)?.toTimeString()
                              : type == PlexFormFieldDateType.typeDateTime
                                  ? (data as DateTime?)?.toDateTimeString()
                                  : "N/A",
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.calendar_month_outlined,
                          color: colors.textMuted),
                      labelText: properties.title ?? "",
                      helperText: properties.helperText,
                      errorText: errorController?.data?.toString(),
                      filled: false,
                    ),
                  );
                },
              ),
            ),
            if (cancellable) ...{
              IconButton(
                icon: const Icon(Icons.close),
                color: colors.textMuted,
                onPressed: () {
                  getController().setValue(null);
                },
              ),
              // const Icon(Icons.arrow_drop_down, color: Colors.grey),
            }
          ],
        ),
      ),
    );

    Widget finalWidget;
    if (errorController != null) {
      finalWidget = PlexWidget(
        controller: errorController!,
        createWidget: (context, data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              inputWidget,
              if (errorController!.data != null) ...{
                Padding(
                  padding: EdgeInsets.only(
                      left: PlexDim.medium,
                      right: PlexDim.medium,
                      top: PlexDim.small),
                  child: Text(errorController!.data!.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(color: colors.statusDanger)),
                )
              },
            ],
          );
        },
      );
    } else {
      finalWidget = inputWidget;
    }

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: finalWidget,
      );
    }
    return finalWidget;
  }
}

class PlexFormFieldDropdown<T> extends StatelessWidget {
  PlexFormFieldDropdown(
      {super.key,
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
      this.searchInputFocusNode,
      this.noDataText = "N/A",
      this.initialSelection,
      this.showClearButton = false});

  final PlexFormFieldGeneric properties;
  final List<T>? dropdownItems;
  final Widget Function(dynamic item)? dropDownLeadingIcon;
  final Future<List<dynamic>>? dropdownAsyncItems;
  final Widget Function(dynamic item)? dropdownItemWidget;
  final bool Function(String query, dynamic item)? dropdownOnSearch;
  final Function(dynamic item)? dropdownItemOnSelect;
  final Function? dropdownCustomOnTap;
  final PlexWidgetController<T?>? dropdownSelectionController;
  final FocusNode? searchInputFocusNode;
  final String noDataText;
  final bool showClearButton;
  final T? initialSelection;

  bool _initialized = false;

  String Function(dynamic item)? dropdownItemAsString =
      (item) => item.toString();
  PlexWidgetController<T?>? _dropdownSelectionController;

  PlexWidgetController<T?> getDropDownController() {
    _dropdownSelectionController ??=
        (dropdownSelectionController ?? PlexWidgetController<T?>());
    if (!_initialized && initialSelection != null) {
      _dropdownSelectionController!.setValue(initialSelection);
      _initialized = true;
    }
    return _dropdownSelectionController!;
  }

  @override
  Widget build(BuildContext context) {
    var inputWidget = InkWell(
      onTap: () {
        if (!properties.enabled) return;

        if (dropdownCustomOnTap != null) {
          dropdownCustomOnTap?.call();
          return;
        }

        showPlexSelectionList(
          context,
          items: dropdownItems,
          asyncItems: dropdownAsyncItems,
          leadingIcon: dropDownLeadingIcon,
          focusNode: searchInputFocusNode ?? FocusNode(),
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
      //   ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      child: Container(
        decoration: _plexFormSelectDecoration(context, properties: properties),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: PlexDim.small, vertical: PlexDim.small),
          child: Row(
            children: [
              Expanded(
                child: PlexWidget<T?>(
                  controller: getDropDownController(),
                  createWidget: (context, data) {
                    final PlexColorTokens colors =
                        PlexThemeData.of(context).colors;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (properties.title != null) ...{
                          Text("${properties.title}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: PlexDim.small,
                                  color: colors.textSecondary)),
                        },
                        Text(
                          data != null
                              ? dropdownItemAsString?.call(data) ??
                                  data.toString()
                              : noDataText,
                          style: TextStyle(
                              color: properties.enabled
                                  ? colors.textPrimary
                                  : colors.textDisabled),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Icon(Icons.arrow_drop_down,
                  color: PlexThemeData.of(context).colors.textMuted),
              if (showClearButton) ...{
                IconButton(
                  icon: const Icon(Icons.close),
                  color: PlexThemeData.of(context).colors.textMuted,
                  onPressed: () {
                    getDropDownController().setValue(null);
                  },
                ),
              }
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

class PlexFormFieldMultiSelect<T> extends StatelessWidget {
  PlexFormFieldMultiSelect({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.dropdownItemOnSelect,
    this.searchInputFocusNode,
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
  final FocusNode? searchInputFocusNode;
  final Widget Function(dynamic)? customMultiSelectedWidget;
  PlexWidgetController<List<T>?>? _multiSelectionController;

  PlexWidgetController<List<T>?> getMultiselectController() {
    if (_multiSelectionController == null ||
        _multiSelectionController!.isDisposed) {
      _multiSelectionController =
          (multiSelectionController ?? PlexWidgetController<List<T>?>());
      _multiSelectionController!.setValue(multiInitialSelection?.cast<T>());
    }
    return _multiSelectionController!;
  }

  String getItemAsString(T item) =>
      dropdownItemAsString?.call(item) ?? item.toString();

  @override
  Widget build(BuildContext context) {
    var inputWidget = InkWell(
      onTap: () {
        if (!properties.enabled) return;

        if (dropdownCustomOnTap != null) {
          dropdownCustomOnTap?.call();
          return;
        }

        showPlexMultiSelection(
          context,
          items: dropdownItems,
          asyncItems: dropdownAsyncItems,
          leadingIcon: dropDownLeadingIcon,
          initialSelection: getMultiselectController().data,
          focusNode: searchInputFocusNode ?? FocusNode(),
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
        decoration: _plexFormSelectDecoration(context, properties: properties),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: PlexDim.small, vertical: PlexDim.small),
          child: Row(
            children: [
              Expanded(
                child: PlexWidget<List<T>?>(
                  controller: getMultiselectController(),
                  createWidget: (context, data) {
                    final PlexColorTokens colors =
                        PlexThemeData.of(context).colors;
                    List<T> selectionData = data ?? List<T>.empty();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (properties.title != null) ...{
                          Text("${properties.title}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: PlexDim.small,
                                  color: colors.textSecondary)),
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
                                    elevation: PlexElevation.sm,
                                    avatar: Icon(Icons.check_circle,
                                        color: colors.statusSuccess),
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
              Icon(Icons.arrow_drop_down,
                  color: PlexThemeData.of(context).colors.textMuted),
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
  PlexFormFieldAutoComplete({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.dropDownLeadingIcon,
    this.dropdownItemWidget,
    this.dropdownItemAsString,
    this.dropdownItemOnSelect,
    this.dropdownSelectionController,
    this.dropdownCustomOnTap,
    this.searchInputFocusNode,
    this.autoCompleteItems,
    this.noDataText = "N/A",
    this.showBarCode = false,
    this.inputDelay = 1000,
  });

  final PlexFormFieldGeneric properties;
  final Function? dropdownCustomOnTap;
  final Widget Function(dynamic item)? dropdownItemWidget;
  final Future<List<dynamic>> Function(String query)? autoCompleteItems;
  final Widget Function(dynamic item)? dropDownLeadingIcon;
  final String Function(dynamic item)? dropdownItemAsString;
  final FocusNode? searchInputFocusNode;
  final Function(dynamic item)? dropdownItemOnSelect;
  final PlexWidgetController<T?>? dropdownSelectionController;
  final String noDataText;
  final bool showBarCode;
  final double inputDelay;

  PlexWidgetController<T?>? _dropdownSelectionController;

  PlexWidgetController<T?> getDropDownController() {
    _dropdownSelectionController ??=
        (dropdownSelectionController ?? PlexWidgetController<T?>());
    return _dropdownSelectionController!;
  }

  @override
  Widget build(BuildContext context) {
    var inputWidget = InkWell(
      onTap: () => onFieldTap(context),
      child: Container(
        decoration: _plexFormSelectDecoration(context, properties: properties),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: PlexDim.small, vertical: PlexDim.small),
          child: Row(
            children: [
              Expanded(
                child: PlexWidget<T?>(
                  controller: getDropDownController(),
                  createWidget: (context, data) {
                    final PlexColorTokens colors =
                        PlexThemeData.of(context).colors;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (properties.title != null) ...{
                          Text("${properties.title}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: PlexDim.small,
                                  color: colors.textSecondary)),
                        },
                        Text(
                          data != null
                              ? dropdownItemAsString?.call(data) ??
                                  data.toString()
                              : noDataText,
                          style: TextStyle(
                              color: properties.enabled
                                  ? colors.textPrimary
                                  : colors.textDisabled),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Icon(Icons.arrow_drop_down,
                  color: PlexThemeData.of(context).colors.textMuted),
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

  onFieldTap(BuildContext context) {
    if (!properties.enabled) return;

    if (dropdownCustomOnTap != null) {
      dropdownCustomOnTap?.call();
      return;
    }

    showPlexAutoCompleteSelectionList(
      context,
      asyncItems: autoCompleteItems!,
      leadingIcon: dropDownLeadingIcon,
      itemText: (c) => dropdownItemAsString?.call(c) ?? c.toString(),
      focusNode: searchInputFocusNode,
      showBarCode: showBarCode,
      onSelect: (c) {
        getDropDownController().setValue(c as T?);
        dropdownItemOnSelect?.call(c);
      },
      itemWidget: dropdownItemWidget,
      inputDelay: inputDelay,
    );
  }
}

class PlexFormFieldCheckbox extends StatelessWidget {
  const PlexFormFieldCheckbox({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.value = false,
    this.onChanged,
    this.tristate = false,
  });

  final PlexFormFieldGeneric properties;
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final Widget field = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: tristate ? value : (value ?? false),
          tristate: tristate,
          onChanged: properties.enabled ? onChanged : null,
          checkColor: colors.textInverse,
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected))
              return colors.brandPrimary;
            return colors.surfaceCard;
          }),
          side: BorderSide(color: colors.borderStrong, width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PlexRadius.xs)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: PlexDim.smallMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (properties.title != null) ...{
                  Text(
                    properties.title!,
                    style: TextStyle(
                      color: properties.enabled
                          ? colors.textPrimary
                          : colors.textDisabled,
                    ),
                  ),
                },
                if (properties.helperText != null) ...{
                  Text(
                    properties.helperText!,
                    style: TextStyle(
                        color: colors.textMuted,
                        fontSize: PlexFontSize.caption),
                  ),
                },
              ],
            ),
          ),
        ),
      ],
    );
    return _wrapFormFieldMargin(properties, field);
  }
}

class PlexFormFieldSwitch extends StatelessWidget {
  const PlexFormFieldSwitch({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.value = false,
    this.onChanged,
  });

  final PlexFormFieldGeneric properties;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final Widget field = Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (properties.title != null) ...{
                Text(
                  properties.title!,
                  style: TextStyle(
                    color: properties.enabled
                        ? colors.textPrimary
                        : colors.textDisabled,
                  ),
                ),
              },
              if (properties.helperText != null) ...{
                Text(
                  properties.helperText!,
                  style: TextStyle(
                      color: colors.textMuted, fontSize: PlexFontSize.caption),
                ),
              },
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: properties.enabled ? onChanged : null,
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected))
              return colors.brandPrimary;
            return colors.borderDefault;
          }),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected))
              return colors.textInverse;
            return colors.surfaceCard;
          }),
        ),
      ],
    );
    return _wrapFormFieldMargin(properties, field);
  }
}

class PlexFormFieldButton extends StatelessWidget {
  /// Creates a unified button widget.
  ///
  /// The [properties] parameter provides basic configuration like title, margins, etc.
  /// The [buttonType] parameter determines which style of button to render.
  /// [size], [loading], [expanded], and [buttonTrailingIcon] are additive; defaults
  /// match the previous unlabeled / idle / intrinsic-width behavior.
  const PlexFormFieldButton({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.buttonType = PlexButtonType.elevated,
    this.focusNode,
    this.buttonIcon,
    this.buttonTrailingIcon,
    this.buttonClick,
    this.buttonStyle,
    this.size = PlexButtonSize.md,
    this.loading = false,
    this.expanded = false,
  });

  /// Basic properties for the button
  final PlexFormFieldGeneric properties;

  /// Type of button to display (elevated, text, outlined, filled, filledTonal, ink, danger)
  final PlexButtonType buttonType;

  /// Optional focus node for the button
  final FocusNode? focusNode;

  /// Optional icon to display within the button
  final Widget? buttonIcon;

  /// Optional trailing icon (ignored while [loading]).
  final Widget? buttonTrailingIcon;

  /// Callback function when the button is clicked
  final Function()? buttonClick;

  /// Optional custom style for the button
  final ButtonStyle? buttonStyle;

  /// Visual size. Defaults to [PlexButtonSize.md] (~40px).
  final PlexButtonSize size;

  /// When true, shows a spinner and disables [onPressed].
  final bool loading;

  /// When true, stretches to the maximum incoming width.
  final bool expanded;

  /// Determines if this is an icon-only button
  bool isIconButton() {
    return buttonIcon != null && properties.title == null;
  }

  VoidCallback? _onPressed() {
    if (!properties.enabled || loading) return null;
    return () => buttonClick?.call();
  }

  double _heightFor(PlexButtonSize size) {
    switch (size) {
      case PlexButtonSize.sm:
        return PlexDim.large;
      case PlexButtonSize.md:
        return PlexDim.largePlus;
      case PlexButtonSize.lg:
        return PlexDim.extraLargeMinus;
    }
  }

  double _fontSizeFor(PlexButtonSize size) {
    switch (size) {
      case PlexButtonSize.sm:
        return PlexFontSize.caption;
      case PlexButtonSize.md:
        return PlexFontSize.body;
      case PlexButtonSize.lg:
        return PlexFontSize.large;
    }
  }

  EdgeInsetsGeometry _padding() {
    if (isIconButton()) return EdgeInsets.zero;
    switch (size) {
      case PlexButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: PlexDim.smallMedium);
      case PlexButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 18);
      case PlexButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: PlexDim.largeMinus);
    }
  }

  ButtonStyle _resolveStyle(BuildContext context) {
    final PlexThemeData plex = PlexThemeData.of(context);
    final PlexColorTokens colors = plex.colors;
    final double height = _heightFor(size);

    ButtonStyle style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(
        Size(
          expanded ? double.infinity : (isIconButton() ? height : 0),
          height,
        ),
      ),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(_padding()),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(properties.cornerRadius),
        ),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: _fontSizeFor(size),
          fontFamily: plex.fontFamily,
        ),
      ),
    );

    switch (buttonType) {
      case PlexButtonType.ink:
        style = style.copyWith(
          backgroundColor: WidgetStatePropertyAll<Color>(colors.brandInk),
          foregroundColor: WidgetStatePropertyAll<Color>(colors.textInverse),
        );
        break;
      case PlexButtonType.danger:
        style = style.copyWith(
          backgroundColor: WidgetStatePropertyAll<Color>(colors.statusDanger),
          foregroundColor: WidgetStatePropertyAll<Color>(colors.textInverse),
        );
        break;
      case PlexButtonType.elevated:
        style = style.copyWith(
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            return states.contains(WidgetState.disabled) ? 0 : PlexElevation.sm;
          }),
        );
        break;
      case PlexButtonType.text:
      case PlexButtonType.outlined:
      case PlexButtonType.filled:
      case PlexButtonType.filledTonal:
        break;
    }

    if (buttonStyle != null) {
      style = style.merge(buttonStyle);
    }
    return style;
  }

  Widget _buildChild() {
    final bool iconOnly = isIconButton();
    final List<Widget> parts = <Widget>[];
    if (loading) {
      parts.add(const _PlexButtonSpinner());
    } else if (buttonIcon != null && !iconOnly) {
      parts.add(buttonIcon!);
    }
    if (properties.title != null) {
      parts.add(Text(properties.title!));
    } else if (iconOnly && !loading) {
      parts.add(buttonIcon!);
    }
    if (!loading && buttonTrailingIcon != null) {
      parts.add(buttonTrailingIcon!);
    }
    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }
    if (parts.length == 1) return parts.first;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < parts.length; i++) ...[
          if (i > 0) const SizedBox(width: PlexDim.small),
          parts[i],
        ],
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    final ButtonStyle style = _resolveStyle(context);
    final VoidCallback? onPressed = _onPressed();
    final Widget child = _buildChild();

    switch (buttonType) {
      case PlexButtonType.elevated:
        return ElevatedButton(
          focusNode: focusNode,
          style: style,
          onPressed: onPressed,
          child: child,
        );
      case PlexButtonType.text:
        return TextButton(
          focusNode: focusNode,
          style: style,
          onPressed: onPressed,
          child: child,
        );
      case PlexButtonType.outlined:
        return OutlinedButton(
          focusNode: focusNode,
          style: style,
          onPressed: onPressed,
          child: child,
        );
      case PlexButtonType.filled:
      case PlexButtonType.ink:
      case PlexButtonType.danger:
        return FilledButton(
          focusNode: focusNode,
          style: style,
          onPressed: onPressed,
          child: child,
        );
      case PlexButtonType.filledTonal:
        return FilledButton.tonal(
          focusNode: focusNode,
          style: style,
          onPressed: onPressed,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = _buildButton(context);

    if (expanded) {
      buttonWidget = SizedBox(width: double.infinity, child: buttonWidget);
    }

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}

class _PlexButtonSpinner extends StatelessWidget {
  const _PlexButtonSpinner();

  @override
  Widget build(BuildContext context) {
    final Color? color = DefaultTextStyle.of(context).style.color;
    return SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
