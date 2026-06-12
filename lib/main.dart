import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'core/onboarding/splash/controller/splash_controller.dart';
import 'core/onboarding/splash/views/splash_screen.dart';
import 'core/routes/app_routes_file.dart';
import 'package:get/get.dart';

import 'features/auth/view_models/sign_in_controller.dart';


Future<void> main() async {
  await GetStorage.init();
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => LoginController());


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar icons to white throughout the app
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MainEntryApp());
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
            theme: ThemeData(
              // Ensure status bar styling is applied to all AppBars
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
              ),
            ),
            home: const SplashScreen(),
            getPages: appRootRoutesFile,
          );
        },
      );
    }
  }