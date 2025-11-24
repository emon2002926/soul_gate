import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'core/routes/app_routes_file.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

import 'features/onboarding/splash/views/splash_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await GetStorage.init();
  Get.lazyPut(() => SplashController());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MainEntryApp());
}

class MainEntryApp extends StatelessWidget {
  const MainEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(), // Changed from HomeScreen to SplashScreen
          getPages: appRootRoutesFile,
        );
      },
    );
  }
}