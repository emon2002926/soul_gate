import 'package:get_storage/get_storage.dart';
class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'token';
  static const _refreshKey = 'refresh';

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _box.write(_tokenKey, accessToken);
    await _box.write(_refreshKey, refreshToken);
  }

  static String? get accessToken => _box.read(_tokenKey);
  static String? get refreshToken => _box.read(_refreshKey);
  static bool get hasToken => accessToken != null && accessToken!.isNotEmpty;

  static Future<void> clearTokens() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshKey);
  }


  static Future<void> clearAllData() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshKey);
  }

  static Future<void> saveLoginData({
    required String accessToken,
    required String refreshToken,
    required bool drivingLicense,
  }) async {
    await saveTokens(accessToken, refreshToken);
  }
  static Future<void> logout() async {
    await clearAllData();
  }


}