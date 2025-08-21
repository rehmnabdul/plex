import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

/// A utility class to show a highly configurable bottom sheet for information, errors, alerts, etc.
class PlexInfoSheet {
  /// Shows a bottom sheet with the given configuration.
  ///
  /// [context]: BuildContext to show the bottom sheet.
  /// [title]: Title of the sheet.
  /// [message]: Main message or content.
  /// [icon]: Optional icon to display.
  /// [type]: Type of sheet (info, error, alert, etc.) for styling.
  /// [actions]: List of custom actions (buttons) with label and callback.
  /// [showOk]: Whether to show the default OK button.
  /// [showCancel]: Whether to show the default Cancel button.
  /// [onOk]: Callback for OK button.
  /// [onCancel]: Callback for Cancel button.
  /// [okLabel]: Label for OK button.
  /// [cancelLabel]: Label for Cancel button.
  /// [isDismissible]: Whether the sheet can be dismissed by tapping outside.
  /// [enableDrag]: Whether the sheet can be dragged down to dismiss.
  /// [backgroundColor]: Background color of the sheet.
  /// [barrierColor]: Color of the modal barrier.
  /// [shape]: Shape of the sheet.
  /// [constraints]: BoxConstraints for the sheet.
  /// [useSafeArea]: Whether to use SafeArea.
  /// [isScrollControlled]: Whether the sheet is scroll controlled.
  /// [showDragHandle]: Whether to show a drag handle.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    Widget? icon,
    PlexInfoSheetType type = PlexInfoSheetType.info,
    List<PlexInfoSheetAction>? actions,
    bool showOk = true,
    bool showCancel = false,
    OnActionPressed? onOk,
    OnActionPressed? onCancel,
    String okLabel = 'OK',
    String cancelLabel = 'Cancel',
    PlexButtonType okButtonType = PlexButtonType.elevated,
    PlexButtonType cancelButtonType = PlexButtonType.text,
    Widget? okButtonIcon,
    Key? okButtonKey,
    ButtonStyle? okButtonStyle,
    FocusNode? okButtonFocusNode,
    Widget? cancelButtonIcon,
    Key? cancelButtonKey,
    ButtonStyle? cancelButtonStyle,
    FocusNode? cancelButtonFocusNode,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? shape,
    BoxConstraints? constraints,
    bool useSafeArea = true,
    bool isScrollControlled = true,
    bool showDragHandle = true,
    double elevation = PlexDim.small,
    Widget? customContent,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      shape: shape,
      constraints: constraints,
      useSafeArea: useSafeArea,
      isScrollControlled: isScrollControlled,
      showDragHandle: showDragHandle,
      elevation: elevation,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (icon != null)
                    Padding(
                      padding: EdgeInsets.all(PlexDim.small),
                      child: Center(child: icon),
                    ),
                  if (title != null)
                    Padding(
                      padding: EdgeInsets.all(PlexDim.small),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (message != null)
                    Padding(
                      padding: EdgeInsets.all(PlexDim.small),
                      child: Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (customContent != null) customContent,
                ],
              ),
              Padding(
                padding: EdgeInsets.all(PlexDim.small),
                child: Row(
                  children: [
                    if (showCancel)
                      Expanded(
                        child: PlexFormFieldButton(
                          properties: PlexFormFieldGeneric.title(cancelLabel),
                          buttonType: cancelButtonType,
                          buttonIcon: cancelButtonIcon,
                          key: cancelButtonKey,
                          buttonStyle: cancelButtonStyle,
                          focusNode: cancelButtonFocusNode,
                          buttonClick: () async {
                            if (onCancel == null) Plex.back();
                            if (await onCancel?.call() == true) Plex.back();
                          },
                        ),
                      ),
                    if (actions != null)
                      ...actions.map((action) => Expanded(
                            child: PlexFormFieldButton(
                              properties: PlexFormFieldGeneric.title(action.label),
                              buttonType: action.actionType,
                              buttonIcon: action.icon,
                              buttonStyle: action.buttonStyle,
                              focusNode: action.focusNode,
                              key: action.key,
                              buttonClick: () async {
                                if (action.onPressed == null) Plex.back();
                                if (await action.onPressed!.call() == true) Plex.back();
                              },
                            ),
                          )),
                    if (showOk)
                      Expanded(
                        child: PlexFormFieldButton(
                          properties: PlexFormFieldGeneric.title(okLabel),
                          buttonType: okButtonType,
                          buttonIcon: okButtonIcon,
                          key: okButtonKey,
                          buttonStyle: okButtonStyle,
                          focusNode: okButtonFocusNode,
                          buttonClick: () async {
                            if (onOk == null) Plex.back();
                            if (await onOk?.call() == true) Plex.back();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Types of info sheet for styling (can be extended for custom themes)
enum PlexInfoSheetType { info, error, alert }

/// Action button for the info sheet
class PlexInfoSheetAction {
  final Key? key;

  final String label;

  ///Return True To Close The Sheet Automatically else return false
  final OnActionPressed? onPressed;
  final PlexButtonType actionType;
  final Widget? icon;
  final ButtonStyle? buttonStyle;
  final FocusNode? focusNode;

  PlexInfoSheetAction({
    this.key,
    required this.label,
    this.onPressed,
    this.actionType = PlexButtonType.text,
    this.icon,
    this.buttonStyle,
    this.focusNode,
  });
}

typedef OnActionPressed = Future<bool> Function();
