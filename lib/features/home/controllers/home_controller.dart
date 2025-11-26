import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final userName = 'Hakim'.obs;
  final profileImageUrl = ''.obs;
  final questionController = TextEditingController();

  final oraclePrompts = [
    'What guidance are you seeking today?',
    'Ask from your soul, The cards will answer.',
    'Hold a question in your heart.',
    'What truth are you ready to hear?',
    'What wisdom do you seek in this moment?',
  ];

  final difficultMoments = [
    {'emoji': '💔', 'title': 'Breakup', 'subtitle': 'Support'},
    {'emoji': '😢', 'title': 'Emotional', 'subtitle': 'Overwhelm'},
    {'emoji': '😟', 'title': 'Clarity in', 'subtitle': 'Confusion'},
  ];

  void onProfileTap() {
    // TODO: Navigate to profile
    Get.snackbar('Profile', 'Opening profile...');
  }

  void onOracleCardTap() {
    // TODO: Navigate to daily oracle reading
    Get.snackbar('Oracle', 'Opening daily oracle...');
  }

  void onPromptTap(String prompt) {
    questionController.text = prompt;
    // TODO: Navigate to reading with this prompt
  }

  void onAskQuestion() {
    if (questionController.text.trim().isEmpty) {

      Get.snackbar('Error', 'Please enter your question');
      return;
    }
    // TODO: Navigate to reading screen with question
    Get.snackbar('Question', questionController.text);
  }

  void onDifficultMomentTap(String title) {
    Get.snackbar('Reading', 'Opening $title reading...');


  }

  @override
  void onClose() {
    questionController.dispose();
    super.onClose();
  }
}
