import 'package:flutter/material.dart';
import '../../map/screens/map_screen.dart';
import '../../scan/screens/scan_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../core/constants/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeTab(),
    MapScreen(),
    ScanScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Shops"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/* ---------------- HOME TAB ---------------- */

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔷 HEADER
              const Text(
                "MedFinder",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Verify medicines. Find trusted medical shops.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // 🔷 HERO CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Scan QR to check medicine authenticity instantly",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.verified, color: Colors.white, size: 50),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔷 QUICK ACTIONS
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _QuickAction(
                    icon: Icons.qr_code_scanner,
                    label: "Scan",
                  ),
                  _QuickAction(
                    icon: Icons.search,
                    label: "Search",
                  ),
                  _QuickAction(
                    icon: Icons.location_on,
                    label: "Nearby Shops",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 🔷 TRUST SECTION
              const Text(
                "Why MedFinder?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              const _InfoTile(
                icon: Icons.security,
                text: "100% Verified Medical Stores",
              ),
              const _InfoTile(
                icon: Icons.track_changes,
                text: "Track medicine sale & authenticity",
              ),
              const _InfoTile(
                icon: Icons.health_and_safety,
                text: "Protect yourself from fake medicines",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(text),
    );
  }
}
