import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scan_result_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Medicine QR")),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isEmpty) return;

          final String? code = barcodes.first.rawValue;
          if (code == null) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanResultScreen(qrData: code),
            ),
          );
        },
      ),
    );
  }
}
