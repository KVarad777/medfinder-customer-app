import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/location_helper.dart';
import 'shop_stock_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? userPosition;
  List<dynamic> shops = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// 📍 Load user location + all shops
  Future<void> _loadData() async {
    try {
      final pos = await LocationHelper.getCurrentLocation();
      final fetchedShops = await ApiService.getAllShops();

      setState(() {
        userPosition = pos;
        shops = fetchedShops;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  /// 🎨 Marker color based on shop status
  Color _markerColor(String status) {
    switch (status) {
      case "verified":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// 🧾 Show shop details on marker tap
  void _showShopDetails(dynamic shop) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shop["shopName"],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(shop["address"] ?? "Address not available"),
              const SizedBox(height: 8),

              Text(
                "Status: ${shop["status"].toUpperCase()}",
                style: TextStyle(
                  color: _markerColor(shop["status"]),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: shop["status"] == "verified"
                      ? () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShopStockScreen(
                                shopId: shop["shopId"],
                                shopName: shop["shopName"],
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text("View Stock"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userPosition == null) {
      return const Scaffold(
        body: Center(child: Text("Location unavailable")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Medical Shops")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            userPosition!.latitude,
            userPosition!.longitude,
          ),
          initialZoom: 13,
        ),
        children: [
          /// 🌍 Map tiles
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.medfinder',
          ),

          /// 📍 Markers
          MarkerLayer(
            markers: [
              /// 👤 User marker
              Marker(
                width: 40,
                height: 40,
                point: LatLng(
                  userPosition!.latitude,
                  userPosition!.longitude,
                ),
                child: const Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40,
                ),
              ),

              /// 🏪 Shop markers
              ...shops.map((shop) {
                return Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(
                    shop["location"]["latitude"],
                    shop["location"]["longitude"],
                  ),
                  child: GestureDetector(
                    onTap: () => _showShopDetails(shop),
                    child: Icon(
                      Icons.local_pharmacy,
                      color: _markerColor(shop["status"]),
                      size: 36,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
