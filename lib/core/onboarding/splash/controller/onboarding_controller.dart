import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class OnboardingData {
  final String title;
  final String? subtitle;
  final String? description;
  final List<FeatureItem>? features;
  final bool showPortal;
  final String buttonText;
  final bool isLastPage;

  OnboardingData({
    required this.title,
    this.subtitle,
    this.description,
    this.features,
    this.showPortal = false,
    required this.buttonText,
    this.isLastPage = false,
  });
}

class FeatureItem {
  final IconData icon;
  final String text;
  FeatureItem({required this.icon, required this.text});
}

final List<OnboardingData> onboardingPages = [
  // Page 1: Welcome
  OnboardingData(
    title: 'Welcome to\nSoulGate',
    subtitle: 'To the realm of the soul',
    description: 'A doorway to clarity,\ninsight, and true guidance.\n\nYour intuition meets divine insight.\nYour wisdom is protected by Archangels\nand guided by your higher self.',
    buttonText: 'Continue',
  ),

  // Page 2: Features
  OnboardingData(
    title: 'Your inner\nworld,\nilluminated.',
    features: [
      FeatureItem(icon: Icons.auto_awesome, text: 'Personalized tarot readings'),
      FeatureItem(icon: Icons.graphic_eq, text: 'Voice or text guidance'),
      FeatureItem(icon: Icons.chat_bubble_outline, text: 'Messages from your guides'),
      FeatureItem(icon: Icons.all_inclusive, text: 'Insights for love, purpose,\nmoney & spiritual path'),
      FeatureItem(icon: Icons.verified_user_outlined, text: 'Secure, private, sacred space'),
    ],
    buttonText: 'Continue',
  ),

  // Page 3: Free Readings
  OnboardingData(
    title: 'Your first\nreadings\nare a gift.',
    description: 'To help you experience the\ndepth of SoulGate,\nyou receive 5 free readings.\nEach one is unique, channeled,\nand designed to bring clarity.',
    buttonText: 'Continue',
  ),

  // Page 4: Enter Portal
  OnboardingData(
    title: 'Step into\nthe portal.',
    showPortal: true,
    buttonText: 'Enter the Portal',
    isLastPage: true,
  ),
];

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}