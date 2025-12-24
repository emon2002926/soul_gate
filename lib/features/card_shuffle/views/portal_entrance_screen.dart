import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/buttons/app_button.dart';
import 'ask_oracle_screen.dart';


class PortalEntranceScreen extends StatelessWidget {
  const PortalEntranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppStrings appStrings = AppStrings.instance;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40), // Reduced from 80

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  appStrings.stepIntoThePortal,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 36, // Reduced from 38
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const Spacer(),

              // Portal/Lotus Image
              Flexible(
                child: Image.asset(
                  AppAssertImage.instance.portalImage,
                  width: double.infinity,
                  height: 480, // Reduced from 480
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppButton(
                  buttonText: appStrings.enterThePortal,
                  onPressed: () {
                    // Navigate to main app or home screen
                    AppNavigation.push(context, AskOracleScreen());
                  },
                  fillColor: const Color(0xFFD4AF37).withOpacity(0.85),
                  buttonHeight: 52, // Reduced from 56
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30), // Reduced from 40
            ],
          ),
        ),
      ),
    );
  }
}