import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../core/utils/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? mobile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storedName = await SessionManager.getName();
    final storedMobile = await SessionManager.getMobile();

    if (!mounted) return;

    setState(() {
      name = storedName;
      mobile = storedMobile;
    });
  }

  Future<void> _logout() async {
    await SessionManager.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: mobile == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Avatar
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Name
                  Text(
                    name ?? "-",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// Mobile
                  Text(
                    mobile ?? "-",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  /// Profile options
                  _profileTile(Icons.history, "My Orders"),
                  _profileTile(Icons.location_on, "Saved Addresses"),
                  _profileTile(Icons.settings, "Settings"),

                  const Spacer(),

                  /// Logout
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),
    );
  }

  /// Reusable tile
  Widget _profileTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title coming soon")),
        );
      },
    );
  }
}
