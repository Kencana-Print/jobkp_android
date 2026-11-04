import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final _storage = const FlutterSecureStorage();

  // Kunci-kunci penyimpanan
  static const _keyToken = 'jwt_token';
  static const _keyUserKode = 'user_kode';
  static const _keyNama = 'user_nama';
  static const _keyDivisi = 'user_divisi';
  static const _keyCabang = 'user_cabang';
  static const _keyUserBag = 'user_bag'; // Ini adalah role (zlog)
  static const _keyManager = 'manager';
  static const _keyIT = 'it';
  static const _keyBrg = 'brg';
  static const _keytTeknisi = 'kode_teknisi';

  Future<void> _write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      return;
    }
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    try {
      return await _storage.read(key: key);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  Future<void> _deleteAll() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
      await prefs.remove(_keyUserKode);
      await prefs.remove(_keyNama);
      await prefs.remove(_keyDivisi);
      await prefs.remove(_keyCabang);
      await prefs.remove(_keyUserBag);
      await prefs.remove(_keyManager);
      await prefs.remove(_keyIT);
      await prefs.remove(_keyBrg);
      await prefs.remove(_keytTeknisi);
      return;
    }
    try {
      await _storage.deleteAll();
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
      await prefs.remove(_keyUserKode);
      await prefs.remove(_keyNama);
      await prefs.remove(_keyDivisi);
      await prefs.remove(_keyCabang);
      await prefs.remove(_keyUserBag);
      await prefs.remove(_keyManager);
      await prefs.remove(_keyIT);
      await prefs.remove(_keyBrg);
      await prefs.remove(_keytTeknisi);
    }
  }

  /// Menyimpan data sesi setelah login berhasil
  Future<void> createSession(Map<String, dynamic> loginData) async {
    final user = loginData['user'] as Map<String, dynamic>?;
    final token = loginData['token'] as String?;

    if (user == null || token == null) {
      throw Exception('Data login tidak valid dari server.');
    }

    await _write(_keyToken, token);
    await _write(_keyUserKode, user['user_kode']?.toString() ?? '');
    await _write(_keyNama, user['nama']?.toString() ?? '');
    await _write(_keyDivisi, user['divisi']?.toString() ?? '');
    await _write(_keyCabang, user['cabang']?.toString() ?? '');
    await _write(_keyUserBag, user['user_bag']?.toString() ?? '0');
    await _write(_keyManager, user['manager']?.toString() ?? '0');
    await _write(_keyIT, user['it']?.toString() ?? '0');
    await _write(_keyBrg, user['brg']?.toString() ?? '0');
    await _write(_keytTeknisi, user['kode_teknisi']?.toString() ?? '');
  }

  /// Mengambil semua data user yang tersimpan
  Future<Map<String, String?>> getUserData() async {
    return {
      'token': await _read(_keyToken),
      'user_kode': await _read(_keyUserKode),
      'nama': await _read(_keyNama),
      'divisi': await _read(_keyDivisi),
      'cabang': await _read(_keyCabang),
      'user_bag': await _read(_keyUserBag),
      'manager': await _read(_keyManager),
      'it': await _read(_keyIT),
      'brg': await _read(_keyBrg),
      'kode_teknisi': await _read(_keytTeknisi),
    };
  }

  /// Mengambil role (user_bag) sebagai integer
  Future<int> getRole() async {
    final roleString = await _read(_keyUserBag);
    return int.tryParse(roleString ?? '0') ?? 0;
  }

  /// Mengambil kode teknisi
  Future<String?> getTechnicianCode() async {
    return await _read(_keytTeknisi);
  }

  /// Mengambil kode cabang
  Future<String?> getBranchCode() async {
    return await _read(_keyCabang);
  }

  /// Mengambil user_kode (untuk fallback teknisi)
  Future<String?> getUserKode() async {
    return await _read(_keyUserKode);
  }

  /// Mengambil divisi
  Future<String?> getDivisi() async {
    return await _read(_keyDivisi);
  }

  Future<String?> getToken() async => await _read(_keyToken);
  Future<void> logout() async => await _deleteAll();
}
