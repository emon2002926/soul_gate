import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../buttons/app_button.dart';
import '../text/app_text.dart';
class CustomSafetyDialog {
  static void showWithCustomization({
    String? title,
    String? message,
    String? firstButtonText,
    VoidCallback? onReady,
    bool? showSecondButton = true,
    VoidCallback? onSecondButtonPressed,
    VoidCallback? onFirstButtonPressed,
    String? secondButtonText,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              data: title ?? 'Safety Alert',
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppText(
              data: message ??
                  'To ensure a safe riding experience, please refrain from riding on sidewalks and in restricted areas. Stick to bike lanes and main roads when safe.',
              color: Colors.white,
              fontSize: 18,
              height: 1.4,
              textAlign: TextAlign.start,
              maxLines: 100,
            ),
            const SizedBox(height: 24),

            // First button
            AppButton(
              buttonText: firstButtonText ?? 'Ready!',
              onPressed: onFirstButtonPressed,
              borderRadius: 12,
              backgroundColor: Colors.transparent,
            ),

            // Only show divider + second button if enabled
            if (showSecondButton == true) ...[
              Divider(color: Colors.grey[600]),
              AppButton(
                buttonText: secondButtonText ?? "Cancel",
                onPressed: onSecondButtonPressed ?? () => Get.back(),
                borderRadius: 12,
                backgroundColor: Colors.transparent,
              ),
            ],
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
