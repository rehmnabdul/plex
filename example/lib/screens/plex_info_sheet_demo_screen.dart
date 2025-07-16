import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_messages.dart';
import 'package:plex/plex_widgets/plex_info_sheet.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

class PlexInfoSheetDemoScreen extends PlexScreen {
  const PlexInfoSheetDemoScreen({super.key});

  @override
  PlexState<PlexInfoSheetDemoScreen> createState() => _PlexInfoSheetDemoScreenState();
}

class _PlexInfoSheetDemoScreenState extends PlexState<PlexInfoSheetDemoScreen> {
  @override
  AppBar? buildAppBar() {
    return AppBar(
      title: const Text('PlexInfoSheet Demo'),
    );
  }

  void _showInfoSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Information',
      message: 'This is an informational bottom sheet.',
      icon: const Icon(Icons.info, color: Colors.blue, size: 48),
      type: PlexInfoSheetType.info,
      showOk: true,
      onOk: () => context.showSnackBar('OK pressed'),
    );
  }

  void _showErrorSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Error',
      message: 'An error has occurred.',
      icon: const Icon(Icons.error, color: Colors.red, size: 48),
      type: PlexInfoSheetType.error,
      showOk: true,
      okLabel: 'Retry',
      showCancel: true,
      cancelLabel: 'Dismiss',
      onOk: () => context.showSnackBar('Retry pressed'),
      onCancel: () => context.showSnackBar('Dismiss pressed'),
    );
  }

  void _showAlertSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Alert',
      message: 'Are you sure you want to proceed?',
      icon: const Icon(Icons.warning, color: Colors.orange, size: 48),
      type: PlexInfoSheetType.alert,
      showOk: true,
      showCancel: true,
      okLabel: 'Yes',
      cancelLabel: 'No',
      onOk: () => context.showSnackBar('Yes pressed'),
      onCancel: () => context.showSnackBar('No pressed'),
    );
  }

  void _showCustomButtonsSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Custom Actions',
      message: 'You can add any number of custom buttons.',
      icon: const Icon(Icons.build, color: Colors.green, size: 48),
      showOk: false,
      showCancel: false,
      actions: [
        PlexInfoSheetAction(
          label: 'Action 1',
          onPressed: () => context.showSnackBar('Action 1 pressed'),
        ),
        PlexInfoSheetAction(
          label: 'Action 2',
          onPressed: () => context.showSnackBar('Action 2 pressed'),
        ),
      ],
    );
  }

  void _showCustomContentSheet() {
    PlexInfoSheet.show(
      context: context,
      title: 'Custom Content',
      message: 'You can provide any custom widget below.',
      icon: const Icon(Icons.widgets, color: Colors.purple, size: 48),
      showOk: true,
      customContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('This is a custom widget.'),
            SizedBox(height: 8),
            PlexFormFieldButton(
              properties: PlexFormFieldGeneric.title('Custom Button'),
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
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PlexFormFieldButton(
          properties: PlexFormFieldGeneric.title('Show Info Sheet'),
          buttonType: PlexButtonType.elevated,
          buttonClick: _showInfoSheet,
        ),
        const SizedBox(height: 16),
        PlexFormFieldButton(
          properties: PlexFormFieldGeneric.title('Show Error Sheet'),
          buttonType: PlexButtonType.elevated,
          buttonClick: _showErrorSheet,
        ),
        const SizedBox(height: 16),
        PlexFormFieldButton(
          properties: PlexFormFieldGeneric.title('Show Alert Sheet'),
          buttonType: PlexButtonType.elevated,
          buttonClick: _showAlertSheet,
        ),
        const SizedBox(height: 16),
        PlexFormFieldButton(
          properties: PlexFormFieldGeneric.title('Show Custom Buttons Sheet'),
          buttonType: PlexButtonType.elevated,
          buttonClick: _showCustomButtonsSheet,
        ),
        const SizedBox(height: 16),
        PlexFormFieldButton(
          properties: PlexFormFieldGeneric.title('Show Custom Content Sheet'),
          buttonType: PlexButtonType.elevated,
          buttonClick: _showCustomContentSheet,
        ),
      ],
    );
  }
} 