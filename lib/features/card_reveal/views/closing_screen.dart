import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assert_image.dart';

class ClosingScreen extends StatelessWidget {
  const ClosingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
            // Optional: Add a dark overlay for better text readability
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
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'THANK YOU FOR THE GUIDANCE RECEIVED IN THIS SESSION.',
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
                        'I CLOSE THIS READING WITH GRATITUDE, CLARITY, AND PEACE.',
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
                        'MAY THE INSIGHTS OFFERED CONTINUE SUPPORTING MY HIGHEST GOOD.',
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
                        'SO BE IT.',
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
            ),

            // Bottom wave decoration
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomWave(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomWave() {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A2332),
              Color(0xFF0D1520),
            ],
          ),
        ),
      ),
    );
  }
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