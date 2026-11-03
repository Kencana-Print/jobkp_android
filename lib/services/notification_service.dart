import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart'; // Wajib ada untuk membaca kIsWeb

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Jika aplikasi berjalan di Web, lewati inisialisasi notifikasi mobile
    if (kIsWeb) {
      print(
        "Aplikasi berjalan di Web: Melewati inisialisasi notifikasi lokal.",
      );
      return;
    }

    // Kode di bawah ini hanya akan dieksekusi di platform Mobile (Android/iOS)
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

    // Minta Izin Notifikasi (Hanya untuk Android 13+)
    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    print("Izin Notifikasi Diberikan: $result");
  }

  Future<void> showNotification(int id, String title, String body) async {
    // Jika aplikasi berjalan di Web, batalkan perintah menampilkan notifikasi lokal
    if (kIsWeb) {
      print("Aplikasi berjalan di Web: Notifikasi lokal diabaikan.");
      return;
    }

    // Kode di bawah ini hanya dieksekusi di platform Mobile
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
