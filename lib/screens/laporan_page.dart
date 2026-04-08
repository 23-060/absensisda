import 'package:flutter/material.dart';
import '../widgets/header.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  // Callback untuk tombol Unduh SPT
  void _handleDownload(BuildContext context, String day) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mengunduh SPT - $day..."),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Widget Card Laporan
  Widget _buildLaporanCard({
    required BuildContext context, // context dikirim dari parent
    required String date,
    required String month,
    required String day,
    required String checkInTime,
    required String checkOutTime,
    required String distanceIn,
    required String distanceOut,
    bool isTerverifikasi = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Atas: Tanggal + Hari + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kotak Tanggal
                Container(
                  width: 62,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E40AF),
                          height: 1.0,
                        ),
                      ),
                      Text(
                        month,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Hari dan Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 20, color: Color(0xFF3B82F6)),
                          const SizedBox(width: 8),
                          Text(
                            day,
                            style: const TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (isTerverifikasi)
                        const Row(
                          children: [
                            Text(
                              "Terverifikasi",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.check_circle,
                              size: 19,
                              color: Color(0xFF10B981),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Check In
            Row(
              children: [
                const Icon(Icons.login, size: 21, color: Color(0xFF10B981)),
                const SizedBox(width: 12),
                const Text("Check In",
                    style: TextStyle(fontSize: 14.5, color: Colors.black54)),
                const Spacer(),
                Text(
                  checkInTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.logout, size: 21, color: Color(0xFFEF4444)),
                const SizedBox(width: 12),
                const Text("Check Out",
                    style: TextStyle(fontSize: 14.5, color: Colors.black54)),
                const Spacer(),
                Text(
                  checkOutTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Color(0xFF3B82F6)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    distanceIn,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Color(0xFF3B82F6)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    distanceOut,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // Tombol Unduh SPT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleDownload(context, day),
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: const Text(
                  "Unduh SPT",
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          const Header(),
          const SizedBox(height: 60),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 30),
              children: [
                _buildLaporanCard(
                  context: context,
                  date: "1",
                  month: "Mei",
                  day: "Senin",
                  checkInTime: "07:30:17",
                  checkOutTime: "14:30:17",
                  distanceIn: "0,03km dari Diskominfo",
                  distanceOut: "0,02km dari Diskominfo",
                  isTerverifikasi: true,
                ),
                _buildLaporanCard(
                  context: context,
                  date: "2",
                  month: "Mei",
                  day: "Selasa",
                  checkInTime: "08:00:05",
                  checkOutTime: "15:15:30",
                  distanceIn: "0,01km dari Diskominfo",
                  distanceOut: "0,04km dari Diskominfo",
                  isTerverifikasi: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}