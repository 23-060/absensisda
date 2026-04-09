import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_device/safe_device.dart';

class SecurityCheck {
  static Future<bool> isDeviceSafe(BuildContext context) async {
    bool isJailBroken = await SafeDevice.isJailBroken;
    bool isRealDevice = await SafeDevice.isRealDevice;
    bool isMockLocation = await SafeDevice.isMockLocation;
    // bool isDevMode = await SafeDevice.isDevelopmentModeEnable; // dihapus

    if (isJailBroken || !isRealDevice || isMockLocation) {
      _showSecurityDialog(context, isJailBroken, isRealDevice, isMockLocation);
      return false;
    }
    return true;
  }

  static void _showSecurityDialog(
      BuildContext context, bool jailbroken, bool emulator, bool mock) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("⚠️ Perangkat Tidak Aman"),
        content: Text(
            "Aplikasi tidak dapat dijalankan karena:\n\n"
                "${jailbroken ? "• Root/Jailbreak terdeteksi\n" : ""}"
                "${!emulator ? "• Emulator terdeteksi\n" : ""}"
                "${mock ? "• Mock Location aktif\n" : ""}"
          // Developer Mode tidak lagi ditampilkan
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
