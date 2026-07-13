import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/features/profile/views/profile_page.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import 'package:get/get.dart';
import '../../../core/onboarding/splash/views/onboarding_screen.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../controllers/closing_controller.dart';

class ClosingScreen extends StatelessWidget {
  const ClosingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ClosingController controller = Get.put(ClosingController());
    final AppStrings appStrings = AppStrings.instance;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BuildAppBar(
        onBackButtonPrassed: (){Navigator.pop(context);},
        onSideButtonPressed: (){AppNavigation.push(context, ProfilePage());},
        title: "closing screen",
        showSideButton: true,
        sideButtonIcon: Icons.account_circle_outlined,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      Text(
                        appStrings.thankYouGuidance,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        appStrings.closeReadingWithGratitude,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        appStrings.insightsSupportHighestGood,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        appStrings.soBeIt,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        appStrings.insightsSupportLast,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom Buttons ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Subscription Button
                    // GestureDetector(
                    //   onTap: controller.goToSubscription,
                    //   child: Container(
                    //     width: double.infinity,
                    //     padding: const EdgeInsets.symmetric(vertical: 16),
                    //     decoration: BoxDecoration(
                    //       gradient: const LinearGradient(
                    //         colors: [
                    //           Color(0xFFD4A574),
                    //           Color(0xFFB8956A),
                    //         ],
                    //       ),
                    //       borderRadius: BorderRadius.circular(12),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: const Color(0xFFD4A574).withOpacity(0.4),
                    //           blurRadius: 12,
                    //           offset: const Offset(0, 4),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         const Icon(
                    //           Icons.star_rounded,
                    //           color: Colors.white,
                    //           size: 24,
                    //         ),
                    //         const SizedBox(width: 10),
                    //         Text(
                    //           'Go to Subscription',
                    //           style: GoogleFonts.cinzel(
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w600,
                    //             color: Colors.white,
                    //             letterSpacing: 1.2,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 16),

                    // Contact Support Button
                    GestureDetector(
                      onTap: controller.openSupportEmail,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.mail_outline_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Share Your Thoughts',
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: (){
                        AppNavigation.pushAndClear(Get.context!, OnboardingScreen());

                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            const SizedBox(width: 10),
                            Text(
                              'Start over again ',
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}