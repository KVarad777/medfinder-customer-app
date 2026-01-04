import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scan_result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Medicine QR")),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              if (_isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;

              final String? code = barcodes.first.rawValue;
              if (code == null) return;

              setState(() {
                _isScanned = true;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScanResultScreen(qrData: code),
                ),
              ).then((_) {
                setState(() {
                  _isScanned = false;
                });
              });
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: Text(
                  "Align QR within the frame",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
