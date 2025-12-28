import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import 'ask_oracle_screen.dart';


class PortalEntranceScreen extends StatelessWidget {
  final int readingTypeIndex;
  final int deckIndex;

  const PortalEntranceScreen({
    super.key,
    required this.readingTypeIndex,
    required this.deckIndex,
  });

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
              SizedBox(height: context.heightPercentage(5)), // ~5% of screen height

              // Title
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing32,
                ),
                child: Text(
                  appStrings.stepIntoThePortal,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: context.responsiveFontSize(36),
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
                  width: context.widthPercentage(90), // 90% of screen width
                  height: context.heightPercentage(55), // 55% of screen height
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              // Bottom Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing24,
                ),
                child: AppButton(
                  buttonText: appStrings.enterThePortal,
                  onPressed: () {
                    // Navigate to main app or home screen
                    AppNavigation.push(
                      context,
                      AskOracleScreen(
                        readingTypeIndex: readingTypeIndex,
                        deckIndex: deckIndex,
                      ),
                    );
                  },
                  fillColor: const Color(0xFFD4AF37).withOpacity(0.85),
                  buttonHeight: 52,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: context.heightPercentage(4)), // ~4% of screen height
            ],
          ),
        ),
      ),
    );
  }
}