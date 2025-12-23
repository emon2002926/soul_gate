import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/onboarding/splash/views/short_blessing_screen.dart';
import '../../../core/widgets/buttons/app_button.dart';

class AskOracleScreen extends StatelessWidget {
  const AskOracleScreen({super.key});

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
              const SizedBox(height: 40),

              // Title
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Ask the Oracle',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Questions List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: oracleQuestions.length,
                  itemBuilder: (context, index) {
                    final question = oracleQuestions[index];
                    return _QuestionTile(
                      question: question,
                      onTap: () => controller.selectQuestion(question),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Question Tile Widget
class _QuestionTile extends StatelessWidget {
  final String question;
  final VoidCallback onTap;

  const _QuestionTile({
    required this.question,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.95),
                  height: 1.4,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFD4AF37),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: Question Confirmation with Editable TextField ====================
class QuestionConfirmationScreen extends StatelessWidget {
  const QuestionConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionConfirmationController());

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
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Title
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Is this the question\nyou want to explore?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.3,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Editable Question TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextField(
                    controller: controller.questionController,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.6,
                      letterSpacing: 0.5,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFD4AF37),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(24),
                      hintText: 'Type your question here...',
                      hintStyle: TextStyle(
                        fontSize: 16,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AppButton(
                    buttonText: 'Yes, continue',
                    onPressed: () {
                      controller.continueToReading();
                    },
                    fillColor: const Color(0xFFD4AF37).withOpacity(0.85),
                    buttonHeight: 56,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== Data ====================

final List<String> oracleQuestions = [
  'What truth do you need to see today about your love life or an important relationship?',
  'What do you need to understand about your financial situation or your relationship with money?',
  'In what area of your life purpose do you need greater clarity or direction?',
  'Which part of your emotional world is asking for light and balance at this moment?',
  'Which pending decision needs clarity, perspective, or confirmation?',
  'What do you need to understand about a family dynamic or a meaningful connection?',
  'Which aspect of your work or project requires guidance or a strategic adjustment?',
  'What message are your guides trying to give you today about your spiritual growth?',
  'What blockage do you need to identify in order to move forward with greater strength and authenticity?',
  'What is the most important thing you need to know about the next 30 days of your life?',
  'What direction is life encouraging me to move toward next?',
];

// ==================== Controllers ====================

class AskOracleController extends GetxController {
  void selectQuestion(String question) {
    // Navigate to confirmation screen with selected question
    Get.to(
          () => const QuestionConfirmationScreen(),
      arguments: question, // Pass the question as argument
    );
  }
}

class QuestionConfirmationController extends GetxController {
  final questionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Get the question from the previous screen
    final selectedQuestion = Get.arguments as String?;
    if (selectedQuestion != null) {
      questionController.text = selectedQuestion;
    }
  }

  void continueToReading() {
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

    // Save the question and navigate to the next screen
    print('Selected Question: $question');

    // Navigate to shuffle screen or next step
    AppNavigation.push(Get.context!, ShortBlessingScreen());
    // Or if you want to pass the question to the next screen:
    // Get.to(() => ShuffleScreen(question: question));
  }

  @override
  void onClose() {
    questionController.dispose();
    super.onClose();
  }
}