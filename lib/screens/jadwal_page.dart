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
                  backgroundColor: const Color(0xFF3D8BEF),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
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
                  backgroundColor: const Color(0xFF3D8BEF),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildJadwalItem(
                  date: "1",
                  month: "Mei",
                  day: "Senin",
                  time: "07:30 - 14:00",
                  location: "Diskominfo",
                  shift: "Reguler",
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
    required String month,
    required String day,
    required String time,
    required String location,
    required String shift,
  }) {
    Color mainColor;
    Color bgDateColor;
    Color textDateColor;

    final shiftLower = shift.toLowerCase().trim();

    if (shiftLower == "reguler") {
      mainColor = const Color(0xFF4990E1);
      bgDateColor = const Color(0xFFF0F9FF);
      textDateColor = const Color(0xFF1E40AF);
    } else if (shiftLower == "cuti" || shiftLower == "libur") {
      mainColor = const Color(0xFFEF4444);
      bgDateColor = const Color(0xFFFEE2E2);
      textDateColor = const Color(0xFFB91C1C);
    } else {
      mainColor = const Color(0xFFF59E0B);
      bgDateColor = const Color(0xFFFEF3C7);
      textDateColor = const Color(0xFFB45309);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 72,
              decoration: BoxDecoration(
                color: bgDateColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: textDateColor,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textDateColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18, color: mainColor),
                        const SizedBox(width: 6),
                        Text(
                          day,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.access_time, size: 17, color: mainColor),
                        const SizedBox(width: 4),
                        Text(
                          time.isEmpty ? "-" : time,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: mainColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 14.5,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Shift
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              shift,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: mainColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}