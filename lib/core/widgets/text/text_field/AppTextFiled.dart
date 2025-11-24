import 'package:flutter/material.dart';
class AppTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final VoidCallback? suffixIconOnTap;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.suffixIconOnTap
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          focusNode: focusNode,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
            filled: true,
            fillColor: const Color(0xFFEFFFE0),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey[700], size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                onTap:suffixIconOnTap,
                child: Icon(suffixIcon, color: Colors.grey[700], size: 20))
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
