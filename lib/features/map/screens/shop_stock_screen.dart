import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class ShopStockScreen extends StatelessWidget {
  final String shopId;
  final String shopName;

  const ShopStockScreen({
    super.key,
    required this.shopId,
    required this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shopName)),
      body: FutureBuilder(
        future: ApiService.getShopStock(shopId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final meds = snapshot.data as List;

          if (meds.isEmpty) {
            return const Center(child: Text("No stock available"));
          }

          return ListView.builder(
            itemCount: meds.length,
            itemBuilder: (context, index) {
              final m = meds[index];
              return Card(
                child: ListTile(
                  title: Text(m["medicine_name"]),
                  subtitle: Text(
                    "Batch: ${m["batch_number"]}\nExpiry: ${m["expiry_date"]?.toString().substring(0, 10)}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
