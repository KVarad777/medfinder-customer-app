import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  List<dynamic> suggestions = [];
  Map<String, List<dynamic>> shopsMap = {};

  bool loadingSuggestions = false;
  bool loadingShops = false;

  /// 🔍 Autocomplete
  Future<void> _search(String q) async {
    if (q.length < 2) {
      setState(() => suggestions = []);
      return;
    }

    setState(() => loadingSuggestions = true);
    final res = await ApiService.searchMedicines(q);
    setState(() {
      suggestions = res;
      loadingSuggestions = false;
    });
  }

  /// 🏪 Load shops
  Future<void> _loadShops(String medicineName) async {
    setState(() {
      loadingShops = true;
      suggestions = [];
      controller.text = medicineName;
      shopsMap.clear();
    });

    final meds = await ApiService.getMedicineShops(medicineName);

    // 🔁 Group medicines by shop
    final Map<String, List<dynamic>> grouped = {};
    for (var m in meds) {
      final shop = m["medical_shop_name"] ?? "Unknown Shop";
      grouped.putIfAbsent(shop, () => []).add(m);
    }

    setState(() {
      shopsMap = grouped;
      loadingShops = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 Search field
            TextField(
              controller: controller,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: "Search medicine name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            if (loadingSuggestions)
              const LinearProgressIndicator(),

            /// 🔽 Autocomplete list
            if (suggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final med = suggestions[index];
                    return ListTile(
                      title: Text(med["medicine_name"]),
                      subtitle: Text(med["brand_name"] ?? ""),
                      onTap: () =>
                          _loadShops(med["medicine_name"]),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            /// 🏪 Shops list
            if (loadingShops)
              const CircularProgressIndicator(),

            if (!loadingShops && shopsMap.isNotEmpty)
              Expanded(
                child: ListView(
                  children: shopsMap.entries.map((entry) {
                    final shopName = entry.key;
                    final items = entry.value;

                    return Card(
                      child: ListTile(
                        title: Text(shopName),
                        subtitle: Text(
                          "Available: ${items.length} units\nExpiry: ${items.first["expiry_date"]?.toString().substring(0, 10)}",
                        ),
                        trailing: ElevatedButton(
                         onPressed: () async {
                            final success = await ApiService.reserveMedicine(
                              controller.text,
                              "Customer", // later from session
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success ? "Reserved successfully" : "Out of stock",
                                ),
                              ),
                            );

                            if (success) {
                              _loadShops(controller.text); // refresh list
                            }
                          },

                          child: const Text("Reserve"),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            if (!loadingShops &&
                controller.text.isNotEmpty &&
                shopsMap.isEmpty)
              const Text("No shops found for this medicine"),
          ],
        ),
      ),
    );
  }
}
