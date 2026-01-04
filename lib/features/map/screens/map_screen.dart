import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/location_helper.dart';
import 'package:geolocator/geolocator.dart';

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

  Future<void> _loadData() async {
    try {
      final pos = await LocationHelper.getCurrentLocation();
      final fetchedShops = await ApiService.getVerifiedShops();

      setState(() {
        userPosition = pos;
        shops = fetchedShops;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
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
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.medfinder',
          ),
          MarkerLayer(
            markers: [
              // USER LOCATION
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

              // SHOP LOCATIONS
              ...shops.map((shop) {
                return Marker(
                  width: 40,
                  height: 40,
                  point: LatLng(
                    shop["location"]["latitude"],
                    shop["location"]["longitude"],
                  ),
                  child: const Icon(
                    Icons.local_pharmacy,
                    color: Colors.green,
                    size: 36,
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
