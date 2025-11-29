import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_assert_image.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/text/app_text.dart';
import '../controller/subscription_controller.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssertImage.instance.appBackground, // Your background image
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: controller.onSkip,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const AppText(
                          data: 'SKIP',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Title
                        const AppText(
                          data: 'UNLOCK YOUR FULL',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                        const AppText(
                          data: 'SOUL PATH',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        AppText(
                          data: 'Access Unlimited Readings, Voice Guidance, And Deeper Spiritual Clarity.',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          textAlign: TextAlign.center,
                          height: 1.5,
                        ),

                        const SizedBox(height: 32),

                        // Subscription Plans
                        ...controller.plans.map((plan) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Obx(() => _SubscriptionPlanCard(
                            name: plan['name'] as String,
                            price: plan['price'] as String,
                            badge: plan['badge'] as String?,
                            isSelected: controller.selectedPlan.value == plan['id'],
                            onTap: () => controller.selectPlan(plan['id'] as String),
                          )),
                        )),

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
                      Obx(() => AppButton(
                        buttonText: 'Start Your 7-Day Free Trial',
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.onStartTrial,
                        isLoading: controller.isLoading.value,
                        fillColor: const Color(0xFFBC9041),
                        borderRadius: 26,
                        buttonHeight: 52,
                      )),

                      const SizedBox(height: 16),

                      // Disclaimer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFFBC9041),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: AppText(
                              data: "You won't be charged until the end of the trial. Cancel anytime.",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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

// ============================================================================
// PRIVATE WIDGETS
// ============================================================================

class _SubscriptionPlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubscriptionPlanCard({
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFFF8E7)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFBC9041)
                    : Colors.white.withOpacity(0.5),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Crown Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFBC9041).withOpacity(0.15)
                        : Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Color(0xFFBC9041),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Plan Name
                Expanded(
                  child: AppText(
                    data: name,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF2D2D2D)
                        : Colors.white,
                  ),
                ),

                // Price
                AppText(
                  data: price,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFF2D2D2D)
                      : Colors.white,
                ),
              ],
            ),
          ),

          // Badge (if exists)
          if (badge != null)
            Positioned(
              top: -10,
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
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppText(
                  data: badge!,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
            ),
        ],
      ),
    );
  }
}