import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../core/onboarding/splash/views/onboarding_screen.dart';
import '../../subscription/views/subscription_page.dart';
import '../../../core/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../../core/util/storage_service.dart';
import '../../../core/util/app_log.dart';


class OtpVerificationController extends GetxController {
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;
  final email = ''.obs;
  final isFromSignUp = false.obs;
  final resendCountdown = 0.obs;
  Timer? resendTimer;

  // Updated Base URL
  static final String baseUrl = 'https://api.soulgatelight.com/api';

  @override
  void onInit() {
    super.onInit();
    // Get arguments passed from previous screen
    final args = Get.arguments;
    if (args != null) {
      email.value = args['email'] ?? '';
      isFromSignUp.value = args['isFromSignUp'] ?? false;
    }

    // Start countdown timer when controller is initialized
    startResendCountdown(60);
  }

  String get otpCode =>
      otpControllers.map((controller) => controller.text).join();

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

  void onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  // Main verify method that routes to correct verification
  Future<void> verifyCode() async {
    if (isFromSignUp.value) {
      await signupVerifyCode();
    } else {
      await resetPassVerifyCode();
    }
  }

  // Signup email verification
  Future<void> signupVerifyCode() async {
    // Validate OTP length
    if (otpCode.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter the complete 6-digit code.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate email
    if (email.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Email not found. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/verify-otp/');

      final bodyData = {
        "email": email.value,
        "otp": otpCode,
        "otp_type": "signup"
      };

      AppLog.request(url.toString(), body: bodyData);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      final responseData = jsonDecode(response.body);
      AppLog.response(url.toString(), responseData);

      if (response.statusCode == 200 && responseData['access'] != null) {
        // Cancel timer on successful verification
        resendTimer?.cancel();

        // Save access token
        final accessToken = responseData['access'];
        await StorageService.saveToken(accessToken);

        // Save refresh token
        final refreshToken = responseData['refresh'];
        if (refreshToken != null) {
          await StorageService.saveRefreshToken(refreshToken);
        }

        Get.snackbar(
          "Success",
          responseData['message'] ?? "Email verified successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );

        // Navigate to onboarding serving selection (default for all users)
        AppNavigation.pushAndClear(Get.context!, OnboardingScreen());
      } else {
        // Handle error response
        Get.snackbar(
          "Error",
          _extractErrorMessage(responseData, 'Invalid or expired OTP code'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password verification
  Future<void> resetPassVerifyCode() async {
    // Validate OTP length
    if (otpCode.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter the complete 6-digit code.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate email
    if (email.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Email not found. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/verify-otp/');

      final bodyData = {
        'email': email.value,
        'otp': otpCode,
        'otp_type': 'reset',
      };

      AppLog.request(url.toString(), body: bodyData);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      final responseData = jsonDecode(response.body);
      AppLog.response(url.toString(), responseData);

      if (response.statusCode == 200) {
        // Cancel timer on successful verification
        resendTimer?.cancel();

        Get.snackbar(
          "Success",
          responseData['message'] ?? "Code verified!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );

        // Navigate to reset password page
        Get.toNamed(
          AppRoutes.resetPassword,
          arguments: {
            'email': email.value,
            'otp': otpCode,
          },
        );
      } else {
        // Handle error response
        Get.snackbar(
          "Error",
          _extractErrorMessage(responseData, 'Invalid or expired OTP code'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Main resend method that routes to correct resend
  Future<void> resendOtp() async {
    if (isFromSignUp.value) {
      await signupResendOtp();
    } else {
      await resetPassResendOtp();
    }
  }

  // Resend OTP for signup
  Future<void> signupResendOtp() async {
    // Check if countdown is still running
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

    if (email.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Email not found. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/resend-otp/');

      final bodyData = {
        'email': email.value,
        'otp_type': 'signup',
      };

      AppLog.request(url.toString(), body: bodyData);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      final responseData = jsonDecode(response.body);
      AppLog.response(url.toString(), responseData);

      if (response.statusCode == 200) {
        // Start countdown timer
        startResendCountdown(60);

        Get.snackbar(
          "OTP Sent",
          responseData['message'] ?? "Verification code resent to your email.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );

        // Clear existing OTP fields
        for (var controller in otpControllers) {
          controller.clear();
        }
        // Focus on first field
        focusNodes[0].requestFocus();
      } else {
        Get.snackbar(
          "Error",
          _extractErrorMessage(responseData, 'Failed to resend OTP'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP for password reset
  Future<void> resetPassResendOtp() async {
    // Check if countdown is still running
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

    if (email.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Email not found. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/resend-otp/');

      final bodyData = {
        'email': email.value,
        'otp_type': 'reset',
      };

      AppLog.request(url.toString(), body: bodyData);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      final responseData = jsonDecode(response.body);
      AppLog.response(url.toString(), responseData);

      if (response.statusCode == 200) {
        // Start countdown timer
        startResendCountdown(60);

        Get.snackbar(
          "OTP Sent",
          responseData['message'] ?? "Password reset code resent to your email.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );

        // Clear existing OTP fields
        for (var controller in otpControllers) {
          controller.clear();
        }
        // Focus on first field
        focusNodes[0].requestFocus();
      } else {
        Get.snackbar(
          "Error",
          _extractErrorMessage(responseData, 'Failed to resend OTP'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
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
    resendTimer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  String _extractErrorMessage(dynamic responseData, String defaultMessage) {
    if (responseData is Map) {
      if (responseData.containsKey('detail')) return responseData['detail'];
      if (responseData.containsKey('message')) return responseData['message'];
      if (responseData.containsKey('error')) return responseData['error'];
    }
    return defaultMessage;
  }
}





