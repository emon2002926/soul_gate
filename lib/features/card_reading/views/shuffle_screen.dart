import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soul_gate/core/widgets/buttons/app_button.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import '../controller/card_controller.dart';
import 'package:get/get.dart';
import 'reveal_screen.dart';



class ShuffleScreen extends StatelessWidget {
  final CardController controller = Get.put(CardController());

  ShuffleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: AppText(data: "Choose", fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white,),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {
            },
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
          child: Obx(() {
            if (!controller.hasShuffled.value) {
              return _buildShuffleView(context);
            } else {
              return _buildCombinedView(context); // Show both arc + Celtic Cross
            }
          }),
        ),
      ),
    );
  }

  // Initial shuffle view with circular card spread
  Widget _buildShuffleView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),

        // Title
        AppText(
          data: 'Preparing Your Reading',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        Spacer(),

        // Circular card spread
        Obx(() {
          return _buildCircularCardSpread(context);
        }),

        // Spacer(),

        // Draw Cards button
        Obx(() {
          final isShuffling = controller.isShuffling.value;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: isShuffling
                  ? null
                  : () {
                controller.shuffleAndDivideCards();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4A574),
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    isShuffling ? 'Shuffling...' : 'Draw Cards',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCircularCardSpread(BuildContext context) {
    final isShuffling = controller.isShuffling.value;
    final hasShuffled = controller.hasShuffled.value;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardCount = 13;
    final radius = screenWidth * 0.45;

    final startAngle = math.pi * 1.15;
    final sweepAngle = math.pi * 0.7;

    return SizedBox(
      height: 300,
      width: screenWidth,
      child: Center(
        child: SizedBox(
          width: screenWidth * 0.9,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < cardCount; i++)
                Builder(
                  builder: (context) {
                    final progress = i / (cardCount - 1);
                    final angle = startAngle + (sweepAngle * progress);

                    final x = radius * math.cos(angle);
                    final y = radius * math.sin(angle);

                    final cardRotation = angle + math.pi / 2;

                    return AnimatedPositioned(
                      duration: Duration(milliseconds: isShuffling ? 300 : 600),
                      curve: Curves.easeInOut,
                      left: (screenWidth * 0.9) / 2 + x - 30,
                      top: 150 + y - 45,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 800 + (i * 15)),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.3 + (value * 0.7),
                            child: Transform.rotate(
                              angle: cardRotation +
                                  (isShuffling ? math.sin(i.toDouble()) * 0.2 : 0),
                              child: Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: hasShuffled && !isShuffling
                              ? () => _onStackSelected(i)
                              : null,
                          child: buildTarotCard(
                              highlighted: i == 6), // Highlight middle card
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Combined view showing both arc and Celtic Cross
  Widget _buildCombinedView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        // Two reading type buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // 7 card reading selected
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4A574),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '7 card Reading',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // 3 card reading selected
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4A574),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '3 card reading',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),


        // Arc of cards at the top
        Obx(() {
          return Transform.translate(
            offset: Offset(0, 130), // Positive value moves it down, adjust as needed
            child: _buildCircularCardSpread(context),
          );
        }),
// Celtic Cross card layout below
        Expanded(
          child: Transform.translate(
            offset: Offset(0, -10), // Negative Y value moves it up
            child: _buildCelticCrossLayout(context),
          ),
        ),

        // Bottom Continue button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: AppButton(
            buttonText: "Continue to Reading",
            onPressed: () {
              // Navigate to reading screen
              Get.to(() => RevealScreen());
            },
          ),
        ),

        SizedBox(height: 30),
      ],
    );
  }


  // Celtic Cross card layout pattern
  Widget _buildCelticCrossLayout(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Center cross (cards 0-4)
        _buildPositionedCard(0, top: 20, left: null, index: 0), // Top center
        _buildPositionedCard(1, top: 100, left: 40, index: 1), // Left
        _buildPositionedCard(2, top: 100, left: null, index: 2), // Center
        _buildPositionedCard(3, top: 100, right: 40, index: 3), // Right
        _buildPositionedCard(4, top: 180, left: null, index: 4), // Bottom center
      ],
    );
  }

  Widget _buildPositionedCard(
      int stackIndex, {
        double? top,
        double? left,
        double? right,
        required int index,
      }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 600 + (index * 100)),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: () => _onStackSelected(stackIndex),
          child: _buildRevealCard(),
        ),
      ),
    );
  }

  Widget _buildRevealCard() {
    return Container(
      width: 70,
      height: 105,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB8956A), Color(0xFF9B7B5E)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5D4C1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: Color(0xFFE5D4C1),
          size: 32,
        ),
      ),
    );
  }




  Widget buildBottomActions(BuildContext context) {
    return Column(
      children: [
        // Reshuffle button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            onPressed: () {
              controller.resetReading();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD4A574),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shuffle, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Reshuffle Cards',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Handle stack selection
  void _onStackSelected(int stackIndex) {
    controller.selectStack(stackIndex);
    Get.to(() => RevealScreen());
  }

  Widget buildTarotCard({bool highlighted = false}) {
    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: highlighted
              ? [Color(0xFFD4A574), Color(0xFFB8956A)]
              : [Color(0xFFB8956A), Color(0xFF9B7B5E)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted ? Colors.white : Color(0xFFE5D4C1),
          width: highlighted ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: Color(0xFFE5D4C1),
          size: 24,
        ),
      ),
    );
  }

}



