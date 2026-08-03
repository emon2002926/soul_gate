import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/widgets/snakbar/custom_snackbar.dart';

class SignUpController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers - keeping all for UI flexibility
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  // Updated Base URL
  static final String baseUrl = 'https://api.soulgatelight.com/api';

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.trim().length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select your date of birth';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }




  Future<void> submitProfile() async {
    // Validate only email and password (required by API)
    if (fullNameController.text.trim().isEmpty){
      CustomSnackBar.error("Please enter your full name");
      return;
    }
    if (emailController.text.trim().isEmpty) {
      CustomSnackBar.error("Please enter your email");
      return;
    }

    if (validateEmail(emailController.text) != null) {

      CustomSnackBar.error("Please enter a valid email");
      return;
    }

    if (passwordController.text.trim().isEmpty) {

      CustomSnackBar.error("Please enter your password");
      return;
    }

    if (validatePassword(passwordController.text) != null) {
      CustomSnackBar.error("Password must be at least 8 characters");
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/signup/');


      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name' : fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {

        CustomSnackBar.success("Account created successfully! Please login.");

        // Navigate to login screen
        Get.offAllNamed(AppRoutes.otpVerifyPage, arguments: {
          'email': emailController.text.trim(),
          'isFromSignUp': true,
        });
      } else if (response.statusCode == 400) {
        // Handle validation errors
        String errorMessage = 'Failed to create account';

        if (responseData is Map) {
          // Check for specific field errors
          if (responseData.containsKey('email')) {
            errorMessage = responseData['email'][0] ?? 'Email error';
          } else if (responseData.containsKey('password')) {
            errorMessage = responseData['password'][0] ?? 'Password error';
          } else if (responseData.containsKey('message')) {
            errorMessage = responseData['message'];
          }
        }
        CustomSnackBar.error(errorMessage);
      } else {

        CustomSnackBar.error(responseData['message'] ?? 'Failed to create account');
      }
    } catch (e) {

      CustomSnackBar.error("Something went wrong: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}