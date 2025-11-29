import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_assert_image.dart';
import '../controller/ask_oracle_controller.dart';


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
          child: Obx(() {
            switch (controller.currentStep.value) {
              case 0:
                return _AskQuestionPage(controller: controller);
              case 1:
                return _ConfirmQuestionPage(controller: controller);
              case 2:
                return _ShufflePage(controller: controller);
              default:
                return _AskQuestionPage(controller: controller);
            }
          }),
        ),
      ),
    );
  }
}


class _AskQuestionPage extends StatelessWidget {
  final AskOracleController controller;

  const _AskQuestionPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Title
         Text(
          'Ask the Oracle',
          style: GoogleFonts.cinzel(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Gold
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 30),

        // Suggested Questions List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: suggestedQuestions.length,
            itemBuilder: (context, index) {
              final question = suggestedQuestions[index];
              return _QuestionItem(
                question: question,
                onTap: () {
                  controller.selectQuestion(question);
                  controller.goToConfirmation();
                },
              );
            },
          ),
        ),

        // Custom Input Field
        Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.questionController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'What is in your mind?',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (_) => controller.submitCustomQuestion(),
                  ),
                ),
                // Mic Button
                IconButton(
                  onPressed: () {
                    // Voice input functionality
                  },
                  icon: Icon(
                    Icons.mic_none,
                    color: const Color(0xFFD4AF37).withOpacity(0.8),
                    size: 24,
                  ),
                ),
                // Send Button
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: controller.submitCustomQuestion,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_right,
                        color: const Color(0xFFD4AF37),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}



class _QuestionItem extends StatelessWidget {
  final String question;
  final VoidCallback onTap;

  const _QuestionItem({
    required this.question,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Text
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Arrow Icon
            Icon(
              Icons.double_arrow,
              color: const Color(0xFFD4AF37),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}


class _ConfirmQuestionPage extends StatelessWidget {
  final AskOracleController controller;

  const _ConfirmQuestionPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Title
           Text(
            'Is this the question\nyou want to explore?',
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Gold
              letterSpacing: 1.5,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 40),

          // Selected Question
          Obx(() => Text(
            controller.selectedQuestion.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.85),
              height: 1.5,
            ),
          )),

          const Spacer(flex: 3),

          // Buttons Row
          Row(
            children: [
              // Edit Button
              Expanded(
                child: _OutlinedButton(
                  text: 'Edit',
                  onPressed: controller.editQuestion,
                ),
              ),
              const SizedBox(width: 16),
              // Yes, Continue Button
              Expanded(
                child: _FilledButton(
                  text: 'Yes, continue',
                  onPressed: controller.confirmAndContinue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}


class _ShufflePage extends StatelessWidget {
  final AskOracleController controller;

  const _ShufflePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Top Text
          Text(
            'Your reading is about to begin',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),

          const Spacer(flex: 2),

          // Center Text
          Text(
            'SHUFFLE THE CARDS WHEN YOU\'RE\nREADY.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 2,
              height: 1.5,
            ),
          ),

          const Spacer(flex: 3),

          // Shuffle Button
          SizedBox(
            width: double.infinity,
            child: _FilledButton(
              text: 'Shuffle',
              onPressed: controller.startShuffle,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}


class _FilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _FilledButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37).withOpacity(0.85),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _OutlinedButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFD4AF37),
          side: BorderSide(
            color: const Color(0xFFD4AF37).withOpacity(0.6),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}