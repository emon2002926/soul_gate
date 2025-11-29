import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';


class BlessingFlowController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final questionController = TextEditingController();
  final isLoading = false.obs;

  final List<String> titles = [
    'We Begin in Light',
    'Short Blessing',
    'Question',
  ];

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void onContinue() {
    if (currentPage.value == 2) {
      // Final step - validate and proceed to reading
      if (questionController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your question',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      // TODO: Navigate to tarot reading screen with question
      Get.snackbar('Reading', 'Starting your reading...');
    } else {
      nextPage();
    }
  }

  String get buttonText {
    switch (currentPage.value) {
      case 0:
        return 'Go to Blessing';
      case 1:
        return 'Enter the Reading';
      case 2:
        return 'Continue';
      default:
        return 'Continue';
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    questionController.dispose();
    super.onClose();
  }
}


class BlessingFlowPage extends StatelessWidget {
  const BlessingFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlessingFlowController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => BuildAppBar(
          title: controller.titles[controller.currentPage.value],
          titleColor: Colors.white,
          iconColor: Colors.white,
          showBackButton: true,
          backgroundColor: Colors.transparent,
          titleSize: 18,
          fontWeight: FontWeight.w600,
        )),
      ),
      body: Column(
        children: [
          // Page View
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                _IntroPage(),
                _BlessingPage(),
                _QuestionPage(controller: controller),
              ],
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Obx(() => AppButton(
              buttonText: controller.buttonText,
              onPressed: controller.isLoading.value
                  ? null
                  : controller.onContinue,
              isLoading: controller.isLoading.value,
              fillColor: const Color(0xFFBC9041),
              borderRadius: 26,
              buttonHeight: 52,
            )),
          ),

          const SizedBox(height: 80), // Space for bottom nav
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 1: INTRO PAGE
// ============================================================================

class _IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Introduction Text
          const AppText(
            data: 'We start under the protection of Saint Michael, keeper of clarity and truth.',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            textAlign: TextAlign.center,
            height: 1.6,
          ),

          const SizedBox(height: 24),

          // Blessing Text
          const AppText(
            data: 'May this space be guarded.',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          const AppText(
            data: 'May truth appear gently, without harm.',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Meditation Image
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(
                'assets/images/meditation_mandala.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 2: BLESSING PAGE
// ============================================================================

class _BlessingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Blessing Text with Rich Text
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.8,
              ),
              children: [
                const TextSpan(
                  text: 'In this present moment, ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const TextSpan(
                  text: 'I open this Tarot session with intention and clarity.\n',
                ),
                const TextSpan(
                  text: 'I connect with my wiser Self, my guides, Father–Mother God from Source, and Archangel Michael.\n',
                ),
                const TextSpan(
                  text: 'Protect this space and reveal only what supports my highest good, evolution, and truth.\n',
                ),
                const TextSpan(
                  text: 'Thank you, thank you, thank you — and so be it.',
                ),
              ],
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 3: QUESTION PAGE
// ============================================================================

class _QuestionPage extends StatelessWidget {
  final BlessingFlowController controller;

  const _QuestionPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Title
          const Center(
            child: AppText(
              data: 'What would you like to ask?',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Question Input Field
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller.questionController,
              maxLines: 5,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'What is the deeper truth behind..',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}