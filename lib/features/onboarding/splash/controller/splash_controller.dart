import 'dart:async';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/util/storage_service.dart';
import 'package:get_storage/get_storage.dart';

import '../../../auth/views/sing_in_screen.dart';
import '../../../home/views/home_page.dart';

class SplashController extends GetxController {
  final box = GetStorage();  // GetStorage instance

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      String? accessToken = StorageService.accessToken;
      String? userRole = StorageService.userRole;

      if (accessToken != null && accessToken.isNotEmpty) {
        // If access token exists, check user role and navigate accordingly
        AppNavigation.push(Get.context!, ShuffleScreen());
      } else {
        // No token, navigate to onboarding
        AppNavigation.push(Get.context!, ShuffleScreen());
      }
    });
  }

}