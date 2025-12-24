import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/constants/app_strings.dart';
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
  // Page 1
  OnboardingData(
    title: AppStrings.instance.welcomeTitle,
    subtitle: AppStrings.instance.welcomeSubtitle,
    description: AppStrings.instance.welcomeDescription,
    centerImage: AppAssertImage.instance.onboardingImage1,
    buttonText: AppStrings.instance.continueText,
  ),

  // Page 2
  OnboardingData(
    title: AppStrings.instance.customizeExperience,
    buttonText: AppStrings.instance.continueText,
    type: OnboardingPageType.selectionPage,
  ),

  // Page 3
  OnboardingData(
    title: AppStrings.instance.innerWorldTitle,
    features: [
      FeatureItem(
        icon: Icons.auto_awesome,
        text: AppStrings.instance.personalizedReadings,
      ),
      FeatureItem(
        icon: Icons.graphic_eq,
        text: AppStrings.instance.voiceOrText,
      ),
      FeatureItem(
        icon: Icons.chat_bubble_outline,
        text: AppStrings.instance.guideMessages,
      ),
      FeatureItem(
        icon: Icons.all_inclusive,
        text: AppStrings.instance.lifeInsights,
      ),
      FeatureItem(
        icon: Icons.verified_user_outlined,
        text: AppStrings.instance.secureSpace,
      ),
    ],
    buttonText: AppStrings.instance.continueText,
  ),

  // Page 4
  OnboardingData(
    title: AppStrings.instance.freeReadingsTitle,
    description: AppStrings.instance.freeReadingsDescription,
    buttonText: AppStrings.instance.continueText,
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