class Config {
  // Ambil dari --dart-define, kalau gak ada pakai default (misal localhost)
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: '',
    // defaultValue: 'http://localhost:8085/api',
  );
}
