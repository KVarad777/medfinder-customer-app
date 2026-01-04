import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔴 CHANGE ONLY THIS VALUE WHEN NEEDED
  static const String baseUrl = "http://192.168.1.2:3000";

  static const Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  // ---------------- LOGIN ----------------
  static Future<Map<String, dynamic>> loginCustomer(String mobile) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/customer/login"),
      headers: headers,
      body: jsonEncode({"mobileNumber": mobile}),
    );

    return jsonDecode(response.body);
  }

  // ---------------- SIGNUP ----------------
  static Future<Map<String, dynamic>> signupCustomer(
      String mobile, String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/customer/signup"),
      headers: headers,
      body: jsonEncode({
        "mobileNumber": mobile,
        "name": name,
      }),
    );

    return jsonDecode(response.body);
  }

  // ---------------- VERIFY QR ----------------
  static Future<Map<String, dynamic>> verifyQr(String textCode) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/verify-qr"),
      headers: headers,
      body: jsonEncode({"textCode": textCode}),
    );

    return jsonDecode(response.body);
  }

  // ---------------- GET VERIFIED SHOPS ----------------
  static Future<List<dynamic>> getVerifiedShops() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/shops/verified"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}
