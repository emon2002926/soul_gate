import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../text/app_text.dart';


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
  final bool useResponsiveSize;

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
    this.useResponsiveSize = true,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive calculations
    final double responsiveRadius = useResponsiveSize
        ? _getResponsiveSize(context, borderRadius ?? 25)
        : (borderRadius ?? 25);

    final double responsiveHeight = useResponsiveSize
        ? _getResponsiveSize(context, buttonHeight ?? 50)
        : (buttonHeight ?? 50);

    final double responsiveFontSize = useResponsiveSize
        ? _getResponsiveFontSize(context, fontSize ?? 16)
        : (fontSize ?? 16);

    final double responsiveIconSize = useResponsiveSize
        ? _getResponsiveFontSize(context, fontSize ?? 24)
        : (fontSize ?? 24);

    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: responsiveHeight,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: fillColor ?? const Color(0xFFBC9041),
            borderRadius: BorderRadius.circular(responsiveRadius),
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
                borderRadius: BorderRadius.circular(responsiveRadius),
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
                  height: _getResponsiveSize(context, 20),
                  width: _getResponsiveSize(context, 20),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      textColor ?? Colors.white,
                    ),
                    strokeWidth: 2.5,
                  ),
                ),
                if (loadingText != null) ...[
                  SizedBox(width: _getResponsiveSize(context, 12)),
                  Text(
                    loadingText!,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: responsiveFontSize,
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
                    size: responsiveIconSize,
                  ),
                  SizedBox(width: _getResponsiveSize(context, 8)),
                ],
                AppText(
                  data: buttonText,
                  color: textColor ?? Colors.white,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w600,
                  useResponsiveFontSize: useResponsiveSize,
                ),
                if (suffixIcon != null) ...[
                  SizedBox(width: _getResponsiveSize(context, 8)),
                  Icon(
                    suffixIcon,
                    color: textColor ?? Colors.white,
                    size: responsiveIconSize,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods (instance methods, not static)
  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }

  double _getResponsiveFontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
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
          child: Builder(
            builder: (context) {
              // Use local helper function for static method
              double getResponsiveSize(double size) {
                final screenWidth = MediaQuery.of(context).size.width;
                return screenWidth * (size / 375);
              }

              return Container(
                padding: EdgeInsets.all(getResponsiveSize(24)),
                margin: EdgeInsets.symmetric(
                  horizontal: getResponsiveSize(40),
                ),
                decoration: BoxDecoration(
                  color: cardColor ?? const Color(0xFFF5F5DC),
                  borderRadius: BorderRadius.circular(
                    getResponsiveSize(16),
                  ),
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
                    SizedBox(
                      height: getResponsiveSize(40),
                      width: getResponsiveSize(40),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Color(0xFF9B7EBD),
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: getResponsiveSize(20)),
                    Text(
                      loadingMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getResponsiveSize(16),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4A4A4A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}