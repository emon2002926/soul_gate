import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/core/util/storage_service.dart';
import 'package:soul_gate/features/auth/views/sign_up_screen.dart';
import 'package:soul_gate/features/profile/views/change_password_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/views/sing_in_screen.dart';
import '../views/edit_profile_page.dart';
import '../views/legal_conditions_screen.dart';

class ProfileController extends GetxController {
  // User data
  final userName = ''.obs;
  final userEmail = ''.obs;
  final isPremiumUser = false.obs;
  final profileImageUrl = ''.obs;
  final language = 'en'.obs;
  final isVerified = false.obs;

  // UI state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final token = StorageService.accessToken; // your stored bearer token

      final response = await http.get(
        Uri.parse('https://sofiapi.dsrt321.online/api/auth/profile/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // username can be null -> fall back to email prefix
        final uname = data['name'] as String?;
        userName.value = (uname != null && uname.isNotEmpty)
            ? uname
            : (data['email'] as String? ?? '').split('@').first;

        userEmail.value = data['email'] as String? ?? '';
        isVerified.value = data['is_verified'] as bool? ?? false;
        language.value = data['language'] as String? ?? 'en';

        // No premium field in API; keep false unless your backend adds it
        isPremiumUser.value = false;
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        Get.snackbar('Error', 'Failed to load profile (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleUnauthorized() {
    StorageService.logout();
    AppNavigation.pushAndClear(Get.context!, SingInScreen());
  }

  // Navigation
  void onLanguageChange() {
    Get.snackbar('Language', 'Opening language settings...');
  }

  void onEditProfile() {
    AppNavigation.push(Get.context!, EditProfilePage());
  }

  void onChangePassword() {
    AppNavigation.push(Get.context!, ChangePasswordPage());
  }

  void onAboutUs() {
    Get.snackbar('About Us', 'Opening about page...');
  }

  void onPrivacyPolicy() {
    Get.snackbar('Privacy Policy', 'Opening privacy policy...');
  }

  void onContactUs() {
    AppNavigation.push(Get.context!, LegalConditionsScreen());
  }

  void logUot() {
    StorageService.logout();
    AppNavigation.pushAndClear(Get.context!, SingInScreen());
  }

  void onFAQ() {
    Get.snackbar('FAQ', 'Opening FAQ page...');
  }

  Future<void> openSupportEmail() async {
    final String subject =
    Uri.encodeComponent('Share My Thoughts About the App');
    final Uri emailUri = Uri.parse(
      'mailto:soulgateapp2026@gmail.com?subject=$subject',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showEmailError();
      }
    } catch (e) {
      _showEmailError();
    }
  }

  void _showEmailError() {
    Get.snackbar(
      'Unable to Open Mail',
      'Please email us directly at soulgateapp2026@gmail.com',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }



  Future<void> deleteAccount() async {
    try {
      final token = StorageService.accessToken;

      final response = await http.delete(
        Uri.parse('https://sofiapi.dsrt321.online/api/auth/delete-account/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        StorageService.logout();
        AppNavigation.pushAndClear(Get.context!, SingInScreen());
        Get.snackbar(
          'Account Deleted',
          'Your account has been permanently deleted.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 401) {
        StorageService.logout();
        AppNavigation.pushAndClear(Get.context!, SingInScreen());
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete account (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void confirmDeleteAccount(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE85C4A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE85C4A),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your account? '
              'This action is permanent and cannot be undone. '
              'All your data will be lost.',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed:() {Navigator.pop(context);},
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF8E8E8E)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // close dialog first
              deleteAccount();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Color(0xFFE85C4A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

}