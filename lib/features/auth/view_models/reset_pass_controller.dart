import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/constants/app_constant.dart';
import '../../../core/routes/app_routes.dart';

class ResetPassController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final email = ''.obs;
  final otp = ''.obs;

  // Updated Base URL
  // static final String baseUrl = 'https://sofiapi.dsrt321.online/api';

  @override
  void onInit() {
    super.onInit();
    // Get arguments passed from OTP verification screen
    final args = Get.arguments;
    if (args != null) {
      email.value = args['email'] ?? '';
      otp.value = args['otp'] ?? '';
    }
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter new password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> resetPassword() async {
    // Validate passwords
    if (newPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter new password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please confirm your password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (email.value.isEmpty || otp.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Missing email or OTP. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('${AppConstant.instance.baseUrl}/auth/reset-password/');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.value,
          'otp': otp.value,
          'new_password': newPasswordController.text.trim(),
          'confirm_password': confirmPasswordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Password reset successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to login screen after successful password reset
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(AppRoutes.login);
      } else {
        // Handle error response
        String errorMessage = 'Failed to reset password';

        if (responseData is Map) {
          // Check for specific field errors
          if (responseData.containsKey('new_password')) {
            errorMessage = responseData['new_password'][0] ?? 'Password error';
          } else if (responseData.containsKey('confirm_password')) {
            errorMessage = responseData['confirm_password'][0] ?? 'Password confirmation error';
          } else if (responseData.containsKey('otp')) {
            errorMessage = responseData['otp'][0] ?? 'Invalid or expired OTP';
          } else if (responseData.containsKey('email')) {
            errorMessage = responseData['email'][0] ?? 'Email error';
          } else if (responseData.containsKey('message')) {
            errorMessage = responseData['message'];
          }
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}