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
                  child: AppText(
                    data:isShuffling ? 'Shuffling...' : 'Draw Cards',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
                  child: AppText(
                    data: '7 card Reading',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
                  child: AppText(
                    data: '3 card reading',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
        // Top card
        _buildPositionedCard(0, top: 0, left: 140, index: 0),

        // Middle row - 3 cards
        _buildPositionedCard(1, top: 120, left: 20, index: 1),  // Left
        _buildPositionedCard(2, top: 120, left: 105, index: 2), // Center
        _buildPositionedCard(3, top: 120, right: 155, index: 3),  // Right
        // Bottom row - 3 cards
        _buildPositionedCard(4, top: 240, left: 140, index: 4),  // Bottom center
        _buildPositionedCard(5, top: 200, right: 60, index: 5),   // Bottom right
        _buildPositionedCard(6, top: 80, right: 60, index: 6),     // Top right
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
         AppAssertImage.instance.deck1, // Your card back image path
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to gradient if image fails to load
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFB8956A), Color(0xFF9B7B5E)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFE5D4C1),
                  size: 32,
                ),
              ),
            );
          },
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
                    AppText(
                      data:'Reshuffle Cards',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          AppAssertImage.instance.deck1, // Your card back image path
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to gradient if image fails to load
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: highlighted
                      ? [Color(0xFFD4A574), Color(0xFFB8956A)]
                      : [Color(0xFFB8956A), Color(0xFF9B7B5E)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFE5D4C1),
                  size: 24,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}



