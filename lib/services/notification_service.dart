import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart'; // Wajib untuk mendeteksi kIsWeb

class NotificationService {
  // Kita buat tipenya dinamis menggunakan kata kunci 'var' atau 'dynamic'
  // agar compiler Web tidak memvalidasi constructor internal kelas mobile ini.
  final dynamic _notificationsPlugin = kIsWeb
      ? null
      : FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) {
      print(
        "Aplikasi berjalan di Web: Inisialisasi notifikasi mobile dilewati.",
      );
      return;
    }

    // Kode di bawah ini dijamin hanya dibaca di platform Mobile (Android/iOS) secara runtime
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);

    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    print("Izin Notifikasi Mobile Diberikan: $result");
  }

  Future<void> showNotification(int id, String title, String body) async {
    if (kIsWeb) {
      print("Aplikasi berjalan di Web: Notifikasi lokal diabaikan.");
      return;
    }

    // Kode di bawah ini dijamin hanya dieksekusi di platform Mobile secara runtime
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'jobkp_channel_id',
          'JobKP Notifications',
          channelDescription: 'Notifikasi untuk status pekerjaan JobKP',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_notification',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    print("Mencoba menampilkan notifikasi: $title");
    await _notificationsPlugin.show(id, title, body, notificationDetails);
    print("Perintah showNotification selesai.");
  }
}
