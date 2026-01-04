import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final mobile = mobileController.text.trim();

    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter mobile number")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await ApiService.loginCustomer(mobile);

      if (!mounted) return;

      if (res["success"] == true) {
        final customer = res["customer"];

        // ✅ SAVE USER LOCALLY
        await SessionManager.saveUser(
          name: customer["name"],
          mobile: customer["mobileNumber"],
        );

        if (!mounted) return;

        // ✅ GO TO DASHBOARD (NO ARGUMENTS)
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.dashboard,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res["message"] ?? "User not found"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Backend not reachable")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "MedFinder",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Mobile input
                  TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Mobile Number",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Signup navigation
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
                    },
                    child: const Text("New user? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
