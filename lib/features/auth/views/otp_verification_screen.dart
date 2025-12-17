import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../view_models/otp_verification_controller.dart';
import 'package:flutter/services.dart';


class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText(
          data: '',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Title
                      AppText(
                        data: 'Enter Your OTP',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),

                      const SizedBox(height: 10),

                      const SizedBox(height: 40),

                      // OTP Fields (6 OTP TextFields)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 50,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.yellow),
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
                                color: Colors.white,
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

                      // Continue button
                      AppButton(
                        buttonText: controller.isLoading.value
                            ? 'Verifying...'
                            : (controller.isFromSignUp.value ? 'Verify Account' : 'Continue'),
                        onPressed: controller.isLoading.value ? null : controller.verifyCode,
                        fontSize: 16,
                        isLoading: controller.isLoading.value,
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                      Row(
                        children: [
                          AppText(
                            data: " Didn't receive the code?  ",
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          Obx(() {
                            if (controller.resendCountdown.value > 0) {
                              return AppText(
                                data: '00:${controller.resendCountdown.value.toString().padLeft(2, '0')} ',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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

                      const SizedBox(height: 40),
                    ],
                  )),
                ),
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
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ) : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}