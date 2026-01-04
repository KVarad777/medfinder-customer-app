import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class ScanResultScreen extends StatefulWidget {
  final String qrData;
  const ScanResultScreen({super.key, required this.qrData});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  bool loading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _verify();
  }

  Future<void> _verify() async {
    final res = await ApiService.verifyQr(widget.qrData);
    setState(() {
      data = res;
      loading = false;
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case "GENUINE":
        return Colors.green;
      case "ALREADY_SOLD":
        return Colors.orange;
      case "ILLEGAL":
        return Colors.red;
      case "FAKE":
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final status = data?["status"] ?? "UNKNOWN";

    return Scaffold(
      appBar: AppBar(title: const Text("Verification Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              color: _statusColor(status).withOpacity(0.1),
              child: ListTile(
                leading: Icon(Icons.verified, color: _statusColor(status)),
                title: Text(
                  status,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _statusColor(status),
                  ),
                ),
                subtitle: Text(data?["message"] ?? ""),
              ),
            ),
            const SizedBox(height: 20),

            _row("Medicine", data?["medicine_name"]),
            _row("Brand", data?["brand_name"]),
            _row("Batch", data?["batch_number"]),
            _row(
              "Expiry",
              data?["expiry_date"] != null
                  ? data!["expiry_date"].toString().substring(0, 10)
                  : null,
            ),
            _row("Days to Expiry", data?["days_to_expiry"]?.toString()),

            if (status == "ALREADY_SOLD" || status == "ILLEGAL") ...[
              const Divider(),
              _row("Sold At", data?["sold_at"]?.toString()),
              _row("Customer", data?["sold_to"]),
              _row("Shop", data?["shop_name"]),
              _row("Address", data?["shop_address"]),
            ],

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Generate PDF Report"),
              onPressed: () {
                // next step
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
    if (value == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text("$label: $value"),
    );
  }
}
