import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

/// A utility class to show a highly configurable dialog for information, errors, alerts, etc.
class PlexInfoDialog {
  /// Shows a dialog with the given configuration.
  ///
  /// [context]: BuildContext to show the dialog.
  /// [title]: Title of the dialog.
  /// [message]: Main message or content.
  /// [icon]: Optional icon to display.
  /// [type]: Type of dialog (info, error, alert, etc.) for styling.
  /// [actions]: List of custom actions (buttons) with label and callback.
  /// [showOk]: Whether to show the default OK button.
  /// [showCancel]: Whether to show the default Cancel button.
  /// [onOk]: Callback for OK button.
  /// [onCancel]: Callback for Cancel button.
  /// [okLabel]: Label for OK button.
  /// [cancelLabel]: Label for Cancel button.
  /// [isDismissible]: Whether the dialog can be dismissed by tapping outside.
  /// [backgroundColor]: Background color of the dialog.
  /// [barrierColor]: Color of the modal barrier.
  /// [shape]: Shape of the dialog.
  /// [constraints]: BoxConstraints for the dialog body.
  /// [useSafeArea]: Whether to use SafeArea.
  /// [elevation]: Elevation of the dialog surface.
  /// [customContent]: Optional custom widget placed between message and actions.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    Widget? icon,
    PlexInfoDialogType type = PlexInfoDialogType.info,
    List<PlexInfoDialogAction>? actions,
    bool showOk = true,
    bool showCancel = false,
    VoidCallback? onOk,
    VoidCallback? onCancel,
    String okLabel = 'OK',
    String cancelLabel = 'Cancel',
    PlexButtonType okButtonType = PlexButtonType.elevated,
    PlexButtonType cancelButtonType = PlexButtonType.text,
    bool isDismissible = true,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? shape,
    BoxConstraints? constraints,
    bool useSafeArea = true,
    double elevation = PlexDim.small,
    EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    Widget? customContent,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      builder: (context) {
        return Dialog(
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: shape,
          insetPadding: insetPadding,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: ConstrainedBox(
              constraints: constraints ?? const BoxConstraints(),
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
                                  buttonType: action.actionType,
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
                              buttonType: okButtonType,
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
            ),
          ),
        );
      },
    );
  }
}

/// Types of info dialog for styling (can be extended for custom themes)
enum PlexInfoDialogType { info, error, alert }

/// Action button for the info dialog
class PlexInfoDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final PlexButtonType actionType;

  PlexInfoDialogAction({required this.label, this.onPressed, this.actionType = PlexButtonType.text});
}
