## 🚀 Cara Penggunaan (Usage)

Gunakan plugin ini untuk meningkatkan keamanan aplikasi Anda dengan mendeteksi status perangkat (Root/Jailbreak, Emulator, atau Mock Location).

### 🛠 Fitur Utama

| Fungsi | Deskripsi | Platform |
| :--- | :--- | :--- |
| `isJailBroken` | Mengecek apakah perangkat di-Jailbreak atau Root. | All |
| `isRealDevice` | Memastikan aplikasi berjalan di perangkat asli (bukan emulator). | All |
| `isSafeDevice` | Ringkasan pengecekan keamanan (menggabungkan semua parameter). | All |
| `isMockLocation` | Mendeteksi apakah user menggunakan lokasi palsu. | All |

---

### 📱 Implementasi Kode

#### 1. Deteksi Keamanan Perangkat
Pengecekan standar untuk mengetahui apakah perangkat aman atau telah dimodifikasi.

```dart
// Cek Jailbreak atau Root
bool isJailBroken = await SafeDevice.isJailBroken;

// (Khusus iOS) Deteksi mendalam dengan custom path checking
bool isJailBrokenCustom = await SafeDevice.isJailBrokenCustom;

// (Khusus iOS) Mendapatkan rincian metode deteksi yang terpicu
Map<String, bool> details = await SafeDevice.jailbreakDetails;
```

#### 2. Deteksi Emulator & Lokasi
Berguna untuk mencegah kecurangan atau penggunaan bot.

```dart
// Cek apakah perangkat asli atau emulator
bool isRealDevice = await SafeDevice.isRealDevice;

// Cek apakah user menggunakan Mock Location (Lokasi Palsu)
bool isMockLocation = await SafeDevice.isMockLocation;
```
> **Catatan:** Pada **Android**, jika konfigurasi mock check dimatikan, akan selalu mengembalikan `false`. Pada **iOS**, deteksi ini bergantung pada status jailbreak/emulator.

#### 3. Fitur Spesifik Android
Khusus untuk kontrol lebih mendalam pada ekosistem Android.

```dart
// Cek apakah Developer Options (Opsi Pengembang) aktif
bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;

// Cek apakah aplikasi terinstal di SD Card (Penyimpanan Eksternal)
bool isOnExternalStorage = await SafeDevice.isOnExternalStorage;

// Dapatkan detail metode root untuk kebutuhan debugging
Map<String, dynamic> rootDetails = await SafeDevice.rootDetectionDetails;
```

#### 4. Cek Keamanan Cepat (Shortcut)
Gunakan fungsi ini jika Anda ingin hasil instan apakah perangkat layak menjalankan aplikasi atau tidak.

```dart
bool isSafe = await SafeDevice.isSafeDevice;
```
```

---


### 🛡️ Contoh Implementasi Logika Blokir (App Shield)

Tambahkan kode ini di dalam fungsi `initState` pada halaman pertama aplikasi Anda atau sebelum `runApp` dipanggil:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_device/safe_device.dart'; // Pastikan plugin sudah terpasang

Future<void> checkSecurity(BuildContext context) async {
  bool isJailBroken = await SafeDevice.isJailBroken;
  bool isRealDevice = await SafeDevice.isRealDevice;
  bool isMockLocation = await SafeDevice.isMockLocation;
  bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;

  // Tentukan kriteria blokir Anda di sini
  if (isJailBroken || !isRealDevice || isMockLocation || isDevelopmentModeEnable) {
    _showSecurityDialog(context, isJailBroken, isRealDevice, isMockLocation, isDevelopmentModeEnable);
  }
}

void _showSecurityDialog(BuildContext context, bool jailbroken, bool emulator, bool mock, bool devMode) {
  showDialog(
    context: context,
    barrierDismissible: false, // User tidak bisa menutup dialog dengan klik luar
    builder: (context) => AlertDialog(
      title: const Text("⚠️ Perangkat Tidak Aman"),
      content: Text(
        "Aplikasi tidak dapat dijalankan karena alasan keamanan berikut:\n\n"
        "${jailbroken ? "• Perangkat terdeteksi Root/Jailbreak\n" : ""}"
        "${!emulator ? "• Aplikasi berjalan di Emulator\n" : ""}"
        "${mock ? "• Mock Location (Lokasi Palsu) aktif\n" : ""}"
        "${devMode ? "• Developer Options aktif\n" : ""}"
        "\nSilakan kembalikan perangkat ke kondisi standar untuk menggunakan aplikasi.",
      ),
      actions: [
        TextButton(
          onPressed: () => SystemNavigator.pop(), // Menutup aplikasi secara paksa
          child: const Text("KELUAR APLIKASI"),
        ),
      ],
    ),
  );
}
```

### 📝 Penjelasan Logika:

1.  **`barrierDismissible: false`**: Ini sangat penting agar pengguna tidak bisa sekadar menekan tombol "Back" atau klik di area kosong untuk melewati peringatan.
2.  **`SystemNavigator.pop()`**: Fungsi standar Flutter untuk menutup aplikasi dengan rapi di Android. Untuk iOS, Apple biasanya tidak menyarankan menutup aplikasi secara programatik, namun dalam konteks keamanan, ini sering dilakukan.
3.  **Pesan Dinamis**: Pesan error akan menyesuaikan dengan apa yang dilanggar oleh perangkat pengguna, sehingga mereka tahu apa yang harus diperbaiki (misal: mematikan Developer Options).

---

### Tambahan untuk README.md:
Anda bisa menambahkan bagian ini di bawah bagian penggunaan tadi:

```markdown
### 🛑 Contoh Logika Blokir (Security Enforcement)

Untuk menjaga integritas data, disarankan untuk memblokir akses jika perangkat terdeteksi tidak aman:

```dart
void enforceSecurity() async {
  bool isSafe = await SafeDevice.isSafeDevice;

  if (!isSafe) {
    // Tampilkan dialog peringatan dan tutup aplikasi
    showSecurityAlert();
  }
}
```
---

Apakah Anda ingin saya bantu membuatkan fungsi khusus untuk **deteksi dinamis** yang berjalan di latar belakang selama aplikasi terbuka?