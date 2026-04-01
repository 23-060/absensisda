import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  final Widget icon; // <-- widget, bukan IconData
  final String label;
  final String time;
  final Color color;
  final bool isActive;

  const StatusPill({
    Key? key,
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: isActive ? color.withOpacity(0.08) : Colors.transparent,
          ),
          child: Center(child: icon), // tampilkan widget ikon di tengah
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isActive ? color : const Color(0xFFADB5C2),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? color : const Color(0xFFADB5C2),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
