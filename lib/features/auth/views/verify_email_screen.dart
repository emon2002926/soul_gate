
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../view_models/email_verification_controller.dart';
class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailVerificationController controller = Get.put(EmailVerificationController());

    return Scaffold(
      extendBodyBehindAppBar: true,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Title
                AppText(
                  data: 'Forgot your password',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.instance.titleTextColor,
                  height: 1.2,
                ),

                const SizedBox(height: 16),

                // Subtitle
                AppText(
                  data: 'Enter your email address and we\'ll send you\na verification code to reset your password',
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.4,
                ),

                const SizedBox(height: 32),

                // Email field
                AppTextField(
                  label: 'Enter your email',
                  hintText: 'Enter your email',
                  controller: controller.emailController,
                  hintTextColor: Colors.white,
                  borderColor: AppColors.instance.primaryBtnColor,
                  fillColor: Colors.transparent,
                  inputTextColor: Colors.white,
                ),

                const SizedBox(height: 20),

                // Resend section - only show if code has been sent
                Obx(() {
                  if (!controller.hasCodeBeenSent.value) return const SizedBox.shrink();

                  final countdown = controller.resendCountdown.value;
                  return Row(
                    children: [
                      AppText(
                        data: "Didn't receive the code? ",
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      if (countdown > 0) ...[
                        AppText(
                          data: '00:${countdown.toString().padLeft(2, '0')} ',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ],
                      GestureDetector(
                        onTap: countdown > 0 ? null : controller.resendCode,
                        child: AppText(
                          data: 'Resend',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: countdown > 0
                              ? Colors.grey[400]
                              : const Color(0xff007AFF),
                          decoration: countdown > 0
                              ? null
                              : TextDecoration.underline,
                          decorationColor: countdown > 0
                              ? null
                              : const Color(0xff007AFF),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 20),

                // Continue button
                Obx(() {
                  final isLoading = controller.isLoading.value;
                  final hasCodeBeenSent = controller.hasCodeBeenSent.value;
                  return AppButton(
                    buttonText: 'Send Reset Code',
                    onPressed: hasCodeBeenSent
                        ? controller.continueToOtpVerification
                        : controller.sendVerificationCode,
                    fillColor: AppColors.instance.primaryBtnColor,
                    textColor: AppColors.instance.btnTextColor,
                    borderRadius: 25,
                    buttonHeight: 50,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    isLoading: isLoading,
                  );
                }),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}