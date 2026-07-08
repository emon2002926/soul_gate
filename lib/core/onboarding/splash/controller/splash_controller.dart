import 'dart:async';
import 'package:get/get.dart';
import 'package:soul_gate/core/routes/app_routes.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../../core/util/storage_service.dart';
import 'package:get_storage/get_storage.dart';
import '../views/onboarding_screen.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      String? accessToken = StorageService.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        AppNavigation.pushAndClear(Get.context!, OnboardingScreen());

        // AppNavigation.pushAndClear(Get.context!, SubscriptionPage());

      } else {
        // No token, navigate to onboarding

        // Get.offAllNamed(AppRoutes.login);
        Get.offAllNamed(AppRoutes.login);

        // AppNavigation.pushAndClear(Get.context!, SubscriptionPage());

        // AppNavigation.pushAndClear(Get.context!, MainPage());
        // AppNavigation.pushAndClear(Get.context!, SubscriptionPage());
      }
    });
  }

}