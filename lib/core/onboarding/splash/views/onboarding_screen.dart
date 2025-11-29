import 'package:flutter/material.dart';
import '../../../constants/app_assert_image.dart';
import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';
import 'ask_oracle_screen.dart';




class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

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
              // PageView Content
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) => controller.currentPage.value = index,
                  itemCount: onboardingPages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPage(data: onboardingPages[index]);
                  },
                ),
              ),

              // Page Indicator
              Obx(() => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: controller.currentPage.value == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? const Color(0xFFD4AF37) // Gold
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              )),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Obx(() {
                  final isLastPage = controller.currentPage.value == onboardingPages.length - 1;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isLastPage) {
                          // Navigate to Sign In
                          Get.offAll(() => const AskOracleScreen());
                        } else {
                          controller.nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37).withOpacity(0.85),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        onboardingPages[controller.currentPage.value].buttonText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: Color(0xFFD4AF37), // Gold color
              height: 1.2,
              letterSpacing: 1.5,
            ),
          ),

          // Subtitle (if exists)
          if (data.subtitle != null) ...[
            const SizedBox(height: 16),
            Text(
              data.subtitle!.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ],

          // Description (if exists)
          if (data.description != null) ...[
            const SizedBox(height: 40),
            Text(
              data.description!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
                height: 1.6,
                letterSpacing: 0.5,
              ),
            ),
          ],

          // Features List (if exists)
          if (data.features != null) ...[
            const SizedBox(height: 40),
            ...data.features!.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    feature.icon,
                    color: Colors.white.withOpacity(0.8),
                    size: 22,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      feature.text.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],

          // Portal Image (for last page)
          if (data.showPortal) ...[
            const Spacer(),
            Center(
              child: Image.asset(
                AppAssertImage.instance.onboardingImage1, // Add portal image to your AppAssertImage class
                width: 220,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
          ],
        ],
      ),
    );
  }
}
