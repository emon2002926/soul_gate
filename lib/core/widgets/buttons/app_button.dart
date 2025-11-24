import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed; // Changed to nullable
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final FontWeight? fontWeight;
  final bool isLoading;
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
    this.elevation,
    this.fillColor,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 10;
    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: buttonHeight ?? 48,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0, // Visual feedback when disabled
        child: GestureDetector(
          onTap: isDisabled ? null : onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: fillColor ?? Color(0xff7a7777),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 0,
              ),
            ),
            child: ElevatedButton(
              onPressed: isDisabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: elevation ?? 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
                padding: EdgeInsets.zero,
                disabledBackgroundColor: Colors.transparent, // Keep transparent when disabled
              ),
              child: isLoading
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(textColor ?? Colors.white),
                  strokeWidth: 2.5,
                ),
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
      ),
    );
  }
}
