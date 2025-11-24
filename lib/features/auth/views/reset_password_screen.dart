import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/reset_pass_controller.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPassController());
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFCCC6C3),
      appBar: AppBar(
        backgroundColor: Color(0xFFCCC6C3),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Title - matching screenshot
                const AppText(
                  data: 'Create a new\npassword',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),

                const SizedBox(height: 16),

                // Subtitle - matching screenshot
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
                  controller: controller.newPasswordController,
                  suffixIcon: controller.isNewPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  obscureText: !controller.isNewPasswordVisible.value,
                  borderColor: Colors.transparent,
                  onSuffixIconTap: controller.toggleNewPasswordVisibility,
                  validator: controller.validateNewPassword,
                )),

                const SizedBox(height: 20),

                // Confirm Password Field
                Obx(() => AppTextField(
                  hintText: "re-enter the new password",
                  controller: controller.confirmPasswordController,
                  suffixIcon: controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  borderColor: Colors.transparent,
                  onSuffixIconTap: controller.toggleConfirmPasswordVisibility,
                  validator: controller.validateConfirmPassword,
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
                  fillColor: const Color(0xffE0E0E0),
                  textColor: Colors.black,
                  borderRadius: 12,
                  buttonHeight: 56,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  isLoading: controller.isLoading.value,
                )),

                const SizedBox(height: 40),
              ],
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
    );
  }
}