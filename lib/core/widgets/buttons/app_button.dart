import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final FontWeight? fontWeight;
  final bool isLoading;
  final String? loadingText;
  final double? elevation;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderWidth;

  const AppButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.buttonHeight,
    this.buttonWidth,
    this.prefixIcon,
    this.suffixIcon,
    this.fontWeight,
    this.isLoading = false,
    this.loadingText,
    this.elevation,
    this.fillColor,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 25;
    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: buttonHeight ?? 50,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        // ✅ NO GestureDetector - ElevatedButton handles taps!
        child: Container(
          decoration: BoxDecoration(
            color: fillColor ?? const Color(0xFFBC9041),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,  // ✅ Single tap handler
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: elevation ?? 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              padding: EdgeInsets.zero,
              disabledBackgroundColor: Colors.transparent,
            ),
            child: isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      textColor ?? Colors.white,
                    ),
                    strokeWidth: 2.5,
                  ),
                ),
                if (loadingText != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    loadingText!,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.w600,
                    ),
                  ),
                ],
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null) ...[
                  Icon(
                    prefixIcon,
                    color: textColor ?? Colors.white,
                    size: fontSize ?? 24,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize ?? 16,
                    fontWeight: fontWeight ?? FontWeight.w600,
                  ),
                ),
                if (suffixIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    suffixIcon,
                    color: textColor ?? Colors.white,
                    size: fontSize ?? 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Static method to show full-screen loading overlay (Soul-gate style)
  static Widget buildLoadingOverlay({
    required RxBool isLoading,
    required String loadingMessage,
    Color? backgroundColor,
    Color? cardColor,
  }) {
    return Obx(
          () => isLoading.value
          ? Container(
        color: (backgroundColor ?? Colors.black).withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: cardColor ?? const Color(0xFFF5F5DC),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Color(0xFF9B7EBD),
                  ),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  loadingMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A4A4A),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}