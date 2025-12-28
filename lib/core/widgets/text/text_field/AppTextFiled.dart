import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';

import '../../../constants/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? label2;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final VoidCallback? suffixIconOnTap;
  final VoidCallback? onSuffixIconTap;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final bool enabled;
  final VoidCallback? label2OnClick;
  final Color? fillColor;
  final Color? inputTextColor;
  final Color? hintTextColor;
  final bool useResponsiveSize;

  const AppTextField({
    super.key,
    this.label,
    this.label2,
    this.label2OnClick,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.suffixIconOnTap,
    this.onSuffixIconTap,
    this.borderColor,
    this.keyboardType,
    this.enabled = true,
    this.fillColor,
    this.inputTextColor,
    this.hintTextColor,
    this.useResponsiveSize = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSuffixTap = suffixIconOnTap ?? onSuffixIconTap;

    // Responsive calculations
    final double labelFontSize = useResponsiveSize
        ? _getResponsiveFontSize(context, 14)
        : 14;
    final double inputFontSize = useResponsiveSize
        ? _getResponsiveFontSize(context, 14)
        : 14;
    final double iconSize = useResponsiveSize
        ? _getResponsiveSize(context, 20)
        : 20;
    final double borderRadius = useResponsiveSize
        ? _getResponsiveSize(context, 10)
        : 10;
    final double verticalPadding = useResponsiveSize
        ? _getResponsiveSize(context, 14)
        : 14;
    final double horizontalPadding = useResponsiveSize
        ? _getResponsiveSize(context, 16)
        : 16;
    final double spacing = useResponsiveSize
        ? _getResponsiveSize(context, 8)
        : 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                data: label!,
                fontWeight: FontWeight.w600,
                color: AppColors.instance.titleTextColor,
                fontSize: 14,
                useResponsiveFontSize: useResponsiveSize,
              ),
              if (label2 != null)
                GestureDetector(
                  onTap: label2OnClick,
                  child: Text(
                    label2!,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      fontSize: labelFontSize,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          focusNode: focusNode,
          keyboardType: keyboardType,
          enabled: enabled,
          style: GoogleFonts.poppins(
            color: inputTextColor,
            fontSize: inputFontSize,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: hintTextColor ?? Colors.grey,
              fontSize: inputFontSize,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: enabled ? fillColor : Colors.grey.shade300,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey[700], size: iconSize)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                onTap: effectiveSuffixTap,
                child: Icon(suffixIcon, color: Colors.grey[700], size: iconSize))
                : null,
            contentPadding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Responsive size calculation (based on 375px standard width)
  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }

  // Responsive font size calculation
  double _getResponsiveFontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }
}