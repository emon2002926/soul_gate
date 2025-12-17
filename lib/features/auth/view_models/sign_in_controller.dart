import 'package:get/get.dart';
import '../../../core/constants/app_constant.dart';
import '../../../core/onboarding/splash/views/subscription_page.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  static final String baseUrl = 'https://sofiapi.dsrt321.online/api';

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    // Validation
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/login/');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['access'] != null) {
        // Save access token
        final accessToken = responseData['access'];
        await StorageService.saveToken(accessToken);

        // Save refresh token if you need it later
        // final refreshToken = responseData['refresh'];
        // if (refreshToken != null) {
        //   await StorageService.saveRefreshToken(refreshToken);
        // }
        //
        // // Save user data if needed
        // final user = responseData['user'];
        // if (user != null) {
        //   await StorageService.saveUserId(user['id'].toString());
        //   await StorageService.saveUserEmail(user['email']);
        // }

        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Login successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // All users navigate to onboarding serving selection
        AppNavigation.pushAndClear(Get.context!, SubscriptionPage());
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Login failed',
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
}