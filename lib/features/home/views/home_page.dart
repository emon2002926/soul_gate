import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/features/home/views/reveal_screen.dart';
import '../controllers/card_controller.dart';
import 'dart:math' as math;


class ShuffleScreen extends StatelessWidget {
  final CardController controller = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3EE), // Cream background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF8B7355)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (!controller.hasShuffled.value) {
            return _buildShuffleView(context);
          } else {
            return _buildStackSelectionView(context);
          }
        }),
      ),
    );
  }

  // Initial shuffle view
  Widget _buildShuffleView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 20),

                  // Title
                  Text(
                    'Preparing Your Reading',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2A21),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Center card deck with instruction
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Breathe slowly. Allow the cards to align with your intention.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B5B4F),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Card deck visualization with animation
                      _buildCardDeck(context),
                    ],
                  ),

                  Spacer(),

                  // Bottom decoration and button
                  _buildBottomSection(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Card deck display with shuffle animation
  Widget _buildCardDeck(BuildContext context) {
    return Obx(() {
      final isShuffling = controller.isShuffling.value;

      return Container(
        height: 140,
        width: MediaQuery.of(context).size.width * 0.85,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Multiple overlapping cards to show deck
            for (int i = 0; i < 30; i++)
              AnimatedPositioned(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                left: isShuffling
                    ? 20 + (i * 2.0) + (math.Random(i).nextDouble() * 40 - 20)
                    : 20 + (i * 2.0),
                top: isShuffling
                    ? (math.Random(i + 100).nextDouble() * 30 - 15)
                    : 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..rotateZ(isShuffling
                        ? (math.Random(i + 50).nextDouble() * 0.3 - 0.15)
                        : 0),
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color(0xFF8B7BA8), // Purple card color
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD4C5B9), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isShuffling ? 0.2 : 0.1),
                        blurRadius: isShuffling ? 8 : 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.energy_savings_leaf,
                      color: Color(0xFFD4AF37), // Gold accent
                      size: 40,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  // Stack selection view - 13 stacks spread horizontally
  Widget _buildStackSelectionView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 20),

                  // Title
                  Text(
                    'Choose Your Cards',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2A21),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Instruction
                  Text(
                    'Your intuition knows.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B5B4F),
                    ),
                  ),

                  SizedBox(height: 40),

                  // 13 card stacks spread horizontally
                  Container(
                    height: 160,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(13, (index) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 400 + (index * 50)),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) {
                                // Clamp value to ensure it stays within 0.0 to 1.0
                                final clampedValue = value.clamp(0.0, 1.0);
                                return Transform.scale(
                                  scale: clampedValue,
                                  child: Transform.translate(
                                    offset: Offset(0, 50 * (1 - clampedValue)),
                                    child: Opacity(
                                      opacity: clampedValue,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () => _onStackSelected(index),
                                child: _buildCardStack(index),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                  Spacer(),

                  // Bottom decoration
                  _buildBottomSection(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Individual card stack (overlapping 6 cards to show depth)
  Widget _buildCardStack(int index) {
    return Container(
      width: 70,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          // Show 3-4 overlapping cards to create stack effect
          for (int i = 0; i < 4; i++)
            Positioned(
              left: i * 0.5,
              top: i * 0.8,
              child: Container(
                width: 60,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF8B7BA8),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: i == 3 ? Color(0xFFD4C5B9) : Color(0xFFD4C5B9).withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: i == 3
                    ? Center(
                  child: Icon(
                    Icons.energy_savings_leaf,
                    color: Color(0xFFD4AF37),
                    size: 30,
                  ),
                )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  // Bottom section with lotus decoration
  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        // Lotus decoration
        Container(
          height: 80,
          child: Image.asset(
            'assets/lotus_decoration.png',
            fit: BoxFit.contain,
            color: Color(0xFFD4C5B9).withOpacity(0.3),
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.spa,
                size: 60,
                color: Color(0xFFD4C5B9).withOpacity(0.3),
              );
            },
          ),
        ),

        SizedBox(height: 20),

        // Draw Cards button with Obx
        Obx(() {
          final isShuffling = controller.isShuffling.value;
          final hasShuffled = controller.hasShuffled.value;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: isShuffling
                  ? null
                  : () {
                if (!hasShuffled) {
                  controller.shuffleAndDivideCards();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isShuffling
                    ? Color(0xFFD4C5B9)
                    : Color(0xFFC8A882),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isShuffling)
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      Text(
                        isShuffling ? 'Shuffling...' : 'Draw Cards',
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
          );
        }),

        SizedBox(height: 40),
      ],
    );
  }

  // Handle stack selection
  void _onStackSelected(int stackIndex) {
    controller.selectStack(stackIndex);
    Get.to(() => RevealScreen());
  }
}