import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:plex/plex_utils.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex/plex_widgets/plex_input_widget.dart';

class PlexScanner extends StatefulWidget {
  const PlexScanner({super.key});

  @override
  _PlexScannerState createState() => _PlexScannerState();
}

class _PlexScannerState extends State<PlexScanner> {
  MobileScannerController cameraController = MobileScannerController();
  final List<bool> _isSelected = [true, false];

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(kDebugMode && !GetPlatform.isMobile) {
      delay(() {
        Navigator.pop(context, "FL-941104-602");
      }, delayMillis: 2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (GetPlatform.isMobile) ...{
              MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final String? barcodeValue = barcodes.first.rawValue;
                    if (barcodeValue != null) {
                      _scan(barcodeValue);
                    }
                  }
                },
              ),
            } else ...{
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(PlexDim.medium),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Please use mobile application to scan QR codes",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: PlexFormFieldButton(
                          properties:PlexFormFieldGeneric.title("Close"),
                          buttonClick: () {
                            Plex.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            },
            Positioned(
              top: 0,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                width: MediaQuery.of(context).size.width * 1.0,
                child: const Text(
                  "To trace an item, scan the QR code",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFD9E5F8), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              bottom: 50.0,
              child: ToggleButtons(
                isSelected: _isSelected,
                onPressed: (int index) async {
                  if (!_isSelected[index]) {
                    await cameraController.toggleTorch();
                  }
                  setState(() {
                    for (int i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = i == index;
                    }
                  });
                },
                children: const [
                  Icon(Icons.flash_off),
                  Icon(Icons.flash_on),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scan(String scannedCode) {
    cameraController.stop();
    Navigator.pop(context, scannedCode);
  }
}