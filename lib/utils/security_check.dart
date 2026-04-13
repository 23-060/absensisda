import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_device/safe_device.dart';

class SecurityCheck {
  static Future<bool> isDeviceSafe(BuildContext context) async {
    bool isJailBroken = await SafeDevice.isJailBroken;
    // Kita tetap ambil datanya, tapi tidak akan kita gunakan untuk memblokir
    bool isMockLocation = await SafeDevice.isMockLocation;
    bool isDevMode = await SafeDevice.isDevelopmentModeEnable;

    // Menghapus kondisi !isRealDevice dari pengecekan utama
    if (isJailBroken || isMockLocation || isDevMode) {
      _showSecurityDialog(context, isJailBroken, isMockLocation, isDevMode);
      return false;
    }
    return true;
  }

  static void _showSecurityDialog(BuildContext context,
      bool jailbroken, bool mock, bool devMode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("⚠️ Perangkat Tidak Aman"),
        content: Text(
            "Aplikasi tidak dapat dijalankan karena:\n\n"
                "${jailbroken ? "• Root/Jailbreak terdeteksi\n" : ""}"
                "${mock ? "• Mock Location aktif\n" : ""}"
                "${devMode ? "• Developer Options aktif\n" : ""}"
        ),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("KELUAR APLIKASI"),
          ),
        ],
      ),
    );
  }
}