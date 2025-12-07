import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/features/profile/views/change_password_page.dart';

import '../views/edit_profile_page.dart';
import '../views/legal_conditions_screen.dart';

class ProfileController extends GetxController {
  // User data
  final userName = 'Amelia'.obs;
  final userEmail = 'amelia1234@gmail.com'.obs;
  final isPremiumUser = true.obs;
  final profileImageUrl = ''.obs;

  // Navigation
  void onLanguageChange() {
    // Navigate to language settings
    Get.snackbar('Language', 'Opening language settings...');
  }

  void onEditProfile() {
    // Navigate to edit profile
    AppNavigation.push(Get.context!, EditProfilePage());
  }

  void onChangePassword() {
    // Navigate to change password
    AppNavigation.push(Get.context!, ChangePasswordPage());
  }

  void onAboutUs() {
    // Navigate to about us
    Get.snackbar('About Us', 'Opening about page...');
  }

  void onPrivacyPolicy() {
    // Navigate to privacy policy
    Get.snackbar('Privacy Policy', 'Opening privacy policy...');
  }

  void onContactUs() {
    // Navigate to contact us
    AppNavigation.push(Get.context!, LegalConditionsScreen());
  }

  void onFAQ() {
    // Navigate to FAQ
    Get.snackbar('FAQ', 'Opening FAQ page...');
  }

  void onLogout() {
    // Handle logout
    Get.dialog(
      GetBuilder<ProfileController>(
        builder: (_) => const SizedBox(), // Replace with actual dialog
      ),
    );
  }
}