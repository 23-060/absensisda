import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/header.dart';
import 'package:dotted_border/dotted_border.dart';

enum LaporanStatus { terverifikasi, belumTerverifikasi, ditolak }

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final Map<String, String?> _uploadedFiles = {
    'Selasa': null,
  };

  Future<void> _handleUnggahSPT(String day) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final fileName = result.files.single.name;
        setState(() => _uploadedFiles[day] = fileName);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Berhasil: $fileName'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memilih file. Coba restart aplikasi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDownload(String day) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mengunduh SPT - $day..."),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildLaporanCard({
    required String date,
    required String month,
    required String day,
    required String checkInTime,
    required String checkOutTime,
    required String distanceIn,
    required String distanceOut,
    required LaporanStatus status,
    String? uploadedFileName,
  }) {
    final isTerverifikasi = status == LaporanStatus.terverifikasi;

    final statusColor = isTerverifikasi
        ? const Color(0xFF10B981)
        : const Color(0xFFeab308);

    final statusText = isTerverifikasi ? "Terverifikasi" : "Belum Terverifikasi";
    final statusIcon = isTerverifikasi ? Icons.check_circle : Icons.warning_amber_rounded;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 15, offset: const Offset(0, 6)),
        ],
      ),
      child: IntrinsicHeight(  // Agar box kiri full height
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Box Tanggal Kiri (full height)
            Container(
              width: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F9FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                      height: 1.0,
                    ),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                ],
              ),
            ),

            // Isi Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hari + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20, color: Color(0xFF3B82F6)),
                            const SizedBox(width: 8),
                            Text(
                              day,
                              style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(statusText, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: statusColor)),
                            const SizedBox(width: 6),
                            Icon(statusIcon, size: 20, color: statusColor),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Check In & Check Out
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 24, color: Color(0xFF10B981)),
                        const SizedBox(width: 12),
                        Text(checkInTime, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        const Icon(Icons.access_time, size: 24, color: Color(0xFFEF4444)),
                        const SizedBox(width: 12),
                        Text(checkOutTime, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600)),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Jarak Lokasi
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 22, color: Color(0xFF10B981)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(distanceIn, style: const TextStyle(fontSize: 14.5))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 22, color: Color(0xFFEF4444)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(distanceOut, style: const TextStyle(fontSize: 14.5))),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Nama file yang sudah diunggah
                    if (uploadedFileName != null && !isTerverifikasi)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file_outlined, size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(uploadedFileName, style: const TextStyle(fontSize: 14.5, color: Colors.grey)),
                          ],
                        ),
                      ),

                    // Tombol
                    if (isTerverifikasi)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleDownload(day),
                          icon: const Icon(Icons.download_rounded, color: Colors.white),
                          label: const Text("Unduh SPT", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4990E1),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: DottedBorder(
                          color: const Color(0xFF3B82F6),
                          strokeWidth: 2,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(30),
                          dashPattern: const [6, 3],
                          child: Container(                    // Tambahkan Container ini
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xFFEFF6FF),
                            ),
                            child: TextButton(                 // Ganti ke TextButton atau MaterialButton
                              onPressed: () => _handleUnggahSPT(day),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.transparent, // biar warna dari Container
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.upload_rounded, color: Color(0xFF3B82F6)),
                                  SizedBox(width: 8),
                                  Text(
                                    "Unggah SPT",
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3B82F6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                // Card Terverifikasi
                _buildLaporanCard(
                  date: "1",
                  month: "Mei",
                  day: "Senin",
                  checkInTime: "07:30:00",
                  checkOutTime: "15:00:01",
                  distanceIn: "0,03km dari Diskominfo",
                  distanceOut: "0,02km dari Diskominfo",
                  status: LaporanStatus.terverifikasi,
                ),

                // Card Belum Terverifikasi
                _buildLaporanCard(
                  date: "2",
                  month: "Mei",
                  day: "Selasa",
                  checkInTime: "07:30:00",
                  checkOutTime: "15:00:01",
                  distanceIn: "0,03km dari Diskominfo",
                  distanceOut: "0,02km dari Diskominfo",
                  status: LaporanStatus.belumTerverifikasi,
                  uploadedFileName: _uploadedFiles['Selasa'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}