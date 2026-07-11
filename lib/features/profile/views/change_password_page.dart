import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// Import your helper widgets
// import 'path/to/app_button.dart';
// import 'path/to/app_text_field.dart';

// ============================================================================
// CHANGE PASSWORD CONTROLLER
// ============================================================================

import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';


class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscureOldPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  void toggleOldPasswordVisibility() =>
      obscureOldPassword.value = !obscureOldPassword.value;

  void toggleNewPasswordVisibility() =>
      obscureNewPassword.value = !obscureNewPassword.value;

  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> savePassword() async {
    if (oldPasswordController.text.trim().isEmpty) {
      _showError('Please enter your old password');
      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      _showError('Please enter a new password');
      return;
    }

    if (newPasswordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      _showError('Please confirm your new password');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    isLoading.value = true;

    try {
      // TODO: Call your API to change password
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      _showError('Failed to change password');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}


class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFBC9041),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Change Password',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Old Password Field
            _buildWhiteLabel('Enter your old password'),
            const SizedBox(height: 8),
            Obx(() => AppTextField(
              controller: controller.oldPasswordController,
              hintText: 'Old Password',
              obscureText: controller.obscureOldPassword.value,
              suffixIcon: controller.obscureOldPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixIconTap: controller.toggleOldPasswordVisibility,
            )),

            const SizedBox(height: 20),

            // New Password Field
            _buildWhiteLabel('Enter New Password'),
            const SizedBox(height: 8),
            Obx(() => AppTextField(
              controller: controller.newPasswordController,
              hintText: 'New Password',
              obscureText: controller.obscureNewPassword.value,
              suffixIcon: controller.obscureNewPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixIconTap: controller.toggleNewPasswordVisibility,
            )),

            const SizedBox(height: 20),

            // Confirm Password Field
            _buildWhiteLabel('Re-Enter New Password'),
            const SizedBox(height: 8),
            Obx(() => AppTextField(
              controller: controller.confirmPasswordController,
              hintText: 'New Password',
              obscureText: controller.obscureConfirmPassword.value,
              suffixIcon: controller.obscureConfirmPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixIconTap: controller.toggleConfirmPasswordVisibility,
            )),

            const SizedBox(height: 40),

            // Save Button using AppButton
            Obx(() => AppButton(
              buttonText: 'Save',
              onPressed: controller.isLoading.value ? null : controller.savePassword,
              isLoading: controller.isLoading.value,
              fillColor: const Color(0xFFBC9041),
              borderRadius: 26,
              buttonHeight: 52,
            )),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}