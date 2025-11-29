import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soul_gate/core/constants/app_assert_image.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/features/auth/views/sign_up_screen.dart';
import 'package:soul_gate/features/auth/views/verify_email_screen.dart';
import '../../../core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/sign_in_controller.dart';

class SingInScreen extends StatelessWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

    return Scaffold(
      body: Stack(
         fit: StackFit.expand, // Add this

        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssertImage.instance.appBackground,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h),
                    // Title
                    AppText(
                      data: 'Sign In',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.titleTextColor,
                      height: 1.0,
                    ),

                    SizedBox(height: 40.h),
                    // Email field
                    AppTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      controller: controller.emailController,
                      hintTextColor: Colors.white,
                      borderColor: AppColors.instance.primaryBtnColor,
                      fillColor: Colors.transparent,
                    ),

                    SizedBox(height: 24.h),

                    // Password field
                    Obx(() => AppTextField(
                      label: 'Password',
                      label2: 'Forgot Password?',
                      hintText: 'Enter your Password',
                      label2OnClick: () {
                        AppNavigation.push(context, EmailVerificationPage());
                      },
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onSuffixIconTap: controller.togglePasswordVisibility,
                      hintTextColor: Colors.white,
                      borderColor: AppColors.instance.primaryBtnColor,
                      fillColor: Colors.transparent,
                    )),

                    SizedBox(height: 16.h),

                    SizedBox(height: 32.h),

                    Obx(() => AppButton(
                      buttonText: controller.isLoading.value ? 'Loading...' : 'Log in',
                      onPressed: controller.isLoading.value ? null : controller.login,
                      fillColor: AppColors.instance.primaryBtnColor,
                      borderRadius: 25,
                      buttonHeight: 50,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.instance.btnTextColor,
                    )),

                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(
                          data: 'Don\'t have an account? ',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppNavigation.push(context, SignUpScreen());
                          },
                          child: const AppText(
                            data: 'Sign up',
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}