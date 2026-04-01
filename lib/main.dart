import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/security_check.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SecurityGate(), // cek dulu sebelum masuk
    );
  }
}

class SecurityGate extends StatefulWidget {
  const SecurityGate({super.key});

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    bool safe = await SecurityCheck.isDeviceSafe(context);
    if (!safe) {
      // kalau tidak aman, dialog sudah muncul di SecurityCheck
      return;
    }

    // kalau aman, tentukan apakah sudah login atau belum
    bool loggedIn = await _isLoggedIn();

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  Future<bool> _isLoggedIn() async {
    // contoh sederhana: cek token di SharedPreferences
    // untuk demo, anggap belum login
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
