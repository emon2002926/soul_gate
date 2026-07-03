import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/reset_pass_controller.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPassController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText(
          data: 'Qube',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Title
                    const AppText(
                      data: 'Create a new\npassword',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    const AppText(
                      data: 'Enter a new password and try not to forget it.',
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.4,
                    ),

                    const SizedBox(height: 40),

                    // New Password Field
                    Obx(() => AppTextField(
                      hintText: "new password",
                      label: "New Password",
                      controller: controller.newPasswordController,
                      suffixIcon: controller.isNewPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      obscureText: !controller.isNewPasswordVisible.value,
                      onSuffixIconTap: controller.toggleNewPasswordVisibility,
                      validator: controller.validateNewPassword,
                      hintTextColor: Colors.white,
                      borderColor: AppColors.instance.primaryBtnColor,
                      fillColor: Colors.transparent,
                      inputTextColor: Colors.white,
                    )),

                    const SizedBox(height: 20),

                    // Confirm Password Field
                    Obx(() => AppTextField(
                      hintText: "re-enter the new password",
                      label: "Confirm Password",
                      controller: controller.confirmPasswordController,
                      suffixIcon: controller.isConfirmPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      onSuffixIconTap: controller.toggleConfirmPasswordVisibility,
                      validator: controller.validateConfirmPassword,
                      hintTextColor: Colors.white,
                      borderColor: AppColors.instance.primaryBtnColor,
                      fillColor: Colors.transparent,
                      inputTextColor: Colors.white,
                    )),

                    const Spacer(),

                    // Continue button
                    Obx(() => AppButton(
                      buttonText: controller.isLoading.value
                          ? 'Updating...'
                          : 'Continue',
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.resetPassword,
                      fontSize: 16,
                      isLoading: controller.isLoading.value,
                    )),



                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Loading overlay
            Obx(() => controller.isLoading.value
                ? Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      AppText(
                        data: 'Updating password...',
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}