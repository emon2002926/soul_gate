import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/onboarding/splash/views/short_blessing_screen.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../controller/question_confirmation_controller.dart';





class AskOracleScreen extends StatelessWidget {
  final int readingTypeIndex;
  final int deckIndex;
  const AskOracleScreen({super.key, required this.readingTypeIndex, required this.deckIndex});

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
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  AppStrings.instance.askTheOracle,
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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFFD4AF37)),
                      ),
                    );
                  }

                  if (controller.questions.isEmpty) {
                    return Center(
                      child: Text(
                        'No questions available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = controller.questions[index];
                      return _QuestionTile(
                        question: question.question,
                        onTap: () => controller.selectQuestion(question, readingTypeIndex, deckIndex),
                      );
                    },
                  );
                }),
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFD4AF37),
              size: 16,
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
  const QuestionConfirmationScreen({super.key, required this.readingTypeIndex, required this.deckIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionConfirmationController());
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
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          appStrings.exploreQuestionPrompt,
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
                            hintText: appStrings.typeYourQuestionHint,
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
                          buttonText: appStrings.yesContinueButton,
                          onPressed: () {
                            controller.continueToReading(readingTypeIndex, deckIndex);
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
          ),
        ),
      ),
    );
  }
}
