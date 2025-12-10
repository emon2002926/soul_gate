import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/features/card_reading/views/shuffle_screen.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/app_navigation.dart';
import 'closing_screen.dart';

class QuestionScreen extends StatelessWidget {
  final QuestionController controller = Get.put(QuestionController());
  final TextEditingController textController = TextEditingController();

  QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: 80),

                        // Title with elegant styling
                        Text(
                          'DO YOU HAVE ANY\nQUESTION OR DOUBTS?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                            letterSpacing: 1.2,
                          ),
                        ),

                        SizedBox(height: 60),

                        // Question input field with underline design
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: textController,
                              onChanged: (value) {
                                controller.updateQuestion(value);
                              },
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                              minLines: 1,
                              maxLines: 5,
                              maxLength: 500,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText:
                                'What do I most need to understand about my\ncurrent situation?',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                counterText: '', // Hide character counter
                              ),
                            ),
                            // Underline
                            Container(
                              height: 1.5,
                              margin: EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),

                // Bottom buttons with updated styling
                Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 30,
                  ),
                  child: Column(
                    children: [
                      // Yes, continue button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            AppNavigation.push(context, ShuffleScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD4A574),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Yes, continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // No, Thanks button with transparent background
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            AppNavigation.push(context, ClosingScreen());
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            side: BorderSide(
                              color: Color(0xFFD4A574),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'No, Thanks',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD4A574),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionController extends GetxController {
  final questionText = ''.obs;
  final showKeyboard = false.obs;

  void updateQuestion(String text) {
    questionText.value = text;
  }

  void submitQuestion() {
    if (questionText.value.trim().isEmpty) {
      Get.snackbar(
        'Empty Question',
        'Please enter your question',
        backgroundColor: Color(0xFFD4A574),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Navigate to next screen or process the question
    Get.snackbar(
      'Question Submitted',
      'Your question: ${questionText.value}',
      backgroundColor: Color(0xFFD4A574),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    // You can navigate to the shuffle screen or process the question
    // Get.to(() => ShuffleScreen());
  }

  void skipQuestion() {
    // Navigate without question
    Get.snackbar(
      'Skipped',
      'Continuing without a question',
      backgroundColor: Color(0xFFD4A574),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    // Navigate to next screen
    // Get.to(() => ShuffleScreen());
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}