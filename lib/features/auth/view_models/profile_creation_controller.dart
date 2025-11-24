import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_routes.dart';

class ProfileCreationController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final profileImage = Rx<File?>(null);

  // Validation methods
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
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

  // Image picker methods
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

  // Date picker method
  Future<void> selectDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // 18 years ago
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

  // Address picker method (placeholder for now)
  void selectAddress() {
    // This would typically open a location picker or address selection screen
    Get.snackbar(
      "Info",
      "Address picker coming soon",
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
    );
  }

  // Form submission
  Future<void> submitProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create profile data
      final profileData = {
        'fullName': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'dateOfBirth': dobController.text.trim(),
        'address': addressController.text.trim(),
        'profileImage': profileImage.value?.path,
      };

      print('Profile Data: $profileData');

      Get.snackbar(
        "Success",
        "Profile created successfully!",
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );

      // Navigate to next screen (dashboard, verification, etc.)
      Get.offAllNamed(AppRoutes.onboardingServingSelection);

    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create profile. Please try again.",
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
    phoneController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.onClose();
  }
}