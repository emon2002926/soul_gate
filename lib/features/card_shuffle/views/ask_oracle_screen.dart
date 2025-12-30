import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/core/util/screen_size.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/onboarding/splash/views/short_blessing_screen.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../controller/question_confirmation_controller.dart';

class AskOracleScreen extends StatelessWidget {
  final int readingTypeIndex;
  final int deckIndex;
  const AskOracleScreen({
    super.key,
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
              SizedBox(height: context.heightPercentage(5)),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing32),
                child: Text(
                  AppStrings.instance.askTheOracle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: context.responsiveFontSize(32),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              SizedBox(height: context.heightPercentage(1.5)),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: context.widthPercentage(5.3),
                ),
                child: Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: //Custome Button
                  SizedBox(
                    width: context.widthPercentage(40),
                    height: 40,
                    child: AppButton(
                      buttonText: 'Type Question',
                      onPressed: () => controller.selectQuestion(
                        OracleQuestion(question: '', id: 0, category: ''),
                        readingTypeIndex,
                        deckIndex,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.heightPercentage(2)),
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
                          fontSize: context.responsiveFontSize(16),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPercentage(5.3),
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

// Question Tile Widget
class _QuestionTile extends StatelessWidget {
  final String question;
  final VoidCallback onTap;

  const _QuestionTile({required this.question, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.spacing12),
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing16,
          vertical: context.responsiveSize(14),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(context.responsiveSize(12)),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
                  height: 1.4,
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
  const QuestionConfirmationScreen({
    super.key,
    required this.readingTypeIndex,
    required this.deckIndex,
  });

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
                  minHeight:
                      context.screenHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: context.heightPercentage(7.5)),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing32,
                        ),
                        child: Text(
                          appStrings.exploreQuestionPrompt,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontSize: context.responsiveFontSize(28),
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.3,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: context.heightPercentage(7.5)),

                      // Editable Question TextField
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing32,
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
                            hintText: appStrings.typeYourQuestionHint,
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
                          fillColor: const Color(0xFFD4AF37).withOpacity(0.85),
                          buttonHeight: context.responsiveSize(50),
                          fontSize: context.responsiveFontSize(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: context.heightPercentage(5)),
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
