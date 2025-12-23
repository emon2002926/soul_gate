import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/language_controller.dart';


class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const LanguageSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LanguageController>();
    final strings = AppStrings.instance;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5DC), // Cream background
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              strings.selectLanguage,
              style: GoogleFonts.cinzel(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D291A),
              ),
            ),
            const SizedBox(height: 24),

            // English Option
            Obx(() => _LanguageOption(
              flag: '🇺🇸',
              languageName: strings.english,
              languageCode: 'en',
              isSelected: controller.isEnglish,
              onTap: () async {
                await controller.changeLanguage('en');
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 12),

            // Spanish Option
            Obx(() => _LanguageOption(
              flag: '🇪🇸',
              languageName: strings.spanish,
              languageCode: 'es',
              isSelected: controller.isSpanish,
              onTap: () async {
                await controller.changeLanguage('es');
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String languageName;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.languageName,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF9B7EBD).withOpacity(0.15) // Purple tint
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37) // Gold border
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),

            // Language Name
            Expanded(
              child: Text(
                languageName,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF2D291A),
                ),
              ),
            ),

            // Check Icon
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFD4AF37), // Gold
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}