import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';

import '../views/short_blessing_screen.dart';
final List<String> suggestedQuestions = [
  "What's on your mind?",
  "What do I most need to understand about my current situation?",
  "What energy is surrounding me at this moment?",
  "What is beginning to shift in my life right now?",
  "What is supporting me that I may not be noticing?",
  "What is the main lesson or theme unfolding for me?",
  "What direction is life encouraging me to move toward next?",
];


class AskOracleController extends GetxController {
  final TextEditingController questionController = TextEditingController();
  final selectedQuestion = ''.obs;
  final currentStep = 0.obs; // 0: Ask, 1: Confirm, 2: Shuffle

  void selectQuestion(String question) {
    selectedQuestion.value = question;
    questionController.text = question;
  }

  void submitCustomQuestion() {
    if (questionController.text.trim().isNotEmpty) {
      selectedQuestion.value = questionController.text.trim();
      goToConfirmation();
    }
  }

  void goToConfirmation() {
    if (selectedQuestion.value.isNotEmpty) {
      currentStep.value = 1;
    }
  }

  void editQuestion() {
    currentStep.value = 0;
  }

  void confirmAndContinue() {
    currentStep.value = 2;
  }

  void startShuffle() {
    // Navigate to your card shuffle/reading screen
    // Get.to(() => ShuffleScreen(question: selectedQuestion.value));
    AppNavigation.push(Get.context!, ShortBlessingScreen());
  }

  @override
  void onClose() {
    questionController.dispose();
    super.onClose();
  }
}