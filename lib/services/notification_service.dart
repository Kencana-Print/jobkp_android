// lib/services/notification_service.dart

// Secara default memuat berkas stub (Web aman)
export 'notification_stub.dart'
    // Jika compiler mendeteksi pustaka io (Mobile), alihkan ke berkas mobile
    if (dart.library.io) 'notification_mobile.dart';
