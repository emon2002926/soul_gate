import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/sign_in_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Color(0xFFCCC6C3),
      appBar: AppBar(
        backgroundColor: Color(0xFFCCC6C3),
        elevation: 0,
        title: AppText(
          data: 'Qube',
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              // Title
              AppText(
                data: 'Sign In',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.instance.titleTextColor,
                height: 1.0,
              ),
              SizedBox(height: 40.h),

              // Email field
              AppTextField(
                label: 'Email',
                hintText: 'Email',
                controller: controller.emailController,
              ),

              SizedBox(height: 24.h),

              // Password field
              Obx(() => AppTextField(
                hintText: 'Password',
                label: 'Password',
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: controller.isPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixIconTap: controller.togglePasswordVisibility,
              )),

              SizedBox(height: 16.h),

              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.verifyEmail, arguments: {
                      "isFromSignUp": false,
                    });
                  },
                  child: AppText(
                    data: "forgot password",
                    color: Colors.green,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              Obx(() => AppButton(
                buttonText: controller.isLoading.value ? 'Loading...' : 'Log in',
                onPressed: controller.isLoading.value ? null : controller.login,
                fillColor: Color(0xffE8EBE6),
                borderRadius: 12,
                buttonHeight: 56,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textColor: AppColors.instance.btnTextColor,
              )),

              SizedBox(height: 20.h), // Large spacing before bottom text

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
                      Get.toNamed(AppRoutes.signUp);
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

              SizedBox(height: 40.h), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}