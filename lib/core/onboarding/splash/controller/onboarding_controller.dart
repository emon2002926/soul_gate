import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';

import '../../../constants/app_assert_image.dart';
import '../../../../features/card_shuffle/views/portal_entrance_screen.dart';
// ==================== Models ====================

enum OnboardingPageType {
  standard,
  selectionPage,
}

enum ReadingType {
  audioAndText,
  textOnly,
}

enum DeckType {
  classic,
  mystical,
  celestial,
}

class OnboardingData {
  final String title;
  final String? subtitle;
  final String? description;
  final String? centerImage;
  final List<FeatureItem>? features;
  final String buttonText;
  final OnboardingPageType type;

  OnboardingData({
    required this.title,
    this.subtitle,
    this.description,
    this.centerImage,
    this.features,
    required this.buttonText,
    this.type = OnboardingPageType.standard,
  });
}

class FeatureItem {
  final IconData icon;
  final String text;
  FeatureItem({required this.icon, required this.text});
}

// ==================== Data ====================

final List<OnboardingData> onboardingPages = [
  // Page 1: Welcome
  OnboardingData(
    title: 'Welcome to\nSoulGate',
    subtitle: 'To the realm of the soul',
    centerImage: AppAssertImage.instance.onboardingImage1, // Tarot book image
    description: 'A space of clarity, guidance, and light',
    buttonText: 'Continue',
  ),

  // Page 2: Combined Reading Preference & Deck Selection
  OnboardingData(
    title: 'Customize Your Experience',
    buttonText: 'Continue',
    type: OnboardingPageType.selectionPage,
  ),

  // Page 3: Features
  OnboardingData(
    title: 'Your inner\nworld,\nilluminated.',
    features: [
      FeatureItem(icon: Icons.auto_awesome, text: 'Personalized tarot readings'),
      FeatureItem(icon: Icons.graphic_eq, text: 'Voice or text guidance'),
      FeatureItem(icon: Icons.chat_bubble_outline, text: 'Messages from your guides'),
      FeatureItem(icon: Icons.all_inclusive, text: 'Insights for love, purpose, money & spiritual path'),
      FeatureItem(icon: Icons.verified_user_outlined, text: 'Secure, private, sacred space'),
    ],
    buttonText: 'Continue',
  ),

  // Page 4: Free Readings
  OnboardingData(
    title: 'Your first\nreadings\nare a gift.',
    description: 'To help you experience the depth of SoulGate, you receive 5 free readings. Each one is unique, channeled, and designed to bring clarity.',
    buttonText: 'Continue',
  ),
];

// ==================== Controller ====================

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final selectedReadingType = Rx<ReadingType?>(null);
  final selectedDeck = Rx<DeckType?>(null);

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectReadingType(ReadingType type) {
    selectedReadingType.value = type;
  }

  void selectDeck(DeckType deck) {
    selectedDeck.value = deck;
  }

  void completeOnboarding() {
    // Save preferences to local storage or state management
    print('Reading Type: ${selectedReadingType.value}');
    print('Selected Deck: ${selectedDeck.value}');

    // Navigate to next screen
    AppNavigation.push(Get.context!, PortalEntranceScreen());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}