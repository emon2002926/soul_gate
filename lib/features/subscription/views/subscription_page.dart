import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/storage_service.dart';



import 'package:http/http.dart' as http;
import 'dart:convert';

import 'checkout_webView.dart';


class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    // final appStrings = AppStrings.instance;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              // AppAssertImage.instance.appBackground,
              'assets/images/app_bg_one.png', // Replace with your asset
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
                  child: Obx(() {
                    if (controller.isLoadingPlans.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xFFD4A574)),
                        ),
                      );
                    }

                    if (controller.plans.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Unable to load subscription plans',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: controller.fetchPlans,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBC9041),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // Title
                            const Text(
                              'Unlock Your Soul Path',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Subtitle
                            Text(
                              'Access unlimited readings and spiritual guidance',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Subscription Plans
                            ...controller.plans.map((plan) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Obx(() => _SubscriptionPlanCard(
                                  icon: Icons.workspace_premium,
                                  name: plan.name,
                                  price: '\$${plan.price}/${_getPricePeriod(plan.planType)}',
                                  badge: _getBadge(plan.planType),
                                  description: plan.description,
                                  features: plan.features,
                                  readingsIncluded: plan.readingsIncluded,
                                  isSelected: controller.selectedPlanId.value == plan.id,
                                  onTap: () => controller.selectPlan(plan.id),
                                )),
                              );
                            }),

                            const SizedBox(height: 32),

                            // Free Readings Section
                            const Text(
                              'Free Readings Available',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                // Bottom Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Column(
                    children: [
                      // Start Trial Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isSubscribing.value
                              ? null
                              : controller.onStartTrial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBC9041),
                            disabledBackgroundColor: const Color(0xFFBC9041).withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: controller.isSubscribing.value
                              ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                  strokeWidth: 2.5,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                              : const Text(
                            'Start Free Trial',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )),

                      const SizedBox(height: 12),

                      // Disclaimer
                      Text(
                        '3-day free trial, then charges apply. Cancel anytime.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.4,
                        ),
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

  String _getPricePeriod(String planType) {
    switch (planType.toLowerCase()) {
      case 'weekly':
        return 'week';
      case 'monthly':
        return 'month';
      case 'annual':
        return 'year';
      default:
        return planType;
    }
  }

  String? _getBadge(String planType) {
    if (planType.toLowerCase() == 'annual') {
      return 'Save 45%';
    }
    return null;
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String price;
  final String? badge;
  final String description;
  final List<String> features;
  final int readingsIncluded;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubscriptionPlanCard({
    required this.icon,
    required this.name,
    required this.price,
    this.badge,
    required this.description,
    required this.features,
    required this.readingsIncluded,
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
                color: isSelected
                    ? const Color(0xFFD4A574)
                    : const Color(0xFF4A9FD8),
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

                // Plan Name & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (readingsIncluded > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          '$readingsIncluded readings included',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Price
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
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
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== MODELS ====================
class SubscriptionPlan {
  final int id;
  final String name;
  final String planType;
  final String price;
  final String description;
  final List<String> features;
  final int readingsIncluded;
  final bool isActive;
  final DateTime createdAt;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.planType,
    required this.price,
    required this.description,
    required this.features,
    required this.readingsIncluded,
    required this.isActive,
    required this.createdAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as int,
      name: json['name'] as String,
      planType: json['plan_type'] as String,
      price: json['price'] as String,
      description: json['description'] as String? ?? '',
      features: List<String>.from(json['features'] ?? []),
      readingsIncluded: json['readings_included'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class StripeCheckoutResponse {
  final bool success;
  final String url;
  final String sessionId;

  StripeCheckoutResponse({
    required this.success,
    required this.url,
    required this.sessionId,
  });

  factory StripeCheckoutResponse.fromJson(Map<String, dynamic> json) {
    return StripeCheckoutResponse(
      success: json['success'] as bool,
      url: json['url'] as String,
      sessionId: json['session_id'] as String,
    );
  }
}

// ==================== CONTROLLER ====================
class SubscriptionController extends GetxController {
  final selectedPlanId = 0.obs;
  final isLoadingPlans = false.obs;
  final isSubscribing = false.obs;
  final RxList<SubscriptionPlan> plans = <SubscriptionPlan>[].obs;

  // Replace with your actual API base URL
  static const String baseUrl = 'https://sofiapi.dsrt321.online/api';

  String?  authToken = StorageService.accessToken;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoadingPlans.value = true;

      final response = await http.get(
        Uri.parse('$baseUrl/subscriptions/plans/?lang=en'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List;

        plans.value = results
            .map((planJson) => SubscriptionPlan.fromJson(planJson))
            .where((plan) => plan.isActive)
            .toList();

        // Auto-select annual plan if available
        final annualPlan = plans.firstWhereOrNull(
              (plan) => plan.planType.toLowerCase() == 'annual',
        );
        if (annualPlan != null) {
          selectedPlanId.value = annualPlan.id;
        } else if (plans.isNotEmpty) {
          selectedPlanId.value = plans.first.id;
        }
      } else {
        _showError('Failed to load plans. Please try again.');
      }
    } catch (e) {
      print('Error fetching plans: $e');
      _showError('Connection error. Please check your internet.');
    } finally {
      isLoadingPlans.value = false;
    }
  }

  void selectPlan(int planId) {
    selectedPlanId.value = planId;

  }

  Future<void> onStartTrial() async {
    if (selectedPlanId.value == 0) {
      _showError('Please select a subscription plan');
      return;
    }



    try {
      isSubscribing.value = true;

      final response = await http.post(
        Uri.parse('$baseUrl/subscriptions/stripe/create/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'plan_id': selectedPlanId.value,
          'payment_mode': 'card',
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final checkoutResponse = StripeCheckoutResponse.fromJson(responseData);

        AppNavigation.push(Get.context!,  CheckoutWebView(url: checkoutResponse.url));

        if (checkoutResponse.success && checkoutResponse.url.isNotEmpty) {
          // Navigate to WebView for checkout

        } else {
          _showError('Unable to initiate checkout. Please try again.');
        }
      } else if (response.statusCode == 401) {
        _showError('Session expired. Please login again.');
      } else {
        _showError('Unable to process subscription. Please try again.');
      }
    } catch (e) {
      print('Error creating subscription: $e');
      _showError('Connection error. Please check your internet.');
    } finally {
      isSubscribing.value = false;
    }
  }

  void onSkip() {
    // Navigate to onboarding or home
    // AppNavigation.push(Get.context!, const OnboardingScreen());
    Get.offAllNamed('/home'); // Or your appropriate route
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}