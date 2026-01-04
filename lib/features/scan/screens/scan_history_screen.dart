import 'package:flutter/material.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History")),
      body: ListView(
        children: const [
          _HistoryTile("Paracetamol 500mg", "Genuine", Colors.green),
          _HistoryTile("Azithromycin", "Already Sold", Colors.orange),
          _HistoryTile("Unknown Medicine", "Invalid", Colors.red),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final String medicine;
  final String status;
  final Color color;

  const _HistoryTile(this.medicine, this.status, this.color);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.qr_code, color: color),
      title: Text(medicine),
      subtitle: Text(status),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    );
  }
}
