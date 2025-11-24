import 'dart:ui';
import 'package:flutter/material.dart';
import '../buttons/app_button.dart';
import '../text/app_text.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const AppDialog({super.key,required this.onConfirm,required this.onCancel,  this.title,  this.description,  this.confirmText,  this.cancelText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(data: title ?? "Submit", fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white,),
                const SizedBox(height: 16),
                AppText(
                  data: description ?? 'Are you sure you want to submit your photo?',
                  fontSize: 16,
                  color: Colors.white70,),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child:
                        AppButton(buttonText: cancelText ?? 'Cancel', onPressed: onCancel,
                          )
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(buttonText: confirmText ?? 'Confirm', onPressed: onConfirm,
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
