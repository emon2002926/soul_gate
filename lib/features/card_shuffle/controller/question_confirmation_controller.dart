import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/features/card_shuffle/views/ask_oracle_screen.dart';
import '../../../core/onboarding/splash/views/short_blessing_screen.dart';
import '../../../core/util/storage_service.dart';

class OracleQuestion {
  final int id;
  final String category;
  final String question;

  OracleQuestion({
    required this.id,
    required this.category,
    required this.question,
  });

  factory OracleQuestion.fromJson(Map<String, dynamic> json) {
    return OracleQuestion(
      id: json['id'],
      category: json['category'],
      question: json['question'],
    );
  }
}
class AskOracleController extends GetxController {
  final questions = <OracleQuestion>[].obs;
  final isLoading = true.obs;
  String? accessToken = StorageService.accessToken;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;

      print('=== Fetching Questions ===');
      print('Token: ${accessToken?.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('https://sofiapi.dsrt321.online/tarot/api/questions'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 10));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed Data: $data');

        if (data['success'] == true) {
          final List questionsList = data['questions'] ?? [];
          print('Questions Count: ${questionsList.length}');

          questions.value = questionsList
              .map((q) => OracleQuestion.fromJson(q))
              .toList();

          print('Loaded ${questions.length} questions');
        } else {
          print('API returned success: false');
          Get.snackbar(
            'Error',
            'Failed to load questions',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response: ${response.body}');

        Get.snackbar(
          'Error',
          'Failed to load questions (${response.statusCode})',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      print('Error fetching questions: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        'Error',
        'Network error: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectQuestion(OracleQuestion question, int readingTypeIndex, int deckIndex) {
    Get.to(
          () => QuestionConfirmationScreen(
            readingTypeIndex: readingTypeIndex,
            deckIndex: deckIndex,
          ),
      arguments: question,
    );
  }
}

class QuestionConfirmationController extends GetxController {
  final questionController = TextEditingController();
  late OracleQuestion selectedQuestion;

  @override
  void onInit() {
    super.onInit();
    selectedQuestion = Get.arguments as OracleQuestion;
    questionController.text = selectedQuestion.question;
  }

  void continueToReading(
      int readingTypeIndex,
      int deckIndex,
      ) {
    final question = questionController.text.trim();

    if (question.isEmpty) {
      Get.snackbar(
        'Empty Question',
        'Please enter a question before continuing',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    print('Selected Question ID: ${selectedQuestion.id}');
    print('Selected Question Text: $question');

    // Navigate to ShortBlessingScreen with question ID
    AppNavigation.push(
      Get.context!,
      ShortBlessingScreen(
        // questionId: selectedQuestion.id,
        questionText: question,
        readingTypeIndex: readingTypeIndex,
        deckIndex: deckIndex,

      ),
    );
  }

  @override
  void onClose() {
    questionController.dispose();
    super.onClose();
  }
}