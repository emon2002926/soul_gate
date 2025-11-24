import 'package:flutter/material.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../constants/app_colors.dart';
import 'buttons/app_button.dart';


class SuccessDialog extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final String imageString;
  final VoidCallback onPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.description,
    this.buttonText = 'Continue',
    required this.onPressed,
    required this.imageString,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.instance.white50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(imageString),
              ),

            ),
            const SizedBox(height: 16),

            // Title
            AppText(data: title, fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,),

            const SizedBox(height: 8),

            AppText(data: description,
              fontSize: 16,
              color: Colors.black54,
              maxLines: 10,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: AppButton(buttonText: buttonText, onPressed: onPressed,
                textColor: Colors.white,
                borderRadius: 30,
              )
            ),
          ],
        ),
      ),
    );
  }

  // Helper to show dialog
  static void show({
    required BuildContext context,
    required String title,
    required String description,
    required String imageString,
    String buttonText = 'Continue',
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        title: title,
        description: description,
        buttonText: buttonText,
        imageString: imageString,
        onPressed: onPressed ?? () => Navigator.pop(context),
      ),
    );
  }
}