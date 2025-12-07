import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controller/edit_profile_controller.dart';


class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFBC9041),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          }
          ,
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
            // Optional: Add a dark overlay for better text readability
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Profile Image Section
                Center(child: _buildProfileImage(controller)),

                const SizedBox(height: 32),

                // Name Field
                _buildWhiteLabel('Name'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: controller.nameController,
                  hintText: 'Enter your name',
                  keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                // Email Field
                _buildWhiteLabel('Email'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: controller.emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // Mobile Field
                _buildWhiteLabel('Mobile'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: controller.mobileController,
                  hintText: 'Enter your mobile number',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 40),

                // Save Button using AppButton
                Obx(() => AppButton(
                  buttonText: 'Save',
                  onPressed: controller.isLoading.value ? null : controller.saveProfile,
                  isLoading: controller.isLoading.value,
                  fillColor: const Color(0xFFBC9041),
                  borderRadius: 26,
                  buttonHeight: 52,
                )),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// White label for dark backgrounds (since AppTextField has dark label)
  Widget _buildWhiteLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProfileImage(EditProfileController controller) {
    return Stack(
      children: [
        Obx(() => Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: _getProfileImage(controller),
          ),
        )),

        // Camera Button
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: controller.showImagePickerOptions,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFBC9041),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getProfileImage(EditProfileController controller) {
    if (controller.selectedImagePath.value.isNotEmpty) {
      return Image.file(
        File(controller.selectedImagePath.value),
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    }

    if (controller.profileImageUrl.value.isNotEmpty) {
      return Image.network(
        controller.profileImageUrl.value,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 60, color: Colors.grey[500]),
    );
  }
}