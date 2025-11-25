import 'package:flutter/material.dart';

import '../../../../core/constants/app_assert_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/app_navigation.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../../features/auth/views/sing_in_screen.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../onboarding/data/onboarding_data.dart';
import '../controller/onboarding_controller.dart';




class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingController controller;



  @override
  void initState() {
    super.initState();
    controller = OnboardingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.instance.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Logo
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Qube',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.instance.titleTextColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) {
                  setState(() {
                    controller.currentPage = index;
                  });
                },
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: onboardingPages[index],
                  );
                },
              ),
            ),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage == index
                        ? AppColors.instance.titleTextColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Skip Button
                  // Container(
                  //   width: 140,
                  //   height: 60,
                  //   margin: const EdgeInsets.only(right: 12),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       controller.skipOnboarding();
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.white,
                  //       foregroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       elevation: 0,
                  //       shadowColor: Colors.transparent,
                  //       padding: EdgeInsets.zero,
                  //     ),
                  //     child:  AppText(
                  //       data: 'Skip',
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w700,
                  //       color: AppColors.instance.titleTextColor,
                  //     ),
                  //   ),
                  // ),

                  // Next Button
                  Expanded(
                    child: AppButton(
                      buttonText: 'Next',
                      onPressed: () {
                        if (controller.currentPage == 2) {
                          // Navigate to main app
                          AppNavigation.push(context, const SingInScreen());
                        } else {
                          controller.nextPage();
                        }
                      },

                      textColor: Colors.white,

                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      elevation: 8,
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Individual Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          AppText(
            data:data.title,
            textAlign: TextAlign.center,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color:const Color(0xFF363A33),
            height: 1.2,

          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}


