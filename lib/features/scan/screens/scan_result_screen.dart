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
  String status = "";
  Map<String, dynamic>? medicine;

  @override
  void initState() {
    super.initState();
    _verifyQr();
  }

  Future<void> _verifyQr() async {
    try {
      final res = await ApiService.verifyQr(widget.qrData);
      setState(() {
        status = res["status"];
        medicine = res["medicine"];
        loading = false;
      });
    } catch (e) {
      setState(() {
        status = "ERROR";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification Result")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statusCard(),
                  const SizedBox(height: 20),

                  if (status == "GENUINE") ...[
                    _detail("Medicine", medicine?["medicine_name"]),
                    _detail("Brand", medicine?["brand_name"]),
                    _detail("Batch", medicine?["batch_number"]),
                    _detail(
                        "Expiry",
                        medicine?["expiry_date"]
                            ?.toString()
                            .split("T")[0]),
                  ],

                  if (status == "ALREADY_SOLD") ...[
                    _detail("Shop", medicine?["medical_shop_name"]),
                    _detail(
                        "Sold At",
                        medicine?["selling_date_time"]
                            ?.toString()
                            .replaceAll("T", " ")),
                  ],

                  if (status == "INVALID") ...[
                    const Text(
                      "This QR code is not registered in the system.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Scan Another"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statusCard() {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case "GENUINE":
        color = Colors.green;
        icon = Icons.verified;
        text = "Genuine Medicine";
        break;
      case "ALREADY_SOLD":
        color = Colors.orange;
        icon = Icons.warning;
        text = "Already Sold";
        break;
      default:
        color = Colors.red;
        icon = Icons.error;
        text = "Invalid Medicine";
    }

    return Card(
      color: color.withOpacity(0.1),
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _detail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        "$title: ${value ?? '-'}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
