import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soul_gate/core/widgets/snackbar/custome_snackbar.dart';
class EditProfileController extends GetxController {
  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  // Profile Image
  final profileImageUrl = ''.obs;
  final selectedImagePath = ''.obs;
  final isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Load existing user data
    _loadUserData();
  }

  void _loadUserData() {
    // TODO: Load from your user service/repository
    nameController.text = 'Kurt Cobain';
    emailController.text = 'Kurtcobain@email.com';
    mobileController.text = '+8800045154545';
    // profileImageUrl.value = 'user_image_url';
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to pick image',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      CustomeSnackbar.error('Failed to pick image');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to capture image',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      CustomeSnackbar.error('Failed to capture image');
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFBC9041).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_library_rounded,
                  color: Color(0xFFBC9041),
                ),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFBC9041).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Color(0xFFBC9041),
                ),
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> saveProfile() async {
    // Validate inputs
    if (nameController.text.trim().isEmpty) {
      // Get.snackbar(
      //   'Error',
      //   'Please enter your name',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      CustomeSnackbar.error('Please enter your name');
      return;
    }

    if (emailController.text.trim().isEmpty) {
      // Get.snackbar(
      //   'Error',
      //   'Please enter your email',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      CustomeSnackbar.error('Please enter your email');
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      // Get.snackbar(
      //   'Error',
      //   'Please enter a valid email',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      CustomeSnackbar.error('Please enter a valid email');
      return;
    }

    isLoading.value = true;

    try {
      // TODO: Call your API to update profile
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay

      // Get.snackbar(
      //   'Success',
      //   'Profile updated successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
      CustomeSnackbar.success('Profile updated successfully');

      Get.back(); // Navigate back to profile page
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to update profile',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      CustomeSnackbar.error('Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}