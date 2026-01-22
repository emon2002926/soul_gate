import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/util/app_navigation.dart';
import '../../subscription/views/subscription_page.dart';

class ClosingScreen extends StatelessWidget {
  const ClosingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings appStrings = AppStrings.instance;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60,horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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

                    SizedBox(height: 24),

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

                    SizedBox(height: 24),

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

                    SizedBox(height: 24),

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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Subscription Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            child: GestureDetector(
                              onTap: () {
                                AppNavigation.push(context, const SubscriptionPage());
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD4A574),
                                      Color(0xFFB8956A),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFD4A574).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Go to Subscription',
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
                          ),

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
                          // Bottom wave decoration
                          // _buildBottomWave(),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),

            // Bottom section with wave and button
          ],
        ),
      ),
    );
  }

  // Widget _buildBottomWave() {
  //   return ClipPath(
  //     clipper: WaveClipper(),
  //     child: Container(
  //       height: 150,
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           colors: [
  //             Color(0xFF1A2332),
  //             Color(0xFF0D1520),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// Wave clipper for bottom decoration
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height * 0.4);

    var firstControlPoint = Offset(size.width / 4, size.height * 0.2);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.4);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.6);
    var secondEndPoint = Offset(size.width, size.height * 0.4);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}