import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/session_manager.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();

    if (name.isEmpty || mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and mobile number required")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await ApiService.signupCustomer(mobile, name);

      if (!mounted) return;

      if (res["success"] == true) {
        final customer = res["customer"];

        // ✅ SAVE USER LOCALLY
        await SessionManager.saveUser(
          name: customer["name"],
          mobile: customer["mobileNumber"],
        );

        if (!mounted) return;

        // ✅ GO TO DASHBOARD
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.dashboard,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res["message"] ?? "Signup failed"),
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
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _signup,
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Create Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
