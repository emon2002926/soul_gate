import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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

  void logUot() {
    // Navigate to contact us
    StorageService.logout();
    AppNavigation.pushAndClear(Get.context!,SingInScreen());
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




  Future<void> openSupportEmail() async {
    final String subject = Uri.encodeComponent('Share My Thoughts About the App');
    final String body = Uri.encodeComponent(
      'Hello,\n\n'
          'I would like to share my thoughts about the app:\n\n'
          '• What I love:\n\n'
          '• What could be improved:\n\n'
          '• Any other feedback:\n\n'
          'Thank you for creating this experience.\n\n'
          'Warm regards,',
    );

    final Uri emailUri = Uri.parse(
      'mailto:support23@gmail.com?subject=$subject',
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
      'Please email us directly at support23@gmail.com',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }
}