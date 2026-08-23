import 'package:flutter/material.dart';
import 'package:plex/plex_scanner.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex_app/screens/example_chrome.dart';

class PlexScannerDemoScreen extends PlexScreen {
  const PlexScannerDemoScreen({super.key}) : super(useScaffold: false);

  @override
  PlexState<PlexScannerDemoScreen> createState() =>
      _PlexScannerDemoScreenState();
}

class _PlexScannerDemoScreenState extends PlexState<PlexScannerDemoScreen> {
  String? _scannedCode;

  Future<void> _openScanner() async {
    final result = await Plex.to(const PlexScanner());
    if (result != null) {
      setState(() {
        _scannedCode = result.toString();
      });
    }
  }

  @override
  Widget buildBody() {
    final colors = PlexThemeData.of(context).colors;
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExampleCard(
            title: "Mobile scanner",
            subtitle: "Scan a QR code or barcode with the device camera",
            actions: PlexBadge(
              label: _scannedCode == null ? "Idle" : "Scanned",
              tone: _scannedCode == null
                  ? PlexBadgeTone.neutral
                  : PlexBadgeTone.success,
              dot: true,
            ),
            child: PlexFormFieldButton(
              properties: const PlexFormFieldGeneric(
                title: "Scan",
                useMargin: false,
              ),
              buttonIcon: const Icon(Icons.qr_code_scanner),
              buttonType: PlexButtonType.filled,
              buttonClick: _openScanner,
            ),
          ),
          const SizedBox(height: PlexDim.medium),
          Expanded(
            child: ExampleCard(
              title: "Result",
              child: Center(
                child: SelectableText(
                  _scannedCode ?? "No code scanned yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: PlexFontSize.bodyLarge,
                    color: _scannedCode != null
                        ? colors.textPrimary
                        : colors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
