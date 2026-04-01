import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2B7EE0), Color(0xFF5BA3F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Image.asset('assets/logo_white.png', fit: BoxFit.contain),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Reguler',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '07.30 - 16.00',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    color: const Color(0xFF5BA3F5),
                    image: const DecorationImage(
                      image: AssetImage('assets/profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 44);
    path.quadraticBezierTo(
      size.width * 0.25, size.height + 4,
      size.width * 0.5, size.height - 22,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 48,
      size.width, size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
