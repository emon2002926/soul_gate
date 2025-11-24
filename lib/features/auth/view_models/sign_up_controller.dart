import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constant.dart';
import '../../../core/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SignUpController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController(); // Add email controller
  final passwordController = TextEditingController(); // Add password controller
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  final isLoading = false.obs;
  final profileImage = Rx<File?>(null);
  final isPasswordVisible = false.obs; // Add password visibility

  final genderList = ['Male', 'Female', 'Other'];
  final selectedGender = ''.obs;

  // Base URL - Replace with your actual API base URL
  static final String baseUrl = AppConstant.instance.baseUrl;

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
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
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

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image from gallery",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to take photo",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate:
      DateTime.now().subtract(const Duration(days: 365 * 18)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[800]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  void selectAddress() {
    Get.snackbar(
      "Info",
      "Address picker coming soon",
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
    );
  }

  // Convert date from dd/MM/yyyy to yyyy-MM-dd format for API
  String _convertDateFormat(String date) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  Future<void> submitProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select your gender',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/auth/email/signup');

      // Convert date format from dd/MM/yyyy to yyyy-MM-dd
      final formattedDate = _convertDateFormat(dobController.text.trim());

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'phone': phoneController.text.trim(),
          'date_of_birth': formattedDate,
          'gender': selectedGender.value,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success'] == true) {
        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Please check your email for verification code',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );

        // Navigate to verification or login screen
        Get.offAllNamed(AppRoutes.otpVerifyPage, arguments: {
          'email': emailController.text.trim(),
          'isFromSignUp': true,
        });
      } else {
        // Handle error response
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Failed to create account',
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
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.onClose();
  }
}