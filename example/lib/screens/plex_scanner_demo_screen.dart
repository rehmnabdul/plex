import 'package:flutter/material.dart';
import 'package:plex/plex_scanner.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

class PlexScannerDemoScreen extends PlexScreen {
  const PlexScannerDemoScreen({super.key});

  @override
  PlexState<PlexScannerDemoScreen> createState() => _PlexScannerDemoScreenState();
}

class _PlexScannerDemoScreenState extends PlexState<PlexScannerDemoScreen> {
  String? _scannedCode;

  Future<void> _openScanner() async {
    final result = await Plex.to(PlexScanner());
    if (result != null) {
      setState(() {
        _scannedCode = result.toString();
      });
    }
  }

  @override
  AppBar? buildAppBar() {
    return AppBar(
      title: const Text('Mobile Scanner Demo'),
    );
  }

  @override
  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Scan a QR code or barcode using your device camera.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          PlexFormFieldButton(
            properties: PlexFormFieldGeneric.title('Scan'),
            buttonIcon: const Icon(Icons.qr_code_scanner),
            buttonType: PlexButtonType.elevated,
            buttonClick: _openScanner,
          ),
          const SizedBox(height: 32),
          const Text(
            'Scanned Result',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Card(
              elevation: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    _scannedCode ?? 'No code scanned yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: _scannedCode != null ? Colors.black87 : Colors.grey,
                    ),
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
