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
    VoidCallback? onOk,
    VoidCallback? onCancel,
    String okLabel = 'OK',
    String cancelLabel = 'Cancel',
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
                          buttonType: PlexButtonType.text,
                          buttonClick: () {
                            Plex.back();
                            if (onCancel != null) onCancel();
                          },
                        ),
                      ),
                    if (actions != null)
                      ...actions.map((action) => Expanded(
                            child: PlexFormFieldButton(
                              properties: PlexFormFieldGeneric.title(action.label),
                              buttonType: PlexButtonType.text,
                              buttonClick: () {
                                Plex.back();
                                action.onPressed?.call();
                              },
                            ),
                          )),
                    if (showOk)
                      Expanded(
                        child: PlexFormFieldButton(
                          properties: PlexFormFieldGeneric.title(okLabel),
                          buttonType: PlexButtonType.elevated,
                          buttonClick: () {
                            Plex.back();
                            if (onOk != null) onOk();
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
  final String label;
  final VoidCallback? onPressed;
  PlexInfoSheetAction({required this.label, this.onPressed});
}
