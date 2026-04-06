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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF3D8BEF), // biru
                  shape: const CircleBorder(),
                ),
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white, // putih agar kontras
                  size: 28,
                ),
              ),

              const SizedBox(width: 49),

              const Text(
                "Mei 2026",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 49),

              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF3D8BEF), // biru
                  shape: const CircleBorder(),
                ),
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white, // putih agar kontras
                  size: 28,
                ),
              ),
            ],
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildJadwalItem(
                  date: "1",
                  day: "Senin",
                  time: "14:00 - 21:00",
                  location: "Diskominfo",
                  shift: "Sif 1",
                  color: Colors.blue,
                  isOff: false,
                ),
                _buildJadwalItem(
                  date: "2",
                  day: "Selasa",
                  time: "07:30 - 14:00",
                  location: "Diskominfo",
                  shift: "Sif 1",
                  color: Colors.blue,
                  isOff: false,
                ),
                _buildJadwalItem(
                  date: "3",
                  day: "Rabu",
                  time: "14:00 - 21:00",
                  location: "Diskominfo",
                  shift: "Sif 2",
                  color: Colors.blue,
                  isOff: false,
                ),
                _buildJadwalItem(
                  date: "4",
                  day: "Kamis",
                  time: "14:00 - 21:00",
                  location: "Diskominfo",
                  shift: "Sif 2",
                  color: Colors.blue,
                  isOff: false,
                ),
                _buildJadwalItem(
                  date: "5",
                  day: "Jumat",
                  time: "-",
                  location: "Diskominfo",
                  shift: "Cuti",
                  color: Colors.red,
                  isOff: true,
                ),
                _buildJadwalItem(
                  date: "6",
                  day: "Sabtu",
                  time: "14:00 - 21:00",
                  location: "Diskominfo",
                  shift: "Sif 3",
                  color: Colors.blue,
                  isOff: false,
                ),
                _buildJadwalItem(
                  date: "7",
                  day: "Minggu",
                  time: "-",
                  location: "Diskominfo",
                  shift: "Libur",
                  color: Colors.red,
                  isOff: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalItem({
    required String date,
    required String day,
    required String time,
    required String location,
    required String shift,
    required Color color,
    required bool isOff,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$date Mei",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: Color(0xFF3D8BEF)),
              const SizedBox(width: 6),
              Text(
                day,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Color(0xFF3D8BEF)),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Color(0xFF3D8BEF)),
              const SizedBox(width: 6),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.circle, size: 14, color: Color(0xFF3D8BEF)),
              const SizedBox(width: 6),
              Text(
                shift,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isOff ? Colors.red : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
