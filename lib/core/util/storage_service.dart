import 'package:get_storage/get_storage.dart';

import '../user_profile.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userProfileKey = 'user_profile';
  static const _userRoleKey = 'user_role';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';

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

  // User Data
  static Future<void> saveUserId(int userId) async {
    await _box.write(_userIdKey, userId);
  }

  static int? get userId => _box.read(_userIdKey);

  static Future<void> saveUserEmail(String email) async {
    await _box.write(_userEmailKey, email);
  }

  static String? get userEmail => _box.read(_userEmailKey);

  // User Role
  static Future<void> saveUserRole(String role) async {
    await _box.write(_userRoleKey, role);
  }

  static String? get userRole => _box.read(_userRoleKey);

  // User Profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    await _box.write(_userProfileKey, profile.toJson());
  }

  static UserProfile? get userProfile {
    final data = _box.read(_userProfileKey);
    if (data != null) {
      return UserProfile.fromJson(data);
    }
    return null;
  }

  // Clear methods
  static Future<void> clearToken() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshTokenKey);
  }

  static Future<void> clearUserProfile() async {
    await _box.remove(_userProfileKey);
  }

  static Future<void> clearUserRole() async {
    await _box.remove(_userRoleKey);
  }

  static Future<void> logout() async {
    await _box.erase(); // Clear everything
  }
}