import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controllers using Get.put() or Get.lazyPut() in main.dart for better optimization
    final controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AppText(
            data: 'Deal Detector',
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),

        ),
      ),
    );
  }
}
