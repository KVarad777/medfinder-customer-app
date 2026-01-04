import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://medfinder-backend-0v6g.onrender.com";

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

  // ---------------- VERIFIED SHOPS (OPTIONAL) ----------------
  static Future<List<dynamic>> getVerifiedShops() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/shops/verified"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // ---------------- ALL SHOPS (MAP) ✅ FIXED ----------------
  static Future<List<dynamic>> getAllShops() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/shops/all"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // ---------------- AUTOCOMPLETE SEARCH ----------------
  static Future<List<dynamic>> searchMedicines(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/medicines/search?q=$query"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // ---------------- SHOPS HAVING MEDICINE ----------------
  static Future<List<dynamic>> getMedicineShops(String medicineName) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/medicines/$medicineName/shops"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // ---------------- SHOP STOCK ----------------
  static Future<List<dynamic>> getShopStock(String shopId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/medicines/shop/$shopId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // ---------------- RESERVE MEDICINE (OPTIONAL) ----------------
  static Future<bool> reserveMedicine(
    String medicineName,
    String customerName,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/medicines/reserve"),
      headers: headers,
      body: jsonEncode({
        "medicine_name": medicineName,
        "customer_name": customerName,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    }
    return false;
  }
}
