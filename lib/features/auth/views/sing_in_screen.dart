import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Color(0xFFCCC6C3),
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFCCC6C3),
      //   elevation: 0,
      //   title: AppText(
      //     data: 'Qube',
      //     fontSize: 24.sp,
      //     fontWeight: FontWeight.w600,
      //     color: Colors.black,
      //   ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
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
                  controller: controller.emailController,
                ),

                SizedBox(height: 24.h),

                // Password field
                Obx(() => AppTextField(
                  label: 'Password',
                  label2: 'Forgot Password?',
                  label2OnClick: () {
                    AppNavigation.push(context,EmailVerificationPage());
                    // Get.toNamed(AppRoutes.verifyEmail, arguments: {
                    //   "isFromSignUp": false,
                    // });
                  },
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixIconTap: controller.togglePasswordVisibility,
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

                SizedBox(height: 40.h), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}