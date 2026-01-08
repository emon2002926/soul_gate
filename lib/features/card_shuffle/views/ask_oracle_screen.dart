import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:soul_gate/core/util/screen_size.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/onboarding/splash/views/short_blessing_screen.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/buttons/app_button.dart';


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

// ==================== SCREEN 1: Ask the Oracle ====================

class AskOracleScreen extends StatelessWidget {
  final int readingTypeIndex;
  final int deckIndex;
  final bool isPlanB;

  const AskOracleScreen({
    super.key,
    required this.readingTypeIndex,
    required this.deckIndex,
    this.isPlanB = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use different controller based on plan
    if (isPlanB) {
      return _PlanBScreen(
        readingTypeIndex: readingTypeIndex,
        deckIndex: deckIndex,
      );
    } else {
      return _PlanAScreen(
        readingTypeIndex: readingTypeIndex,
        deckIndex: deckIndex,
      );
    }
  }
}

// ==================== PLAN A: Original API-based Screen ====================

class _PlanAScreen extends StatelessWidget {
  final int readingTypeIndex;
  final int deckIndex;

  const _PlanAScreen({
    required this.readingTypeIndex,
    required this.deckIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AskOracleController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: context.heightPercentage(4)),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing24),
                child: Text(
                  AppStrings.instance.askTheOracle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: context.responsiveFontSize(30),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              SizedBox(height: context.heightPercentage(3)),

              // Custom Question Button - Centered
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPercentage(20),
                ),
                child: _CustomQuestionButton(
                  onPressed: () => controller.selectQuestion(
                    OracleQuestion(question: '', id: 0, category: ''),
                    readingTypeIndex,
                    deckIndex,
                  ),
                ),
              ),

              SizedBox(height: context.heightPercentage(2.5)),

              // Divider with "or choose a question" text
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPercentage(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing12,
                      ),
                      child: Text(
                        'or choose a question',
                        style: TextStyle(
                          fontSize: context.responsiveFontSize(12),
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.heightPercentage(2)),

              // Questions List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation(Color(0xFFD4AF37)),
                            strokeWidth: 2,
                          ),
                          SizedBox(height: context.spacing16),
                          Text(
                            'Loading questions...',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: context.responsiveFontSize(14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.questions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white.withOpacity(0.4),
                            size: context.responsiveSize(48),
                          ),
                          SizedBox(height: context.spacing16),
                          Text(
                            'No questions available',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: context.responsiveFontSize(16),
                            ),
                          ),
                          SizedBox(height: context.spacing8),
                          Text(
                            'Type your own question above',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: context.responsiveFontSize(14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPercentage(5),
                    ),
                    itemCount: controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = controller.questions[index];
                      return _QuestionTile(
                        question: question.question,
                        onTap: () => controller.selectQuestion(
                          question,
                          readingTypeIndex,
                          deckIndex,
                        ),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: context.heightPercentage(2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== PLAN B: Predefined Questions Screen ====================

class _PlanBScreen extends StatelessWidget {
  final int readingTypeIndex;
  final int deckIndex;

  const _PlanBScreen({
    required this.readingTypeIndex,
    required this.deckIndex,
  });

  // Predefined questions as per Option B specification
  static const List<String> _predefinedQuestions = [
    'What do I need in my life right now?',
    'Lack of clarity and motivation',
    'About my life purpose',
    'About love and relationships',
    'About my work, professional life, and projects',
    'About my financial situation and my relationship with money',
    "Tell me, what's in your mind?", // Open question - always last
  ];

  void _selectQuestion(BuildContext context, int index) {
    final questionText = _predefinedQuestions[index];
    final isOpenQuestion = index == 6; // Last question is the open one

    final question = OracleQuestion(
      id: index + 1,
      category: isOpenQuestion ? 'open' : 'structured',
      question: isOpenQuestion ? '' : questionText,
    );

    Get.to(
          () => QuestionConfirmationScreen(
        readingTypeIndex: readingTypeIndex,
        deckIndex: deckIndex,
        isPlanB: true,
        isOpenQuestion: isOpenQuestion,
      ),
      arguments: question,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: context.heightPercentage(5)),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing24),
                child: Text(
                  AppStrings.instance.askTheOracle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: context.responsiveFontSize(30),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              SizedBox(height: context.heightPercentage(4)),

              // Questions List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPercentage(5),
                  ),
                  itemCount: _predefinedQuestions.length,
                  itemBuilder: (context, index) {
                    final isOpenQuestion = index == 6;
                    final isFirstQuestion = index == 0;

                    return Column(
                      children: [
                        // Add extra spacing before the open question (option 7)
                        if (isOpenQuestion)
                          SizedBox(height: context.heightPercentage(3)),

                        _QuestionTile(
                          question: _predefinedQuestions[index],
                          onTap: () => _selectQuestion(context, index),
                          // First question is default but no visual difference per spec
                          isDefault: isFirstQuestion,
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: context.heightPercentage(2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== SHARED WIDGETS ====================

// Custom Question Button Widget (Plan A only)
class _CustomQuestionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CustomQuestionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing24,
          vertical: context.responsiveSize(12),
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFD4AF37),
              Color(0xFFB8960B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(context.responsiveSize(25)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: context.responsiveSize(20),
            ),
            SizedBox(width: context.spacing8),
            Text(
              'Type Question',
              style: GoogleFonts.inter(
                fontSize: context.responsiveFontSize(14),
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Question Tile Widget - Same styling for all questions (no emphasis differences per spec)
class _QuestionTile extends StatelessWidget {
  final String question;
  final VoidCallback onTap;
  final bool isDefault;

  const _QuestionTile({
    required this.question,
    required this.onTap,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    // Per spec: No color, icon, typography, or emphasis differences allowed
    // All tiles look identical
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.spacing12),
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing16,
          vertical: context.responsiveSize(16),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(context.responsiveSize(12)),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(14),
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.95),
                  height: 1.5,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(width: context.spacing12),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFD4AF37),
              size: context.responsiveSize(16),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: Question Confirmation ====================

class QuestionConfirmationScreen extends StatelessWidget {
  final int readingTypeIndex;
  final int deckIndex;
  final bool isPlanB;
  final bool isOpenQuestion;

  const QuestionConfirmationScreen({
    super.key,
    required this.readingTypeIndex,
    required this.deckIndex,
    this.isPlanB = false,
    this.isOpenQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      QuestionConfirmationController(
        isPlanB: isPlanB,
        isOpenQuestion: isOpenQuestion,
      ),
    );
    AppStrings appStrings = AppStrings.instance;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: context.screenHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: context.heightPercentage(6)),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing32,
                        ),
                        child: Text(
                          appStrings.exploreQuestionPrompt,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontSize: context.responsiveFontSize(26),
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.3,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: context.heightPercentage(6)),

                      // Editable Question TextField
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing24,
                        ),
                        child: TextField(
                          controller: controller.questionController,
                          maxLines: 5,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: context.responsiveFontSize(16),
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.95),
                            height: 1.6,
                            letterSpacing: 0.5,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                context.responsiveSize(16),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                context.responsiveSize(16),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                context.responsiveSize(16),
                              ),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4AF37),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(context.spacing24),
                            hintText: isOpenQuestion
                                ? "What's on your mind?"
                                : appStrings.typeYourQuestionHint,
                            hintStyle: TextStyle(
                              fontSize: context.responsiveFontSize(16),
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.5),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Continue Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing24,
                        ),
                        child: AppButton(
                          buttonText: appStrings.yesContinueButton,
                          onPressed: () {
                            controller.continueToReading(
                              readingTypeIndex,
                              deckIndex,
                            );
                          },
                          fillColor: const Color(0xFFD4AF37),
                          buttonHeight: context.responsiveSize(52),
                          fontSize: context.responsiveFontSize(16),
                          fontWeight: FontWeight.w600,
                          borderRadius: context.responsiveSize(26),
                        ),
                      ),

                      SizedBox(height: context.heightPercentage(4)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== CONTROLLERS ====================

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

          questions.value =
              questionsList.map((q) => OracleQuestion.fromJson(q)).toList();

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

  void selectQuestion(
      OracleQuestion question, int readingTypeIndex, int deckIndex) {
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
  final bool isPlanB;
  final bool isOpenQuestion;

  QuestionConfirmationController({
    this.isPlanB = false,
    this.isOpenQuestion = false,
  });

  @override
  void onInit() {
    super.onInit();
    selectedQuestion = Get.arguments as OracleQuestion;
    // For Plan B open question, start with empty text
    // For Plan B structured questions, pre-fill with the selected question
    // For Plan A, pre-fill with the selected question
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
    print('Is Plan B: $isPlanB');
    print('Is Open Question: $isOpenQuestion');

    // Navigate to ShortBlessingScreen with question ID
    AppNavigation.push(
      Get.context!,
      ShortBlessingScreen(
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
// ==================== MODELS & CONTROLLERS ====================

