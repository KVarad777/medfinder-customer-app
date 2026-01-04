import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/map/screens/map_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/scan/screens/scan_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/dashboard/screens/welcome_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String map = '/map';
  static const String search = '/search';
  static const String scan = '/scan';
  static const String profile = '/profile';
  static const String welcome = '/welcome';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    dashboard: (_) => const DashboardScreen(),
    map: (_) => const MapScreen(),
    search: (_) => const SearchScreen(),
    scan: (_) => const ScanScreen(),
    profile: (_) => const ProfileScreen(),
    welcome: (_) => const WelcomeScreen(),
  };
}
