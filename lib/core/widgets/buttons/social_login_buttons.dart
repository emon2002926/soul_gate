import 'package:flutter/material.dart';

import '../text/app_text.dart';
class SocialLoginButtons extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final String iconPath;
  const SocialLoginButtons({super.key, required this.title, required this.onPressed, required this.iconPath});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(iconPath),
        ),
        label: AppText(color: Colors.white, data:title),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}
