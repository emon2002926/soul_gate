
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/features/card_shuffle/views/question_screen.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controller/card_controller.dart';

class FullReadingScreen extends StatelessWidget {

  final String finalMessage;
  final CardController controller = Get.find<CardController>();

  FullReadingScreen({super.key, required this.finalMessage});
  AppStrings appStrings = AppStrings.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFF5F3EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: AppText(
          data: appStrings.appProgressMessage,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _buildReadingCard(context),
                  ),
                ),
              ),

              // Bottom wave decoration
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(AppAssertImage.instance.cardBg),
          fit: BoxFit.cover,
          // Optional: Add a dark overlay for better text readability
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: AppText(
              data: appStrings.appProgressTitle,
              textAlign: TextAlign.center,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C2A21),
            ),
          ),

          SizedBox(height: 24),

          // Reading content
          AppText(
            data: finalMessage!,
            textAlign: TextAlign.center,
              fontSize: 15,
              color: Color(0xFF5C4A42),
              height: 1.6,
          ),

          SizedBox(height: 24),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Speaker button
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD4A574),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {
                    // Text to speech functionality
                  },
                ),
              ),
              SizedBox(width: 12),

              // Share button
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD4A574),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Image.asset(
                    AppAssertImage.instance.shareIcon, // Your asset path
                    width: 24,
                    height: 24,
                    color: Colors.white, // This applies color filter to the image
                  ),
                  onPressed: () {
                    // Share functionality
                    AppNavigation.push(context, QuestionScreen());
                  },
                ),
              ),
            ],
          ),
        ],
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