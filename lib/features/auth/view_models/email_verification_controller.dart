import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/routes/app_routes.dart';
import '../../../core/util/app_log.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';



class EmailVerificationController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  Timer? resendTimer;
  final resendCountdown = 0.obs;
  final isLoading = false.obs;
  final hasCodeBeenSent = false.obs;

  static final String baseUrl = 'https://api.soulgatelight.com/api';
  static const String _endpoint = '/auth/forgot-password/';

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
    final email = emailController.text.trim();

    if (email.isEmpty) {
      CustomSnackBar.error("Please enter your email address");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      CustomSnackBar.error("Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl$_endpoint');
      final body = {'email': email};

      AppLog.request(_endpoint, body: body);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(_endpoint, responseData);

        hasCodeBeenSent.value = true;
        startResendCountdown(60);

        CustomSnackBar.success(responseData['message'] ?? 'OTP sent to your email');
        continueToOtpVerification();
      } else {
        AppLog.error(_endpoint, responseData, statusCode: response.statusCode);
        CustomSnackBar.error(responseData['message'] ?? 'Failed to send verification code');
      }
    } catch (e) {
      AppLog.error(_endpoint, e.toString());
      CustomSnackBar.error("Something went wrong: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (resendCountdown.value > 0) {
      CustomSnackBar.warning("You can resend code in ${resendCountdown.value} seconds");
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl$_endpoint');
      final body = {'email': emailController.text.trim()};

      AppLog.request(_endpoint, body: body);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(_endpoint, responseData);

        startResendCountdown(60);
        CustomSnackBar.success(responseData['message'] ?? 'OTP sent to your email');
        continueToOtpVerification();
      } else {
        AppLog.error(_endpoint, responseData, statusCode: response.statusCode);
        CustomSnackBar.error(responseData['message'] ?? 'Failed to resend code');
      }
    } catch (e) {
      AppLog.error(_endpoint, e.toString());
      CustomSnackBar.error("Something went wrong: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void continueToOtpVerification() {
    Get.toNamed(
      AppRoutes.otpVerifyPage,
      arguments: {
        "isFromSignUp": false,
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