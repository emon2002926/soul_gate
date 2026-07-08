import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/util/screen_size.dart';
import 'package:soul_gate/core/widgets/snakbar/custom_snackbar.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/onboarding/splash/views/short_blessing_screen.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../profile/views/profile_page.dart';

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

  const AskOracleScreen({
    super.key,
    required this.readingTypeIndex,
    required this.deckIndex,
  });



  void _selectQuestion(BuildContext context, int index) {
    final questionText = AppStrings.predefinedQuestions[index];
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
        isOpenQuestion: isOpenQuestion,
      ),
      arguments: question,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Reading Type Index: $readingTypeIndex');
    print('Deck Index: $deckIndex');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BuildAppBar(
        showSideButton: true,
        sideButtonIcon: Icons.account_circle_outlined,
        onSideButtonPressed: ()=>AppNavigation.push(Get.context!, ProfilePage()),
        onBackButtonPrassed: (){
          Navigator.pop(context);
        },
      ),
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
                  itemCount: AppStrings.predefinedQuestions.length,
                  itemBuilder: (context, index) {
                    final isOpenQuestion = index == 6;
                    final isFirstQuestion = index == 0;

                    return Column(
                      children: [
                        // Add extra spacing before the open question (option 7)
                        if (isOpenQuestion)
                          SizedBox(height: context.heightPercentage(3)),

                        _QuestionTile(
                          question: AppStrings.predefinedQuestions[index],
                          onTap: () => _selectQuestion(context, index),
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
    // No color, icon, typography, or emphasis differences
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
  final bool isOpenQuestion;

  const QuestionConfirmationScreen({
    super.key,
    required this.readingTypeIndex,
    required this.deckIndex,
    this.isOpenQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      QuestionConfirmationController(
        isOpenQuestion: isOpenQuestion,
      ),
    );
    AppStrings appStrings = AppStrings.instance;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BuildAppBar(
        showSideButton: true,
        sideButtonIcon: Icons.account_circle_outlined,
        onSideButtonPressed: ()=>AppNavigation.push(Get.context!, ProfilePage()),
        onBackButtonPrassed: (){
          Navigator.pop(context);
        },
      ),
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

                      // Display Selected Question
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing32,
                        ),
                        child: Text(
                          controller.selectedQuestion.question.isNotEmpty
                              ? controller.selectedQuestion.question
                              : "What's on your mind?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: context.responsiveFontSize(26),
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.3,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: context.heightPercentage(3)),

                      // Subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing32,
                        ),
                        child: Text(
                          appStrings.exploreQuestionPrompt,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: context.responsiveFontSize(18),
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.3,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      SizedBox(height: context.heightPercentage(4)),

                      // Editable Question TextField (More Visible)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing24,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              context.responsiveSize(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller.questionController,
                            maxLines: 6,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.responsiveFontSize(16),
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.6,
                              letterSpacing: 0.5,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  context.responsiveSize(16),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  context.responsiveSize(16),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  context.responsiveSize(16),
                                ),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD4AF37),
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(context.spacing24),
                              hintText: isOpenQuestion
                                  ? "What's on your mind?"
                                  : appStrings.typeYourQuestionHint,
                              hintStyle: TextStyle(
                                fontSize: context.responsiveFontSize(16),
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.6),
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ),

                       SizedBox(
                        height: context.heightPercentage(10),
                      ),

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
                                controller.selectedQuestion.question
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

class QuestionConfirmationController extends GetxController {
  final questionController = TextEditingController();
  late OracleQuestion selectedQuestion;
  final bool isOpenQuestion;

  QuestionConfirmationController({
    this.isOpenQuestion = false,
  });

  @override
  void onInit() {
    super.onInit();
    selectedQuestion = Get.arguments as OracleQuestion;
    // TextField starts empty - user can edit/rephrase the question
    questionController.text = '';
  }

  void continueToReading(
      int readingTypeIndex,
      int deckIndex,
      String questions,
      ) {
    final question = questionController.text.trim();

    String  fullQuestion= "$questions and is $question";
    if (question.isEmpty) {
      CustomSnackBar.error('Please enter a question before continuing',);
      return;
    }

    print('Selected Question ID: ${selectedQuestion.id}');
    print('Selected Question Text: $question');
    print('Is Open Question: $isOpenQuestion');

    // Navigate to ShortBlessingScreen with question ID
    AppNavigation.push(
      Get.context!,
      ShortBlessingScreen(
        questionText: fullQuestion,
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
