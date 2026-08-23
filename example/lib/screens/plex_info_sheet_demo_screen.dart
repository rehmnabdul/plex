import 'package:flutter/material.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widgets/plex_alert.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_info_sheet.dart';
import 'package:plex_app/screens/example_chrome.dart';

class PlexInfoSheetDemoScreen extends PlexScreen {
  const PlexInfoSheetDemoScreen({super.key}) : super(useScaffold: false);

  @override
  PlexState<PlexInfoSheetDemoScreen> createState() =>
      _PlexInfoSheetDemoScreenState();
}

class _PlexInfoSheetDemoScreenState extends PlexState<PlexInfoSheetDemoScreen> {
  void _showInfoSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Information',
      message: 'This is an informational bottom sheet.',
      icon: const Icon(Icons.info, size: 48),
      type: PlexInfoSheetType.info,
      showOk: true,
      onOk: () async {
        context.showSnackBar('OK pressed');
        return true;
      },
    );
  }

  void _showErrorSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Error',
      message: 'An error has occurred.',
      icon: const Icon(Icons.error, size: 48),
      type: PlexInfoSheetType.error,
      showOk: true,
      okLabel: 'Retry',
      showCancel: true,
      cancelLabel: 'Dismiss',
      onOk: () async {
        context.showSnackBar('Retry pressed');
        return true;
      },
      onCancel: () async {
        context.showSnackBar('Dismiss pressed');
        return true;
      },
    );
  }

  void _showAlertSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Alert',
      message: 'Are you sure you want to proceed?',
      icon: const Icon(Icons.warning, size: 48),
      type: PlexInfoSheetType.alert,
      showOk: true,
      showCancel: true,
      okLabel: 'Yes',
      cancelLabel: 'No',
      onOk: () async {
        context.showSnackBar('Yes pressed');
        return true;
      },
      onCancel: () async {
        context.showSnackBar('No pressed');
        return true;
      },
    );
  }

  void _showCustomButtonsSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Custom Actions',
      message: 'You can add any number of custom buttons.',
      icon: const Icon(Icons.build, size: 48),
      showOk: false,
      showCancel: false,
      actions: [
        PlexInfoSheetAction(
          label: 'Action 1',
          onPressed: () async {
            context.showSnackBar('Action 1 pressed');
            return true;
          },
        ),
        PlexInfoSheetAction(
          label: 'Action 2',
          onPressed: () async {
            context.showSnackBar('Action 2 pressed');
            return true;
          },
        ),
      ],
    );
  }

  void _showCustomContentSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Custom Content',
      message: 'You can provide any custom widget below.',
      icon: const Icon(Icons.widgets, size: 48),
      showOk: true,
      customContent: Padding(
        padding: const EdgeInsets.all(PlexDim.medium),
        child: Column(
          children: [
            const Text('This is a custom widget.'),
            const SizedBox(height: PlexDim.small),
            PlexFormFieldButton(
              properties: const PlexFormFieldGeneric.title('Custom Button'),
              buttonType: PlexButtonType.elevated,
              buttonClick: () => context.showSnackBar('Custom button pressed'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildBody() {
    return ExampleScrollPage(
      children: [
        const PlexAlert(
          variant: PlexAlertVariant.info,
          title: 'Sheets vs alerts',
          message:
              'PlexInfoSheet is a modal. PlexAlert sits inline on the page.',
        ),
        const SizedBox(height: PlexDim.medium),
        ExampleCard(
          title: "PlexInfoSheet",
          subtitle: "Info, error, alert, custom actions and content",
          child: Wrap(
            spacing: PlexDim.small,
            runSpacing: PlexDim.small,
            children: [
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: 'Info sheet',
                  useMargin: false,
                ),
                buttonType: PlexButtonType.filled,
                buttonClick: _showInfoSheet,
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: 'Error sheet',
                  useMargin: false,
                ),
                buttonType: PlexButtonType.danger,
                buttonClick: _showErrorSheet,
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: 'Alert sheet',
                  useMargin: false,
                ),
                buttonType: PlexButtonType.outlined,
                buttonClick: _showAlertSheet,
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: 'Custom buttons',
                  useMargin: false,
                ),
                buttonType: PlexButtonType.outlined,
                buttonClick: _showCustomButtonsSheet,
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: 'Custom content',
                  useMargin: false,
                ),
                buttonType: PlexButtonType.outlined,
                buttonClick: _showCustomContentSheet,
              ),
              PlexFormFieldButton(
                properties: const PlexFormFieldGeneric(
                  title: 'Token toast',
                  useMargin: false,
                ),
                buttonType: PlexButtonType.text,
                buttonClick: () {
                  context.showMessage(
                    'Semantic toast colors from PlexThemeData.',
                    title: 'Toast',
                    type: MessageType.success,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
