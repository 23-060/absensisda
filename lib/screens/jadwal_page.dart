import 'package:flutter/material.dart';
import '../widgets/header.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          const Header(),
          const SizedBox(height: 60),

          Expanded(
            child: Center(
              child: Text(
                "Halaman Jadwal",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}