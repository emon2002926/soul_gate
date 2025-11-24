import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';

import '../user_profile.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'access_token';
  static const _userProfileKey = 'user_profile';
  static const _userRoleKey = 'user_role';

  static Future<void> saveToken(String accessToken) async {
    await _box.write(_tokenKey, accessToken);
  }

  static String? get accessToken => _box.read(_tokenKey);

  static bool get hasToken => accessToken != null && accessToken!.isNotEmpty;

  static Future<void> clearToken() async {
    await _box.remove(_tokenKey);
  }

  // Save user role
  static Future<void> saveUserRole(String role) async {
    await _box.write(_userRoleKey, role);
  }

  // Get user role
  static String? get userRole => _box.read(_userRoleKey);

  // Clear user role
  static Future<void> clearUserRole() async {
    await _box.remove(_userRoleKey);
  }

  // Save user profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    await _box.write(_userProfileKey, profile.toJson());
  }

  // Get user profile
  static UserProfile? get userProfile {
    final data = _box.read(_userProfileKey);
    if (data != null) {
      return UserProfile.fromJson(data);
    }
    return null;
  }

  // Clear user profile
  static Future<void> clearUserProfile() async {
    await _box.remove(_userProfileKey);
  }

  static Future<void> logout() async {
    await clearToken();
    await clearUserProfile();
    await clearUserRole();
  }
}