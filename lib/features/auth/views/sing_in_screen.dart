import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soul_gate/core/constants/app_assert_image.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/features/auth/views/sign_up_screen.dart';
import 'package:soul_gate/features/auth/views/verify_email_screen.dart';
import 'package:soul_gate/features/auth/views/widget/language_selection_dialog.dart';
import '../../../core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/language_controller.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/sign_in_controller.dart';

class SingInScreen extends StatelessWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Initialize controllers
    final controller = Get.put(LoginController());
    Get.put(LanguageController());

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
                child: GetBuilder<LanguageController>(
                  builder: (_) {
                    final strings = AppStrings.instance;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Language Selection Button (Top Right)
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => LanguageSelectionDialog.show(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    strings.language,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Obx(() => Text(
                                    Get.find<LanguageController>().isEnglish
                                        ? strings.english
                                        : strings.spanish,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 50.h),

                        AppText(
                          data: strings.login,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.instance.titleTextColor,
                          height: 1.0,
                        ),

                        SizedBox(height: 40.h),

                        // Email Field
                        AppTextField(
                          label: strings.email,
                          hintText: strings.enterYourEmail,
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
                          label: strings.password,
                          label2: strings.forgotPassword,
                          hintText: strings.enterYourPassword,
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
                          inputTextColor: Colors.white,
                        )),

                        SizedBox(height: 48.h),

                        // Button
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
                                strings.login,
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
                            AppText(
                              data: strings.dontHaveAccount,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SignUpScreen());
                              },
                              child: AppText(
                                data: strings.signUp,
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
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}