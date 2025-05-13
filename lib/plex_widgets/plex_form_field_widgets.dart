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
    this.margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small),
  });

  const PlexFormFieldGeneric.empty()
      : title = null,
        helperText = null,
        enabled = true,
        useMargin = true,
        cornerRadius = PlexDim.small,
        margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small);

  const PlexFormFieldGeneric.title(this.title)
      : helperText = null,
        enabled = true,
        useMargin = true,
        cornerRadius = PlexDim.small,
        margin = const EdgeInsets.symmetric(horizontal: PlexDim.medium, vertical: PlexDim.small);
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
            decoration: InputDecoration(
              border: OutlineInputBorder(gapPadding: PlexDim.smallest, borderRadius: BorderRadius.all(Radius.circular(properties.cornerRadius.toDouble()))),
              hintText: inputHint,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              labelText: properties.title ?? "",
              helperText: properties.helperText,
              errorText: errorController?.data?.toString(),
              filled: true,
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
    _selectionController ??= (selectionController ?? PlexWidgetController<DateTime?>());
    return _selectionController!;
  }

  @override
  Widget build(BuildContext context) {
    Widget inputWidget = Container(
      decoration: BoxDecoration(
        color: PlexTheme.getActiveTheme(context).splashColor,
        border: Border.all(color: errorController?.data != null ? PlexTheme.inputErrorColor : Theme.of(context).colorScheme.outline, width: 1),
        borderRadius: BorderRadius.circular(properties.cornerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PlexDim.small, vertical: PlexDim.smallest),
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
                          initialTime: TimeOfDay.fromDateTime(getController().data ?? DateTime.now()),
                          useRootNavigator: true,
                        ).then((value) {
                          if (value != null) {
                            DateTime dateTime = getController().data ?? DateTime.now();
                            dateTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              value.hour,
                              value.minute,
                            );
                            if (minDatetime != null && dateTime.isBefore(minDatetime!)) {
                              context.showMessageError("Invalid Time Selection");
                              return;
                            }
                            if (maxDatetime != null && dateTime.isAfter(maxDatetime!)) {
                              context.showMessageError("Invalid Time Selection");
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
                                if (minDatetime != null && dateTime.isBefore(minDatetime!)) {
                                  context.showMessageError("Invalid Time Selection");
                                  return;
                                }
                                if (maxDatetime != null && dateTime.isAfter(maxDatetime!)) {
                                  context.showMessageError("Invalid Time Selection");
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
                      prefixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.grey),
                      labelText: properties.title ?? "",
                      helperText: properties.helperText,
                      errorText: errorController?.data?.toString(),
                      filled: false,
                    ),
                  );
                },
              ),
            ),
            if(cancellable) ...{
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.grey,
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
                  padding: EdgeInsets.only(left: PlexDim.medium, right: PlexDim.medium, top: PlexDim.small),
                  child: Text(errorController!.data!.toString(), textAlign: TextAlign.left, style: TextStyle(color: PlexTheme.inputErrorColor)),
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

  String Function(dynamic item)? dropdownItemAsString = (item) => item.toString();
  PlexWidgetController<T?>? _dropdownSelectionController;

  PlexWidgetController<T?> getDropDownController() {
    _dropdownSelectionController ??= (dropdownSelectionController ?? PlexWidgetController<T?>());
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
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(properties.cornerRadius)),
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
                        Text(data != null ? dropdownItemAsString?.call(data) ?? data.toString() : noDataText),
                      ],
                    );
                  },
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
              if (showClearButton) ...{
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
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
    if (_multiSelectionController == null || _multiSelectionController!.isDisposed) {
      _multiSelectionController = (multiSelectionController ?? PlexWidgetController<List<T>?>());
      _multiSelectionController!.setValue(multiInitialSelection?.cast<T>());
    }
    return _multiSelectionController!;
  }

  String getItemAsString(T item) => dropdownItemAsString?.call(item) ?? item.toString();

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
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(properties.cornerRadius)),
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
    _dropdownSelectionController ??= (dropdownSelectionController ?? PlexWidgetController<T?>());
    return _dropdownSelectionController!;
  }

  @override
  Widget build(BuildContext context) {
    var inputWidget = InkWell(
      onTap: () => onFieldTap(context),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(properties.cornerRadius)),
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
                        if (properties.title != null) ...{
                          Text("${properties.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: PlexDim.small)),
                        },
                        Text(data != null ? dropdownItemAsString?.call(data) ?? data.toString() : noDataText),
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

class PlexFormFieldButton extends StatelessWidget {
  /// Creates a unified button widget.
  ///
  /// The [properties] parameter provides basic configuration like title, margins, etc.
  /// The [buttonType] parameter determines which style of button to render.
  const PlexFormFieldButton({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.buttonType = PlexButtonType.elevated,
    this.focusNode,
    this.buttonIcon,
    this.buttonClick,
    this.buttonStyle,
  });

  /// Basic properties for the button
  final PlexFormFieldGeneric properties;

  /// Type of button to display (elevated, text, outlined, filled, filledTonal)
  final PlexButtonType buttonType;

  /// Optional focus node for the button
  final FocusNode? focusNode;

  /// Optional icon to display within the button
  final Widget? buttonIcon;

  /// Callback function when the button is clicked
  final Function()? buttonClick;

  /// Optional custom style for the button
  final ButtonStyle? buttonStyle;

  /// Determines if this is an icon-only button
  bool isIconButton() {
    return buttonIcon != null && properties.title == null;
  }

  @override
  Widget build(BuildContext context) {
    // Default style with elevation
    final defaultStyle = ButtonStyle(
      elevation: WidgetStateProperty.resolveWith(
            (states) {
          return states.contains(WidgetState.disabled) ? 0 : PlexDim.small;
        },
      ),
    );

    // Create the appropriate button based on buttonType
    Widget buttonWidget;

    // Using a function to create the button when it has only text (no icon)
    Widget createTextOnlyButton() {
      switch (buttonType) {
        case PlexButtonType.elevated:
          return ElevatedButton(
            focusNode: focusNode,
            style: buttonStyle ?? defaultStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            child: Text(properties.title ?? ""),
          );
        case PlexButtonType.text:
          return TextButton(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            child: Text(properties.title ?? ""),
          );
        case PlexButtonType.outlined:
          return OutlinedButton(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            child: Text(properties.title ?? ""),
          );
        case PlexButtonType.filled:
          return FilledButton(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            child: Text(properties.title ?? ""),
          );
        case PlexButtonType.filledTonal:
          return FilledButton.tonal(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            child: Text(properties.title ?? ""),
          );
      }
    }

    // Using a function to create the button when it has an icon
    Widget createIconButton() {
      switch (buttonType) {
        case PlexButtonType.elevated:
          return ElevatedButton.icon(
            focusNode: focusNode,
            style: buttonStyle ?? defaultStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            icon: isIconButton() ? null : buttonIcon!,
            label: properties.title != null ? Text(properties.title ?? "") : buttonIcon!,
          );
        case PlexButtonType.text:
          return TextButton.icon(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            icon: isIconButton() ? null : buttonIcon!,
            label: properties.title != null ? Text(properties.title ?? "") : buttonIcon!,
          );
        case PlexButtonType.outlined:
          return OutlinedButton.icon(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            icon: isIconButton() ? null : buttonIcon!,
            label: properties.title != null ? Text(properties.title ?? "") : buttonIcon!,
          );
        case PlexButtonType.filled:
          return FilledButton.icon(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            icon: isIconButton() ? null : buttonIcon!,
            label: properties.title != null ? Text(properties.title ?? "") : buttonIcon!,
          );
        case PlexButtonType.filledTonal:
          return FilledButton.tonalIcon(
            focusNode: focusNode,
            style: buttonStyle,
            onPressed: properties.enabled ? () => buttonClick?.call() : null,
            icon: isIconButton() ? null : buttonIcon!,
            label: properties.title != null ? Text(properties.title ?? "") : buttonIcon!,
          );
      }
    }

    // Decide if we're creating a button with or without an icon
    if (buttonIcon == null) {
      buttonWidget = createTextOnlyButton();
    } else {
      buttonWidget = createIconButton();
    }

    // Apply margin if needed
    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
