# Latihan Firebase — Auth & Cloud Messaging (FCM)

Proyek Flutter untuk praktikum **Firebase Authentication** dan **Firebase Cloud Messaging (Push Notification)** — Pertemuan 9.

- **Nama:** Fikri Bintang Purnomo
- **NIM:** `1122140142`
- **Kelas:** `TI 24 SH SE`
- **Firebase Display Name:** `flutter-project-malam`
- **Firebase Project ID:** `macha-umkm` (`Sender ID: 194613325888`)

## Fitur
- Login & Logout dengan Firebase Authentication (`AuthWrapper` berbasis `authStateChanges`)
- Opsi **Ingat saya** & toggle show/hide password
- Penanganan notifikasi FCM pada 3 kondisi aplikasi:
  - **Foreground** (`flutter_local_notifications` dengan channel `high_importance_channel`)
  - **Background** (`FirebaseMessaging.onMessageOpenedApp`)
  - **Terminated** (`FirebaseMessaging.instance.getInitialMessage()`)
- Halaman **Detail Notifikasi** (`NotificationDetailScreen`) lengkap dengan ikon khusus promo (`Icons.shopping_cart_rounded` untuk `kategori: promo`)
- Kartu **FCM Token** (`FcmTokenCard`) dengan tombol Salin Token, Refresh, dan toggle **Subscribe / Unsubscribe** topic `kelas`
- Postman Collection siap pakai di [`postman/FCM_Postman_Collection.json`](postman/FCM_Postman_Collection.json)

## Menjalankan Proyek
```bash
flutter pub get
flutter run
```
