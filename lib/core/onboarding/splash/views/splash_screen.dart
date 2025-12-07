import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_assert_image.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.splashImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
