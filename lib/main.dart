import 'package:flutter/material.dart';
import 'dart:io';

// Auth
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';

// Main screens
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sites/sites_screen.dart';
import 'screens/hubs/hubs_screen.dart';
import 'screens/sensors/sensors_screen.dart';
import 'screens/alerts/alerts_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/sites': (context) => const SitesScreen(),
        '/hubs': (context) => const HubsScreen(),
        '/sensors': (context) => const SensorsScreen(),
        '/alerts': (context) => const AlertsScreen(),
      },
    );
  }
}
