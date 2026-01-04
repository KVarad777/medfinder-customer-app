import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyName = "name";
  static const String _keyMobile = "mobile";

  /// SAVE USER DATA AFTER LOGIN / SIGNUP
  static Future<void> saveUser({
    required String name,
    required String mobile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyMobile, mobile);
  }

  /// GET NAME
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  /// GET MOBILE
  static Future<String?> getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMobile);
  }

  /// LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
