import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../constants/app_assert_image.dart';
import '../../../constants/app_strings.dart';
import '../../../util/app_navigation.dart';
import '../../../widgets/buttons/app_button.dart';


import '../../../widgets/snakbar/custom_snackbar.dart';
import 'onboarding_screen.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    final appStrings = AppStrings.instance;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssertImage.instance.appBackground,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                 SizedBox(height: 30.h),
                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Title
                         AppText(
                          data: appStrings.unlockSoulPath,
                          textAlign: TextAlign.center,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        AppText(
                          data: appStrings.accessUnlimitedReadings,
                          textAlign: TextAlign.center,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                        ),

                        const SizedBox(height: 32),

                        // Subscription Plans
                        Obx(() => _SubscriptionPlanCard(
                          icon: Icons.workspace_premium,
                          name: 'Weekly',
                          price: '\$6.99/week',
                          badge: null,
                          isSelected: controller.selectedPlan.value == 'weekly',
                          onTap: () => controller.selectPlan('weekly'),
                        )),

                        const SizedBox(height: 16),

                        Obx(() => _SubscriptionPlanCard(
                          icon: Icons.workspace_premium,
                          name: 'Monthly',
                          price: '\$12.99/month',
                          badge: null,
                          isSelected: controller.selectedPlan.value == 'monthly',
                          onTap: () => controller.selectPlan('monthly'),
                        )),

                        const SizedBox(height: 16),

                        Obx(() => _SubscriptionPlanCard(
                          icon: Icons.workspace_premium,
                          name: 'Annual',
                          price: '\$39.99/year',
                          badge: 'Save 45%',
                          isSelected: controller.selectedPlan.value == 'annual',
                          onTap: () => controller.selectPlan('annual'),
                        )),

                        const SizedBox(height: 32),

                        // Free Readings Section
                         AppText(
                          data: appStrings.freeReadings,
                          textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                        ),

                        const SizedBox(height: 16),

                        // Free Reading Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              ),
                            );
                          }),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),

                // Bottom Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Column(
                    children: [
                      // Start Trial Button
                      Obx(() =>AppButton(
                        buttonText: appStrings.startFreeTrial,
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.onStartTrial,
                        isLoading: controller.isLoading.value,
                        fillColor: const Color(0xFFBC9041),
                        borderRadius: 26,
                        buttonHeight: 52,
                      )

                      ),

                      const SizedBox(height: 12),

                      // Disclaimer
                      AppText(
                        data: appStrings.trialNoChargeInfo,
                        textAlign: TextAlign.center,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String price;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubscriptionPlanCard({
    required this.icon,
    required this.name,
    required this.price,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1E4B7A).withOpacity(0.6)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF4A9FD8),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Crown Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A574).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD4A574),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFD4A574),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 16),

                // Plan Name
                Expanded(
                  child: AppText(
                    data: name,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                  ),
                ),

                // Price
                AppText(
                  data: price,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                ),
              ],
            ),
          ),

          // Badge (if exists)
          if (badge != null)
            Positioned(
              top: -8,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppText(
                  data:badge!,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Controller
class SubscriptionController extends GetxController {
  final selectedPlan = 'annual'.obs;
  final isLoading = false.obs;

  final plans = [
    {'id': 'weekly', 'name': 'Weekly', 'price': '\$6.99/week', 'badge': null},
    {'id': 'monthly', 'name': 'Monthly', 'price': '\$12.99/month', 'badge': null},
    {'id': 'annual', 'name': 'Annual', 'price': '\$39.99/year', 'badge': 'Save 45%'},
  ];

  void selectPlan(String planId) {
    selectedPlan.value = planId;
  }

  Future<void> onStartTrial() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // // Navigate to next screen or show success
    // Get.snackbar(
    //   'Success',
    //   'Trial started successfully!',
    //   backgroundColor: const Color(0xFFD4A574),
    //   colorText: Colors.white,
    //   snackPosition: SnackPosition.BOTTOM,
    // );



    // Navigate to home or main screen
    // Get.offAll(() => HomeScreen());
    AppNavigation.push(Get.context!, OnboardingScreen());
  }

  void onSkip() {
    // Navigate to home or main screen
    AppNavigation.push(Get.context!, OnboardingScreen());
    // or Get.offAll(() => HomeScreen());
  }
}