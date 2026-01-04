import 'package:flutter/material.dart';

class MedicineDetailScreen extends StatelessWidget {
  const MedicineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicine Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Paracetamol 500mg",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Manufacturer: ABC Pharma"),
            Text("Strip Size: 10 tablets"),
            Text("MRP: ₹30"),
            SizedBox(height: 20),
            Text("Available At:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text("Apollo Pharmacy"),
              subtitle: Text("₹28"),
            ),
            ListTile(
              title: Text("MedPlus"),
              subtitle: Text("₹29"),
            ),
          ],
        ),
      ),
    );
  }
}
