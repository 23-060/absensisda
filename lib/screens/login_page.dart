import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final nip = _nipController.text.trim();
    final password = _passwordController.text;
    
    if (nip.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIP dan Password harus diisi!')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final url = Uri.parse('http://192.168.50.157:8000/api/auth/login');
      
      final response = await http.post(
        url,
        body: {
          'nip': nip,
          'password': password,
        },
      );
      
      final data = json.decode(response.body);
      
      // Jika Berhasil Login
      if (response.statusCode == 200 && data['success'] == true) {
        // Simpan "Tiket" Token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login Gagal')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server Laravel')),
      );
      print("Login Error: " + e.toString()); 
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo
                Center(
                  child: _PresensiLogo(),
                ),

                const SizedBox(height: 60),

                // NIP Label
                const Text(
                  'NIP',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // NIP Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E4EA), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _nipController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan NIP',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Icon(
                          Icons.badge_outlined,
                          color: const Color(0xFF4990E1),
                          size: 22,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password Label
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E4EA), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan password',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Icon(
                          Icons.lock_outline,
                          color: const Color(0xFF4990E1),
                          size: 22,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF4990E1),
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Lupa Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Handle lupa password
                    },
                    child: const Text(
                      'Lupa Password ?',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4990E1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Login Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4990E1),
                      disabledBackgroundColor: const Color(0xFF4990E1).withOpacity(0.7),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login_rounded, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Logo Widget
class _PresensiLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ganti manual arc + icon dengan gambar
        SizedBox(
          width: 184,
          height: 184,
          child: Image.asset(
            'assets/logo.png', // path ke file gambar kamu
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4990E1)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Draw main arc (about 300 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.4,
      5.0,
      false,
      paint,
    );

    // Draw arrow head at end of arc
    final arrowPaint = Paint()
      ..color = const Color(0xFF4990E1)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Arrow tip position (end of arc)
    final endAngle = -2.4 + 5.0;
    final tipX = center.dx + radius * (0.62);
    final tipY = center.dy - radius * (0.48);

    canvas.drawLine(
      Offset(tipX - 8, tipY - 2),
      Offset(tipX + 1, tipY + 7),
      arrowPaint,
    );
    canvas.drawLine(
      Offset(tipX + 9, tipY - 4),
      Offset(tipX + 1, tipY + 7),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
