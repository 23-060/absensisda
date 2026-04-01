import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

enum PresensiState { masuk, verifikasi, keluar, disable }

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  PresensiState _presensiState = PresensiState.masuk;
  String _waktuMasuk = '--:--:--';
  String _waktuKeluar = '--:--:--';
  late Timer _clockTimer;
  String _jamSekarang = '';
  String _tanggalSekarang = '';
  int _selectedIndex = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _updateTime() {
    final now = DateTime.now();
    const days = [
      'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
    ];
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    setState(() {
      _jamSekarang =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _tanggalSekarang =
      '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // ── BARU: buka kamera → verifikasi animasi → pindah state ──
  Future<void> _openCameraAndVerify({required bool isMasuk}) async {
    final captured = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _CameraDialog(),
    );

    if (captured != true) return;

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _presensiState = PresensiState.verifikasi;
      if (isMasuk) _waktuMasuk = timeStr;
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _VerifikasiAnimasiDialog(
        onSelesai: () => Navigator.of(ctx).pop(),
      ),
    );

    setState(() {
      if (isMasuk) {
        _presensiState = PresensiState.keluar;
      } else {
        _presensiState = PresensiState.disable;
        _waktuKeluar = timeStr;
      }
    });
  }

  void _onTapPresensiButton() {
    if (_presensiState == PresensiState.masuk) {
      _openCameraAndVerify(isMasuk: true);
    } else if (_presensiState == PresensiState.keluar) {
      _openCameraAndVerify(isMasuk: false);
    }
  }

  Color get _buttonColor {
    switch (_presensiState) {
      case PresensiState.masuk:
        return const Color(0xFF3D8BEF);
      case PresensiState.verifikasi:
        return const Color(0xFF34C789);
      case PresensiState.keluar:
        return const Color(0xFFEF4444);
      case PresensiState.disable:
        return const Color(0xFF9CA3AF);
    }
  }

  String get _buttonLabel {
    switch (_presensiState) {
      case PresensiState.masuk:
        return 'Masuk';
      case PresensiState.verifikasi:
        return 'Verifikasi';
      case PresensiState.keluar:
        return 'Keluar';
      case PresensiState.disable:
        return 'Selesai';
    }
  }

  Widget get _buttonIconData {
    switch (_presensiState) {
      case PresensiState.masuk:
        return Image.asset('assets/touch.png', fit: BoxFit.contain);
      case PresensiState.verifikasi:
        return Image.asset('assets/checked.png', fit: BoxFit.contain);
      case PresensiState.keluar:
        return Image.asset('assets/touch.png', fit: BoxFit.contain);
      case PresensiState.disable:
        return Image.asset('assets/touch.png', fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 36),
                  _buildBigButton(),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.location_on_outlined,
                          color: Color(0xFF3D8BEF), size: 18),
                      SizedBox(width: 6),
                      Text(
                        '200m dari Kantor Diskominfo',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildStatusRow(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 228,
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
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Image.asset('assets/logo_white.png',
                          fit: BoxFit.contain),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Reguler',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                        Text('07.30 - 16.00',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 11)),
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
              const SizedBox(height: 150),
              Text(
                _jamSekarang,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -2,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _tanggalSekarang,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBigButton() {
    final bool isDisabled = _presensiState == PresensiState.disable ||
        _presensiState == PresensiState.verifikasi;
    return ScaleTransition(
      scale: isDisabled ? const AlwaysStoppedAnimation(1.0) : _pulseAnimation,
      child: GestureDetector(
        onTap: isDisabled ? null : _onTapPresensiButton,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: 152,
          height: 151,
          decoration: BoxDecoration(
            color: _buttonColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _buttonColor.withOpacity(0.45),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buttonIconData,
              const SizedBox(height: 8),
              Text(
                _buttonLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatusPill(
          icon: Icons.login_rounded,
          label: 'Masuk',
          time: _waktuMasuk,
          color: const Color(0xFF34C789),
          isActive: _presensiState != PresensiState.masuk,
        ),
        const SizedBox(width: 48),
        _StatusPill(
          icon: Icons.logout_rounded,
          label: 'Keluar',
          time: _waktuKeluar,
          color: const Color(0xFFEF4444),
          isActive: _presensiState == PresensiState.disable,
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNav(
      selectedIndex: _selectedIndex,
      onItemSelected: (index) {
        setState(() => _selectedIndex = index);
      },
    );
  }
}

// ── Status Pill ──────────────────────────────────────────────
class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;
  final bool isActive;

  const _StatusPill({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
    required this.isActive,
  });

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
          child: Icon(icon, color: color, size: 24),
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

// ── Camera Dialog ────────────────────────────────────────────
class _CameraDialog extends StatefulWidget {
  const _CameraDialog();

  @override
  State<_CameraDialog> createState() => _CameraDialogState();
}

class _CameraDialogState extends State<_CameraDialog> {
  CameraController? _controller;
  bool _isReady = false;
  bool _isCaptured = false;
  XFile? _capturedFile;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final front = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(front, ResolutionPreset.medium,
        enableAudio: false);
    await _controller!.initialize();
    if (mounted) setState(() => _isReady = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final file = await _controller!.takePicture();
    setState(() {
      _isCaptured = true;
      _capturedFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
            child: Row(
              children: [
                const Text('Ambil Foto',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E))),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFF3D8BEF)),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: 280,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_isCaptured && _capturedFile != null)
                      Image.file(File(_capturedFile!.path), fit: BoxFit.cover)
                    else if (_isReady)
                      CameraPreview(_controller!)
                    else
                      Container(
                        color: Colors.black,
                        child: const Center(
                            child: CircularProgressIndicator(
                                color: Colors.white)),
                      ),

                    // Oval guide
                    if (!_isCaptured && _isReady)
                      Center(
                        child: Container(
                          width: 156,
                          height: 196,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.7), width: 2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),

                    // Centang setelah capture
                    if (_isCaptured)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF34C789)),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_isCaptured) {
                        setState(() {
                          _isCaptured = false;
                          _capturedFile = null;
                        });
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(_isCaptured ? 'Ulang' : 'Batal'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3D8BEF),
                      side: const BorderSide(color: Color(0xFFD1D9E6)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isReady
                        ? (_isCaptured
                        ? () => Navigator.of(context).pop(true)
                        : _takePicture)
                        : null,
                    icon: Icon(
                        _isCaptured
                            ? Icons.check_rounded
                            : Icons.camera_alt_rounded,
                        size: 18),
                    label: Text(_isCaptured ? 'Konfirmasi' : 'Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8BEF),
                      disabledBackgroundColor:
                      const Color(0xFF3D8BEF).withOpacity(0.4),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Verifikasi Animasi Dialog ────────────────────────────────
class _VerifikasiAnimasiDialog extends StatefulWidget {
  final VoidCallback onSelesai;
  const _VerifikasiAnimasiDialog({required this.onSelesai});

  @override
  State<_VerifikasiAnimasiDialog> createState() =>
      _VerifikasiAnimasiDialogState();
}

class _VerifikasiAnimasiDialogState extends State<_VerifikasiAnimasiDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;
  String _status = 'Memverifikasi data...';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _progress = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _status = 'Menyimpan presensi...');
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) widget.onSelesai();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 60),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _progress,
              builder: (_, __) {
                final done = _progress.value >= 1.0;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: done
                      ? Container(
                    key: const ValueKey('done'),
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF34C789)),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 36),
                  )
                      : SizedBox(
                    key: const ValueKey('loading'),
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: _progress.value,
                      strokeWidth: 5,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF3D8BEF)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _status,
                key: ValueKey(_status),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Wave Clipper ─────────────────────────────────────────────
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