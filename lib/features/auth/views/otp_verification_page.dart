import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../view_models/otp_verification_controller.dart';
import 'package:flutter/services.dart';


class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController());

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Title - conditional based on flow
                  AppText(
                    data: controller.isFromSignUp.value
                        ? 'Verify your\naccount'
                        : 'Forgot your\npassword',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),

                  const SizedBox(height: 16),

                  // Subtitle - conditional based on flow with email
                  AppText(
                    data: controller.isFromSignUp.value
                        ? 'Enter the verification code sent to\n${controller.email.value}'
                        : 'Enter the verification code sent to\n${controller.email.value.isNotEmpty ? controller.email.value : "your email"}',
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.4,
                  ),

                  const SizedBox(height: 40),

                  // OTP Fields (6 OTP TextFields)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller.otpControllers[index],
                          focusNode: controller.focusNodes[index],
                          onChanged: (value) => controller.onOtpChanged(value, index),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          enabled: !controller.isLoading.value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 30),

                  // Resend section with countdown timer
                  Row(
                    children: [
                      AppText(
                        data: "Didn't receive the code? ",
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      Obx(() {
                        if (controller.resendCountdown.value > 0) {
                          return AppText(
                            data: '00:${controller.resendCountdown.value.toString().padLeft(2, '0')} ',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      Obx(() => GestureDetector(
                        onTap: (controller.isLoading.value || controller.resendCountdown.value > 0)
                            ? null
                            : controller.resetPassResendOtp,
                        child: AppText(
                          data: 'Resend',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: (controller.isLoading.value || controller.resendCountdown.value > 0)
                              ? Colors.grey[400]
                              : const Color(0xff007AFF),
                          decoration: TextDecoration.underline,
                          decorationColor: (controller.isLoading.value || controller.resendCountdown.value > 0)
                              ? Colors.grey[400]
                              : const Color(0xff007AFF),
                        ),
                      )),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  // Continue button with conditional text and action
                  AppButton(
                    buttonText: controller.isLoading.value
                        ? 'Verifying...'
                        : (controller.isFromSignUp.value ? 'Verify Account' : 'Continue'),
                    onPressed: controller.isLoading.value ? null : controller.verifyCode,
                    fillColor: const Color(0xffE0E0E0),
                    textColor: Colors.black,
                    borderRadius: 12,
                    buttonHeight: 56,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    isLoading: controller.isLoading.value,
                  ),

                  const SizedBox(height: 40),
                ],
              )),
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
                      data: 'Verifying OTP...',
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