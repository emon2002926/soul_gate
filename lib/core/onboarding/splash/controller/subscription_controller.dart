import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SubscriptionController extends GetxController {
  final selectedPlan = 'annual'.obs; // Default selection
  final isLoading = false.obs;

  final plans = [
    {
      'id': 'weekly',
      'name': 'Weekly',
      'price': '\$6.99/week',
      'badge': null,
    },
    {
      'id': 'monthly',
      'name': 'Monthly',
      'price': '\$12.99/month',
      'badge': null,
    },
    {
      'id': 'annual',
      'name': 'Annual',
      'price': '\$39.99/year',
      'badge': 'Save 45%',
    },
  ];

  void selectPlan(String planId) {
    selectedPlan.value = planId;
  }

  void onSkip() {
    Get.back();
  }

  Future<void> onStartTrial() async {
    isLoading.value = true;

    try {
      // TODO: Implement subscription logic
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Starting your 7-day free trial for ${selectedPlan.value} plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to start trial. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
