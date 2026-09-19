
import 'package:get/get.dart';
import 'package:soul_gate/core/onboarding/splash/views/onboarding_screen.dart';
import 'package:soul_gate/core/util/app_log.dart';
import 'package:soul_gate/core/widgets/snakbar/custom_snackbar.dart';
import '../../subscription/views/subscription_page.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class LoginController extends GetxController {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

    static final String baseUrl = 'https://api.soulgatelight.com/api';

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
      CustomSnackBar.error("Please enter your email");

      return;
    }

    if (passwordController.text.trim().isEmpty) {
      CustomSnackBar.error('Please enter your password');
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/login/');

      final bodyData = {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'remember_me': true,
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
        // Save access token
        final accessToken = responseData['access'];
        await StorageService.saveToken(accessToken);
        clearFields();
        // Save refresh token
        final refreshToken = responseData['refresh'];
        if (refreshToken != null) {
          await StorageService.saveRefreshToken(refreshToken);
        }
        
        // Save user data if needed
        // final user = responseData['user'];
        // if (user != null) {
        //   await StorageService.saveUserId(user['id'].toString());
        //   await StorageService.saveUserEmail(user['email']);
        // }

        CustomSnackBar.success("Login successful");
        // All users navigate to onboarding serving selection
        AppNavigation.pushAndClear(Get.context!, OnboardingScreen());
      } else {
        clearFields();
        String errorMessage = 'Login failed';
        if (responseData is Map) {
          if (responseData.containsKey('email')) {
            errorMessage = responseData['email'][0] ?? 'Email error';
          } else if (responseData.containsKey('password')) {
            errorMessage = responseData['password'][0] ?? 'Password error';
          } else if (responseData.containsKey('non_field_errors')) {
            errorMessage = responseData['non_field_errors'][0] ?? 'Login failed';
          } else if (responseData.containsKey('detail')) {
            errorMessage = responseData['detail'];
          } else if (responseData.containsKey('message')) {
            errorMessage = responseData['message'];
          } else if (responseData.containsKey('error')) {
            errorMessage = responseData['error'];
          }
        }
        CustomSnackBar.error(errorMessage);
      }
    } catch (e) {
      clearFields();
      CustomSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  void clearFields (){

    emailController.clear();
    passwordController.clear();

  }
}