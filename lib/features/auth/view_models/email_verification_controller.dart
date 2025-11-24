import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/routes/app_routes.dart';

class EmailVerificationController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  // Timer for resend countdown
  Timer? resendTimer;
  final resendCountdown = 0.obs;
  final isLoading = false.obs;
  final hasCodeBeenSent = false.obs;

  static final String baseUrl = AppConstant.instance.baseUrl;

  void startResendCountdown(int seconds) {
    resendCountdown.value = seconds;
    resendTimer?.cancel();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> sendVerificationCode() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email address",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/forgot-password/send-reset-code');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        hasCodeBeenSent.value = true;
        startResendCountdown(60); // 1 minute countdown

        // Show success message
        String message = responseData['message'] ?? 'Password reset code sent to ${emailController.text}';

        Get.snackbar(
          "Success",
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );

        // Navigate to OTP verification
        continueToOtpVerification();
      } else {
        // Handle error response
        Get.snackbar(
          "Error",
          responseData['message'] ?? 'Failed to send verification code',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (resendCountdown.value > 0) {
      Get.snackbar(
        "Please Wait",
        "You can resend code in ${resendCountdown.value} seconds",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/forgot-password/send-reset-code');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        startResendCountdown(60); // 1 minute countdown for next resend

        // Show success message
        String message = responseData['message'] ?? 'Password reset code resent to ${emailController.text}';

        Get.snackbar(
          "Code Sent",
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );

        // Optionally navigate to OTP verification again
        continueToOtpVerification();
      } else {
        Get.snackbar(
          "Error",
          responseData['message'] ?? 'Failed to resend code',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> continueToOtpVerification() async {
    // Navigate to OTP verification with context
    bool isFromSignUp = false;
    Get.toNamed(
      AppRoutes.otpVerifyPage,
      arguments: {
        "isFromSignUp": isFromSignUp,
        "email": emailController.text.trim(),
      },
    );
  }

  @override
  void onClose() {
    resendTimer?.cancel();
    emailController.dispose();
    super.onClose();
  }
}