import 'dart:async';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/features/auth/views/otp_verification_screen.dart';
import '../../../../core/util/storage_service.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../features/auth/views/sing_in_screen.dart';
import '../../../../main_page.dart';
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
        // AppNavigation.pushAndClear(Get.context!, ShuffleScreen());
        AppNavigation.pushAndClear(Get.context!, OnboardingScreen());
      } else {
        // No token, navigate to onboarding

        // AppNavigation.pushAndClear(Get.context!, OtpVerificationScreen());

        AppNavigation.pushAndClear(Get.context!, MainPage());
      }
    });
  }

}