import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/sign_up_controller.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to extend behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Navigator.of(context).pop(),
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    AppText(
                      data: 'Sign UP',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.titleTextColor,
                      height: 1.0,
                    ),
                    SizedBox(height: 28.h),

                    // Full Name field
                    AppTextField(
                      label: 'Full Name',
                      controller: controller.fullNameController,
                      validator: controller.validateFullName,
                    ),
                    SizedBox(height: 20.h),

                    // Email field
                    AppTextField(
                      label: 'Email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),

                    SizedBox(height: 20.h),

                    Obx(() => AppTextField(
                      label: 'Password',
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onSuffixIconTap: controller.togglePasswordVisibility,
                      validator: controller.validatePassword,
                    )),

                    SizedBox(height: 20.h),

                    Obx(() => AppTextField(
                      label: 'Confirm Password',
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onSuffixIconTap: controller.togglePasswordVisibility,
                    )),

                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const AppText(
                          data: 'I agree to terms & conditions',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),

                    // Create account button
                    Obx(() => AppButton(
                      buttonText: controller.isLoading.value
                          ? 'Creating account...'
                          : 'Create account',
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submitProfile,
                      fillColor: AppColors.instance.primaryBtnColor,
                      buttonHeight: 50,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      isLoading: controller.isLoading.value,
                    )),

                    const SizedBox(height: 20),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(
                          data: 'Already have an account? ',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const AppText(
                            data: 'Sign in',
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}