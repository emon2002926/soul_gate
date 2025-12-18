import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soul_gate/core/constants/app_assert_image.dart';
import 'package:soul_gate/features/auth/views/sign_up_screen.dart';
import 'package:soul_gate/features/auth/views/verify_email_screen.dart';
import '../../../core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/sign_in_controller.dart';

class SingInScreen extends StatelessWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Initialize controller ONCE
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssertImage.instance.appBackground,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h),

                    AppText(
                      data: 'Sign In',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.titleTextColor,
                      height: 1.0,
                    ),

                    SizedBox(height: 40.h),

                    // Email Field
                    AppTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      controller: controller.emailController,
                      hintTextColor: Colors.white,
                      borderColor: AppColors.instance.primaryBtnColor,
                      fillColor: Colors.transparent,
                      inputTextColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 24.h),

                    // Password Field
                    Obx(() => AppTextField(
                      label: 'Password',
                      label2: 'Forgot Password?',
                      hintText: 'Enter your Password',
                      label2OnClick: () {
                        Get.to(() => EmailVerificationPage());
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
                      inputTextColor: Colors.white,
                    )),

                    SizedBox(height: 48.h),

                    // ✅ CRITICAL: Minimal button implementation
                    Obx(() {
                      final loading = controller.isLoading.value;
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loading ? null : () {
                            print("🔘 Button pressed");
                            controller.login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.instance.primaryBtnColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            'Log in',
                            style: TextStyle(
                              color: AppColors.instance.btnTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 20.h),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(
                          data: 'Don\'t have an account? ',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: const AppText(
                            data: 'Sign up',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
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