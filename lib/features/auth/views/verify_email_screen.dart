
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Title - conditional based on flow
            AppText(
              data: 'Forgot your password',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.instance.titleTextColor,
              height: 1.2,
            ),

            const SizedBox(height: 16),

            // Subtitle - conditional based on flow
            AppText(
              data: 'Enter your email address and we\'ll send you\na verification code to reset your password',
              fontSize: 16,
              color: Colors.grey,
              height: 1.4,
            ),

            const SizedBox(height: 32),

            // Email field
            AppTextField(
              // hintText: 'Enter your email',
              label: 'Enter your email',
              controller: controller.emailController,
              borderColor: Colors.transparent,
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

            // const Spacer(),
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
    );
  }
}