import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? label2;
  final String hintText;
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

  const AppTextField({
    super.key,
    this.label,
    this.label2,
    required this.hintText,
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
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSuffixTap = suffixIconOnTap ?? onSuffixIconTap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D291A),
                  fontSize: 14,
                ),
              ),
              if (label2 != null)
                Text(
                  label2!,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D291A),
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          focusNode: focusNode,
          keyboardType: keyboardType,
          enabled: enabled,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF2D291A),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: enabled ? const Color(0xFFEFFFE0) : Colors.grey.shade300,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey[700], size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                onTap: effectiveSuffixTap,
                child: Icon(suffixIcon, color: Colors.grey[700], size: 20))
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}