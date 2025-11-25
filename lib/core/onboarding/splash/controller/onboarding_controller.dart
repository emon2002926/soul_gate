
import 'package:flutter/cupertino.dart';
class OnboardingController {
  final PageController pageController = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void dispose() {
    pageController.dispose();
  }
}
