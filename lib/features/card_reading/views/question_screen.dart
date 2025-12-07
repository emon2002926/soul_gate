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
            // Optional: Add a dark overlay for better text readability
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SizedBox(height: 60),

                          // Title
                          Text(
                         'DO YOU HAVE ANY\nQUESTION OR DOUBTS?',
                           style: GoogleFonts.cinzel(
                             fontSize: 28,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                          ),

                          SizedBox(height: 40),

                          // Question input field
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: textController,
                              onChanged: (value) {
                                controller.updateQuestion(value);
                              },
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                'What do I most need to understand about my current situation?',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),

                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Yes, continue button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // controller.submitQuestion();
                            AppNavigation.push(context, ShuffleScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD4A574),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Yes, continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // No, Thanks button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // controller.skipQuestion();
                            AppNavigation.push(context, ClosingScreen());
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(
                              color: Color(0xFFD4A574),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'No, Thanks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD4A574),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
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