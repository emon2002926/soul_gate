import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final double? elevation;
  final double? buttonHeight;
  final double? buttonWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final FontWeight? fontWeight;
  final bool isLoading;
  final Gradient? gradient;

  const AppButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.elevation=20,
    this.buttonHeight,
    this.buttonWidth,
    this.prefixIcon,
    this.suffixIcon,
    this.fontWeight,
    this.isLoading = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 12;

    final Gradient defaultGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF5B8CDE),
        Color(0xFFB47BC8),
      ],
    );

    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: buttonHeight ?? 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? defaultGradient,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: elevation != null && elevation! > 0
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: elevation!,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(radius),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
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
                    style: GoogleFonts.poppins(
                      color: textColor ?? Colors.white,
                      fontSize: fontSize ?? 18,
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