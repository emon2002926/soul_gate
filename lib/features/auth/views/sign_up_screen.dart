import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/sign_up_controller.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final appStrings = AppStrings.instance;


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
                      data: appStrings.signUp,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.titleTextColor,
                      height: 1.0,

                    ),
                    SizedBox(height: 28.h),

                    // Full Name field


                    // Email field
                    AppTextField(
                      label: appStrings.email,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                      hintTextColor: Colors.white,
                      borderColor: AppColors.instance.primaryBtnColor,
                      fillColor: Colors.transparent,
                      inputTextColor: Colors.white,
                    ),

                    SizedBox(height: 20.h),

                    Obx(() => AppTextField(
                      label: appStrings.password,
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onSuffixIconTap: controller.togglePasswordVisibility,
                      validator: controller.validatePassword,
                      hintTextColor: Colors.white,
                      borderColor: AppColors.instance.primaryBtnColor,
                      fillColor: Colors.transparent,
                      inputTextColor: Colors.white,
                    )),

                    SizedBox(height: 20.h),

                    Obx(() => AppTextField(
                      label: appStrings.confirmPassword,
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

                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                         AppText(
                          data: appStrings.termsOfServiceAgreement,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),

                    // Create account button
                    Obx(() => AppButton(
                      buttonText: controller.isLoading.value
                          ? appStrings.createAccountBtn
                          : appStrings.creatingAccountBtn,
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
                         AppText(
                          data: appStrings.alreadyHaveAccount,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child:  AppText(
                            data:appStrings.login,
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
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