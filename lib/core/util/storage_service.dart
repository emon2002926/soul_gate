import 'package:get_storage/get_storage.dart';

import '../user_profile.dart';

import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _languageKey = 'app_language';

  // Access Token
  static Future<void> saveToken(String accessToken) async {
    await _box.write(_tokenKey, accessToken);
  }

  static String? get accessToken => _box.read(_tokenKey);
  static bool get hasToken => accessToken != null && accessToken!.isNotEmpty;

  // Refresh Token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _box.write(_refreshTokenKey, refreshToken);
  }

  static String? get refreshToken => _box.read(_refreshTokenKey);

  // Language Storage
  static Future<void> saveLanguage(String languageCode) async {
    await _box.write(_languageKey, languageCode);
  }

  static String get language => _box.read(_languageKey) ?? 'en'; // Default to English
  static bool get hasLanguage => _box.hasData(_languageKey);

  // Clear methods
  static Future<void> clearToken() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshTokenKey);
  }

  static Future<void> logout() async {
    final savedLanguage = language; // Preserve language preference
    await _box.erase(); // Clear everything
    await saveLanguage(savedLanguage); // Restore language preference
  }
}