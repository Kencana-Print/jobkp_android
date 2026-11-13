class Config {
  // Ambil dari --dart-define, kalau gak ada pakai default (misal localhost)
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://jobkp.manksi.com/api',
    // defaultValue: 'http://localhost:8085/api',
  );
}
