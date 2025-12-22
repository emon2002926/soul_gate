import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soul_gate/core/widgets/buttons/app_button.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
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
      appBar: BuildAppBar(
        title: "Choose",
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
          child: Obx(() {
            if (!controller.hasShuffled.value) {
              return _buildShuffleView(context);
            } else {
              return _buildCombinedView(context);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildShuffleView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const AppText(
          data: 'Preparing Your Reading',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        const Spacer(),
        Obx(() => _buildCircularCardSpread(context)),
        const Spacer(),
        Obx(() {
          final isShuffling = controller.isShuffling.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: isShuffling
                  ? null
                  : () => controller.shuffleAndDivideCards(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A574),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: AppText(
                    data: isShuffling ? 'Shuffling...' : 'Shuffle',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCircularCardSpread(BuildContext context) {
    final isShuffling = controller.isShuffling.value;
    final hasShuffled = controller.hasShuffled.value;
    final isSpread = controller.cardsSpread.value;
    final selectedIndex = controller.selectedStackIndex.value;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardCount = 13;
    final radius = screenWidth * 0.43;

    final startAngle = math.pi * 1.15;
    final sweepAngle = math.pi * 0.7;

    const double stackedCardWidth = 90.0;
    const double stackedCardHeight = 135.0;
    const double spreadCardWidth = 54.0;
    const double spreadCardHeight = 81.0;

    const double containerHeight = 280.0;
    final containerWidth = screenWidth * 0.9;

    final stackCenterX = (containerWidth / 2) - (stackedCardWidth / 2);
    final stackCenterY = (containerHeight / 2) - (stackedCardHeight / 2);

    print('=== Card Spread Debug ===');
    print('isSpread: $isSpread');
    print('hasShuffled: $hasShuffled');
    print('isShuffling: $isShuffling');
    print('selectedIndex: $selectedIndex');

    // Create list with reversed order for spread state (middle cards on top)
    List<int> cardIndices = List.generate(cardCount, (i) => i);
    if (isSpread) {
      cardIndices.sort((a, b) {
        int distanceA = (a - 6).abs();
        int distanceB = (b - 6).abs();
        return distanceB.compareTo(distanceA);
      });
      print('Z-order (furthest to closest): $cardIndices');
    }

    return SizedBox(
      height: containerHeight,
      width: screenWidth,
      child: Center(
        child: SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: cardIndices.map((i) {
              final progress = i / (cardCount - 1);
              final angle = startAngle + (sweepAngle * progress);

              final spreadX = radius * math.cos(angle);
              final spreadY = radius * math.sin(angle);
              final spreadLeft = (containerWidth / 2) + spreadX - (spreadCardWidth / 2);
              final spreadTop = (containerHeight / 2) + spreadY - (spreadCardHeight / 2);

              final stackLeft = stackCenterX + (i * 1.1);
              final stackTop = stackCenterY - (i * 0.9);

              final cardRotation = angle + math.pi / 2;

              final currentWidth = isSpread ? spreadCardWidth : stackedCardWidth;
              final currentHeight = isSpread ? spreadCardHeight : stackedCardHeight;

              final isSelected = selectedIndex == i;

              return AnimatedPositioned(
                key: ValueKey('card_$i'), // Add key for debugging
                duration: Duration(milliseconds: 600 + (i * 50)),
                curve: Curves.easeOutBack,
                left: isSpread ? spreadLeft : stackLeft,
                top: isSpread ? spreadTop : stackTop,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0.0,
                    end: isSpread ? cardRotation : 0.0,
                  ),
                  duration: Duration(milliseconds: 600 + (i * 50)),
                  curve: Curves.easeOutBack,
                  builder: (context, rotationValue, child) {
                    return Transform.rotate(
                      angle: rotationValue,
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print('>>> CARD $i TAPPED <<<');
                      print('hasShuffled: $hasShuffled, isShuffling: $isShuffling');

                      if (hasShuffled && !isShuffling) {
                        print('Calling _onArcCardSelected($i)');
                        _onArcCardSelected(i);
                      } else {
                        print('Tap ignored - hasShuffled: $hasShuffled, isShuffling: $isShuffling');
                      }
                    },
                    child: Container(
                      color: Colors.transparent, // Ensure hit test area
                      child: _AnimatedCard(
                        index: i,
                        width: currentWidth,
                        height: currentHeight,
                        isSpread: isSpread,
                        isSelected: isSelected,
                        isHighlighted: isSpread && i == 6,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }



  void _onArcCardSelected(int stackIndex) {
    controller.selectStackForHighlight(stackIndex);
  }

  void _onLayoutCardSelected(int stackIndex) {
    if (controller.selectedStackIndex.value == null) {
      Get.snackbar(
        'Select a Card',
        'Please tap a card from the arc above first',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFD4A574).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    controller.prepareSelectedCards();
    Get.to(() => RevealScreen());
  }

  Widget _buildCombinedView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Reading type buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            final isShuffling = controller.isShuffling.value;
            final selected = controller.readingCardCount.value;

            return Row(
              children: [
                Expanded(
                  child: _buildReadingTypeButton(
                    label: '7 card Reading',
                    isSelected: selected == 7,
                    isDisabled: isShuffling,
                    onPressed: () async {
                      await controller.setReadingType(7);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildReadingTypeButton(
                    label: '3 card Reading',
                    isSelected: selected == 3,
                    isDisabled: isShuffling,
                    onPressed: () async {
                      await controller.setReadingType(3);
                    },
                  ),
                ),
              ],
            );
          }),
        ),

        // Card spread
        Transform.translate(
          offset: const Offset(0, 120),
          child: Obx(() => _buildCircularCardSpread(context)),
        ),

        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -15),
            child: Obx(() {
              if (controller.isShuffling.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFFD4A574)),
                      ),
                      SizedBox(height: 16),
                      AppText(
                        data: 'Shuffling cards...',
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                );
              }
              return controller.readingCardCount.value == 7
                  ? _build7CardLayout(context)
                  : _build3CardLayout(context);
            }),
          ),
        ),

        // Shuffle button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            final isShuffling = controller.isShuffling.value;
            return AppButton(
              buttonText: isShuffling ? "Shuffling..." : "Shuffle",
              onPressed: isShuffling
                  ? null
                  : () => controller.shuffleAndDivideCards(),
            );
          }),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildReadingTypeButton({
    required String label,
    required bool isSelected,
    required bool isDisabled,
    required VoidCallback onPressed,
  }) {
    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFD4A574) : const Color(0xFF8B7355),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? const BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: AppText(
          data: label,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  // 7-card Celtic Cross layout - MEDIUM cards
  Widget _build7CardLayout(BuildContext context) {
    return Obx(() {
      final hasSelected = controller.selectedStackIndex.value != null;

      return Stack(
        alignment: Alignment.center,
        children: [
          _buildPositionedCard(0, top: 0, left: 142, index: 0, enabled: hasSelected),
          _buildPositionedCard(1, top: 110, left: 25, index: 1, enabled: hasSelected),
          _buildPositionedCard(2, top: 110, left: 108, index: 2, enabled: hasSelected),
          _buildPositionedCard(3, top: 110, right: 158, index: 3, enabled: hasSelected),
          _buildPositionedCard(4, top: 220, left: 142, index: 4, enabled: hasSelected),
          _buildPositionedCard(5, top: 182, right: 62, index: 5, enabled: hasSelected),
          _buildPositionedCard(6, top: 75, right: 62, index: 6, enabled: hasSelected),
        ],
      );
    });
  }

  // 3-card layout - MEDIUM cards
  Widget _build3CardLayout(BuildContext context) {
    return Obx(() {
      final hasSelected = controller.selectedStackIndex.value != null;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCardLabel('Past'),
                _buildCardLabel('Present'),
                _buildCardLabel('Future'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedLayoutCard(index: 0, enabled: hasSelected),
              const SizedBox(width: 18),
              _buildAnimatedLayoutCard(index: 1, enabled: hasSelected),
              const SizedBox(width: 18),
              _buildAnimatedLayoutCard(index: 2, enabled: hasSelected),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildCardLabel(String label) {
    return SizedBox(
      width: 75,
      child: AppText(
        data: label,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnimatedLayoutCard({required int index, required bool enabled}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 150)),
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
        onTap: () => _onLayoutCardSelected(index),
        child: _LayoutCard(enabled: enabled),
      ),
    );
  }

  Widget _buildPositionedCard(
      int stackIndex, {
        double? top,
        double? left,
        double? right,
        required int index,
        required bool enabled,
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
          onTap: () => _onLayoutCardSelected(stackIndex),
          child: _LayoutCard(enabled: enabled),
        ),
      ),
    );
  }
}

// ============================================================================
// ANIMATED CARD - Arc cards with selection feedback (MEDIUM)
// ============================================================================

class _AnimatedCard extends StatelessWidget {
  final int index;
  final double width;
  final double height;
  final bool isSpread;
  final bool isSelected;
  final bool isHighlighted;

  const _AnimatedCard({
    required this.index,
    required this.width,
    required this.height,
    required this.isSpread,
    required this.isSelected,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.28 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isSpread ? 7 : 11),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : (isHighlighted ? Colors.white : const Color(0xFFE5D4C1)),
            width: isSelected ? 2.5 : (isHighlighted ? 2.5 : 1.8),
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.6),
              blurRadius: 18,
              spreadRadius: 4,
            ),
            BoxShadow(
              color: const Color(0xFFD4A574).withOpacity(0.8),
              blurRadius: 26,
              spreadRadius: 7,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]
              : isSpread
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 13,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSpread ? 5 : 9),
          child: Stack(
            children: [
              // Card image
              Positioned.fill(
                child: Image.asset(
                  AppAssertImage.instance.deck1,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isSelected
                              ? [const Color(0xFFFFD700), const Color(0xFFD4A574)]
                              : isHighlighted
                              ? [const Color(0xFFD4A574), const Color(0xFFB8956A)]
                              : [const Color(0xFFB8956A), const Color(0xFF9B7B5E)],
                        ),
                        borderRadius: BorderRadius.circular(isSpread ? 5 : 9),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.auto_awesome,
                          color: const Color(0xFFE5D4C1),
                          size: isSpread ? 20 : 36,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Selection overlay with checkmark
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isSpread ? 5 : 9),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFFFD700).withOpacity(0.3),
                          const Color(0xFFD4A574).withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white.withOpacity(0.9),
                        size: isSpread ? 24 : 36,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LAYOUT CARD - Celtic Cross / 3-card layout cards (MEDIUM)
// ============================================================================

class _LayoutCard extends StatelessWidget {
  final bool enabled;

  const _LayoutCard({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 64,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: enabled ? const Color(0xFFD4A574) : const Color(0xFFE5D4C1),
          width: enabled ? 2.2 : 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
          if (enabled)
            BoxShadow(
              color: const Color(0xFFD4A574).withOpacity(0.4),
              blurRadius: 11,
              spreadRadius: 1.5,
            ),
        ],
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: enabled ? 1.0 : 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            AppAssertImage.instance.deck1,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: enabled
                        ? [const Color(0xFFD4A574), const Color(0xFFB8956A)]
                        : [const Color(0xFFB8956A), const Color(0xFF9B7B5E)],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFE5D4C1),
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}









////////////////////////////////////////////////////////////////


// class ShuffleScreen extends StatelessWidget {
//   final CardController controller = Get.put(CardController());
//   ShuffleScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: BuildAppBar(
//         title: "Choos",
//
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssertImage.instance.appBackground),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.3),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: SafeArea(
//           child: Obx(() {
//             if (!controller.hasShuffled.value) {
//               return _buildShuffleView(context);
//             } else {
//               return _buildCombinedView(context);
//             }
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShuffleView(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 20),
//         AppText(
//           data: 'Preparing Your Reading',
//           fontSize: 24,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//         Spacer(),
//         Obx(() => _buildCircularCardSpread(context)),
//         Obx(() {
//           final isShuffling = controller.isShuffling.value;
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40),
//             child: ElevatedButton(
//               onPressed: isShuffling
//                   ? null
//                   : () => controller.shuffleAndDivideCards(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFD4A574),
//                 padding: EdgeInsets.symmetric(vertical: 18),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 0,
//               ),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Center(
//                   child: AppText(
//                     data: isShuffling ? 'Shuffling...' : 'Draw Cards',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//         SizedBox(height: 40),
//       ],
//     );
//   }
//
//   Widget _buildCircularCardSpread(BuildContext context) {
//     final isShuffling = controller.isShuffling.value;
//     final hasShuffled = controller.hasShuffled.value;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final cardCount = 13;
//     final radius = screenWidth * 0.45;
//
//     final startAngle = math.pi * 1.15;
//     final sweepAngle = math.pi * 0.7;
//
//     return SizedBox(
//       height: 300,
//       width: screenWidth,
//       child: Center(
//         child: SizedBox(
//           width: screenWidth * 0.9,
//           height: 300,
//           child: Stack(
//             alignment: Alignment.center,
//             clipBehavior: Clip.none,
//             children: [
//               for (int i = 0; i < cardCount; i++)
//                 Builder(
//                   builder: (context) {
//                     final progress = i / (cardCount - 1);
//                     final angle = startAngle + (sweepAngle * progress);
//                     final x = radius * math.cos(angle);
//                     final y = radius * math.sin(angle);
//                     final cardRotation = angle + math.pi / 2;
//
//                     return AnimatedPositioned(
//                       duration: Duration(milliseconds: isShuffling ? 300 : 600),
//                       curve: Curves.easeInOut,
//                       left: (screenWidth * 0.9) / 2 + x - 30,
//                       top: 150 + y - 45,
//                       child: TweenAnimationBuilder<double>(
//                         tween: Tween(begin: 0.0, end: 1.0),
//                         duration: Duration(milliseconds: 800 + (i * 15)),
//                         curve: Curves.easeOutBack,
//                         builder: (context, value, child) {
//                           return Transform.scale(
//                             scale: 0.3 + (value * 0.7),
//                             child: Transform.rotate(
//                               angle: cardRotation +
//                                   (isShuffling ? math.sin(i.toDouble()) * 0.2 : 0),
//                               child: Opacity(
//                                 opacity: value.clamp(0.0, 1.0),
//                                 child: child,
//                               ),
//                             ),
//                           );
//                         },
//                         child: GestureDetector(
//                           onTap: hasShuffled && !isShuffling
//                               ? () => _onStackSelected(i)
//                               : null,
//                           child: buildTarotCard(highlighted: i == 6),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCombinedView(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 20),
//         // Reading type buttons
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Obx(() {
//             final isShuffling = controller.isShuffling.value;
//             final selected = controller.readingCardCount.value;
//
//             return Row(
//               children: [
//                 Expanded(
//                   child: _buildReadingTypeButton(
//                     label: '7 card Reading',
//                     isSelected: selected == 7,
//                     isDisabled: isShuffling,
//                     onPressed: () async {
//                       await controller.setReadingType(7);
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: _buildReadingTypeButton(
//                     label: '3 card Reading',
//                     isSelected: selected == 3,
//                     isDisabled: isShuffling,
//                     onPressed: () async {
//                       await controller.setReadingType(3);
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//
//         // Rest of the view...
//         Obx(() {
//           return Transform.translate(
//             offset: Offset(0, 130),
//             child: _buildCircularCardSpread(context),
//           );
//         }),
//
//         Expanded(
//           child: Transform.translate(
//             offset: Offset(0, -10),
//             child: Obx(() {
//               if (controller.isShuffling.value) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(Color(0xFFD4A574)),
//                       ),
//                       SizedBox(height: 16),
//                       AppText(
//                         data: 'Shuffling cards...',
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return controller.readingCardCount.value == 7
//                   ? _build7CardLayout(context)
//                   : _build3CardLayout(context);
//             }),
//           ),
//         ),
//
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: AppButton(
//             buttonText: "Continue to Reading",
//             onPressed: () => Get.to(() => RevealScreen()),
//           ),
//         ),
//         SizedBox(height: 30),
//       ],
//     );
//   }
//   Widget _buildReadingTypeButton({
//     required String label,
//     required bool isSelected,
//     required bool isDisabled,
//     required VoidCallback onPressed,
//   }) {
//     return Opacity(
//       opacity: isDisabled ? 0.6 : 1.0,
//       child: ElevatedButton(
//         onPressed: isDisabled ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isSelected ? Color(0xFFD4A574) : Color(0xFF8B7355),
//           padding: EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: isSelected
//                 ? BorderSide(color: Colors.white, width: 2)
//                 : BorderSide.none,
//           ),
//           elevation: 0,
//         ),
//         child: AppText(
//           data: label,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   // 7-card Celtic Cross layout
//   Widget _build7CardLayout(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         _buildPositionedCard(0, top: 0, left: 140, index: 0),
//         _buildPositionedCard(1, top: 120, left: 20, index: 1),
//         _buildPositionedCard(2, top: 120, left: 105, index: 2),
//         _buildPositionedCard(3, top: 120, right: 155, index: 3),
//         _buildPositionedCard(4, top: 240, left: 140, index: 4),
//         _buildPositionedCard(5, top: 200, right: 60, index: 5),
//         _buildPositionedCard(6, top: 80, right: 60, index: 6),
//       ],
//     );
//   }
//
//   // 3-card layout (Past - Present - Future)
//   Widget _build3CardLayout(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Labels
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 30),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildCardLabel(''),
//               _buildCardLabel(''),
//               _buildCardLabel(''),
//             ],
//           ),
//         ),
//         SizedBox(height: 12),
//         // Cards
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildAnimatedCard(index: 0),
//             SizedBox(width: 20),
//             _buildAnimatedCard(index: 1),
//             SizedBox(width: 20),
//             _buildAnimatedCard(index: 2),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCardLabel(String label) {
//     return SizedBox(
//       width: 80,
//       child: AppText(
//         data: label,
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.white70,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard({required int index}) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + (index * 150)),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Transform.translate(
//             offset: Offset(0, 30 * (1 - value)),
//             child: Opacity(
//               opacity: value.clamp(0.0, 1.0),
//               child: child,
//             ),
//           ),
//         );
//       },
//       child: GestureDetector(
//         onTap: () => _onStackSelected(index),
//         child: _buildRevealCard(),
//       ),
//     );
//   }
//
//   Widget _buildPositionedCard(
//       int stackIndex, {
//         double? top,
//         double? left,
//         double? right,
//         required int index,
//       }) {
//     return Positioned(
//       top: top,
//       left: left,
//       right: right,
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0.0, end: 1.0),
//         duration: Duration(milliseconds: 600 + (index * 100)),
//         curve: Curves.easeOutBack,
//         builder: (context, value, child) {
//           return Transform.scale(
//             scale: value,
//             child: Transform.translate(
//               offset: Offset(0, 30 * (1 - value)),
//               child: Opacity(
//                 opacity: value.clamp(0.0, 1.0),
//                 child: child,
//               ),
//             ),
//           );
//         },
//         child: GestureDetector(
//           onTap: () => _onStackSelected(stackIndex),
//           child: _buildRevealCard(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRevealCard() {
//     return Container(
//       width: 70,
//       height: 105,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFE5D4C1), width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Image.asset(
//           AppAssertImage.instance.deck1,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFFB8956A), Color(0xFF9B7B5E)],
//                 ),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.auto_awesome,
//                   color: Color(0xFFE5D4C1),
//                   size: 32,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget buildTarotCard({bool highlighted = false}) {
//     return Container(
//       width: 60,
//       height: 90,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: highlighted ? Colors.white : Color(0xFFE5D4C1),
//           width: highlighted ? 3 : 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Image.asset(
//           AppAssertImage.instance.deck1,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: highlighted
//                       ? [Color(0xFFD4A574), Color(0xFFB8956A)]
//                       : [Color(0xFFB8956A), Color(0xFF9B7B5E)],
//                 ),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.auto_awesome,
//                   color: Color(0xFFE5D4C1),
//                   size: 24,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _onStackSelected(int stackIndex) {
//     controller.selectStack(stackIndex);
//     Get.to(() => RevealScreen());
//   }
// }















// ============================================================================
// CARD SWAP SHUFFLE ANIMATION
// Cards visually swap positions with each other like a real shuffle
// ============================================================================

// class ShuffleScreen extends StatelessWidget {
//   final CardController controller = Get.put(CardController());
//
//   ShuffleScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: BuildAppBar(
//         title: "Choose",
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssertImage.instance.appBackground),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.3),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: SafeArea(
//           child: Obx(() {
//             if (!controller.hasShuffled.value) {
//               return _buildShuffleView(context);
//             } else {
//               return _buildCombinedView(context);
//             }
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShuffleView(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         Obx(() => AppText(
//           data: controller.isShuffling.value
//               ? 'Shuffling Your Deck...'
//               : 'Preparing Your Reading',
//           fontSize: 24,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         )),
//         const Spacer(),
//         Obx(() => _CardSwapShuffleAnimation(
//           isShuffling: controller.isShuffling.value,
//           hasShuffled: controller.hasShuffled.value,
//           onStackSelected: _onStackSelected,
//         )),
//         Obx(() {
//           final isShuffling = controller.isShuffling.value;
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: ElevatedButton(
//               onPressed:
//               isShuffling ? null : () => controller.shuffleAndDivideCards(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFD4A574),
//                 padding: const EdgeInsets.symmetric(vertical: 18),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 0,
//               ),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Center(
//                   child: AppText(
//                     data: isShuffling ? 'Shuffling...' : 'Draw Cards',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//         const SizedBox(height: 40),
//       ],
//     );
//   }
//
//   Widget _buildCombinedView(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         // Reading type buttons
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Obx(() {
//             final isShuffling = controller.isShuffling.value;
//             final selected = controller.readingCardCount.value;
//
//             return Row(
//               children: [
//                 Expanded(
//                   child: _buildReadingTypeButton(
//                     label: '7 card Reading',
//                     isSelected: selected == 7,
//                     isDisabled: isShuffling,
//                     onPressed: () async {
//                       await controller.setReadingType(7);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildReadingTypeButton(
//                     label: '3 card Reading',
//                     isSelected: selected == 3,
//                     isDisabled: isShuffling,
//                     onPressed: () async {
//                       await controller.setReadingType(3);
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//
//         // Card spread with shuffle animation
//         Obx(() => Transform.translate(
//           offset: const Offset(0, 130),
//           child: _CardSwapShuffleAnimation(
//             isShuffling: controller.isShuffling.value,
//             hasShuffled: controller.hasShuffled.value,
//             onStackSelected: _onStackSelected,
//           ),
//         )),
//
//         Expanded(
//           child: Transform.translate(
//             offset: const Offset(0, -10),
//             child: Obx(() {
//               if (controller.isShuffling.value) {
//                 return const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(Color(0xFFD4A574)),
//                       ),
//                       SizedBox(height: 16),
//                       AppText(
//                         data: 'Shuffling cards...',
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return controller.readingCardCount.value == 7
//                   ? _build7CardLayout(context)
//                   : _build3CardLayout(context);
//             }),
//           ),
//         ),
//
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: AppButton(
//             buttonText: "Continue to Reading",
//             onPressed: () => Get.to(() => const RevealScreen()),
//           ),
//         ),
//         const SizedBox(height: 30),
//       ],
//     );
//   }
//
//   Widget _buildReadingTypeButton({
//     required String label,
//     required bool isSelected,
//     required bool isDisabled,
//     required VoidCallback onPressed,
//   }) {
//     return Opacity(
//       opacity: isDisabled ? 0.6 : 1.0,
//       child: ElevatedButton(
//         onPressed: isDisabled ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//           isSelected ? const Color(0xFFD4A574) : const Color(0xFF8B7355),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: isSelected
//                 ? const BorderSide(color: Colors.white, width: 2)
//                 : BorderSide.none,
//           ),
//           elevation: 0,
//         ),
//         child: AppText(
//           data: label,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   // 7-card Celtic Cross layout
//   Widget _build7CardLayout(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         _buildPositionedCard(0, top: 0, left: 140, index: 0),
//         _buildPositionedCard(1, top: 120, left: 20, index: 1),
//         _buildPositionedCard(2, top: 120, left: 105, index: 2),
//         _buildPositionedCard(3, top: 120, right: 155, index: 3),
//         _buildPositionedCard(4, top: 240, left: 140, index: 4),
//         _buildPositionedCard(5, top: 200, right: 60, index: 5),
//         _buildPositionedCard(6, top: 80, right: 60, index: 6),
//       ],
//     );
//   }
//
//   // 3-card layout
//   Widget _build3CardLayout(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildCardLabel(''),
//               _buildCardLabel(''),
//               _buildCardLabel(''),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildAnimatedCard(index: 0),
//             const SizedBox(width: 20),
//             _buildAnimatedCard(index: 1),
//             const SizedBox(width: 20),
//             _buildAnimatedCard(index: 2),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCardLabel(String label) {
//     return SizedBox(
//       width: 80,
//       child: AppText(
//         data: label,
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.white70,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard({required int index}) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + (index * 150)),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Transform.translate(
//             offset: Offset(0, 30 * (1 - value)),
//             child: Opacity(
//               opacity: value.clamp(0.0, 1.0),
//               child: child,
//             ),
//           ),
//         );
//       },
//       child: GestureDetector(
//         onTap: () => _onStackSelected(index),
//         child: _buildRevealCard(),
//       ),
//     );
//   }
//
//   Widget _buildPositionedCard(
//       int stackIndex, {
//         double? top,
//         double? left,
//         double? right,
//         required int index,
//       }) {
//     return Positioned(
//       top: top,
//       left: left,
//       right: right,
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0.0, end: 1.0),
//         duration: Duration(milliseconds: 600 + (index * 100)),
//         curve: Curves.easeOutBack,
//         builder: (context, value, child) {
//           return Transform.scale(
//             scale: value,
//             child: Transform.translate(
//               offset: Offset(0, 30 * (1 - value)),
//               child: Opacity(
//                 opacity: value.clamp(0.0, 1.0),
//                 child: child,
//               ),
//             ),
//           );
//         },
//         child: GestureDetector(
//           onTap: () => _onStackSelected(stackIndex),
//           child: _buildRevealCard(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRevealCard() {
//     return Container(
//       width: 70,
//       height: 105,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFFE5D4C1), width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Image.asset(
//           AppAssertImage.instance.deck1,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFFB8956A), Color(0xFF9B7B5E)],
//                 ),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.auto_awesome,
//                   color: Color(0xFFE5D4C1),
//                   size: 32,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _onStackSelected(int stackIndex) {
//     controller.selectStack(stackIndex);
//     Get.to(() => const RevealScreen());
//   }
// }
//
// class _CardSwapShuffleAnimation extends StatefulWidget {
//   final bool isShuffling;
//   final bool hasShuffled;
//   final Function(int) onStackSelected;
//
//   const _CardSwapShuffleAnimation({
//     required this.isShuffling,
//     required this.hasShuffled,
//     required this.onStackSelected,
//   });
//
//   @override
//   State<_CardSwapShuffleAnimation> createState() =>
//       _CardSwapShuffleAnimationState();
// }
//
// class _CardSwapShuffleAnimationState extends State<_CardSwapShuffleAnimation>
//     with TickerProviderStateMixin {
//   static const int cardCount = 13;
//
//   // Current position indices for each card (which slot each card occupies)
//   List<int> _cardPositions = [];
//
//   // Animation controller for swap animations
//   AnimationController? _swapController;
//
//   // Track which cards are currently swapping
//   int? _swappingCard1;
//   int? _swappingCard2;
//
//   // Animation progress for the current swap
//   double _swapProgress = 0.0;
//
//   // Random for shuffle
//   final _random = math.Random();
//
//   // Flag to track if swaps are running
//   bool _isRunningSwaps = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize cards in their original positions
//     _cardPositions = List.generate(cardCount, (i) => i);
//
//     _swapController = AnimationController(
//       duration: const Duration(milliseconds: 250),
//       vsync: this,
//     );
//
//     _swapController!.addListener(() {
//       setState(() {
//         _swapProgress = _swapController!.value;
//       });
//     });
//
//     _swapController!.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         // Actually swap the positions in the list
//         if (_swappingCard1 != null && _swappingCard2 != null) {
//           final temp = _cardPositions[_swappingCard1!];
//           _cardPositions[_swappingCard1!] = _cardPositions[_swappingCard2!];
//           _cardPositions[_swappingCard2!] = temp;
//         }
//
//         _swappingCard1 = null;
//         _swappingCard2 = null;
//         _swapProgress = 0.0;
//
//         // Continue with next swap if still shuffling
//         if (widget.isShuffling && _isRunningSwaps) {
//           Future.delayed(const Duration(milliseconds: 30), () {
//             if (mounted && widget.isShuffling) {
//               _performRandomSwap();
//             }
//           });
//         }
//       }
//     });
//   }
//
//   @override
//   void didUpdateWidget(_CardSwapShuffleAnimation oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     if (widget.isShuffling && !oldWidget.isShuffling) {
//       // Start shuffling
//       _isRunningSwaps = true;
//       _performRandomSwap();
//     } else if (!widget.isShuffling && oldWidget.isShuffling) {
//       // Stop shuffling
//       _isRunningSwaps = false;
//       _swapController?.stop();
//       _swappingCard1 = null;
//       _swappingCard2 = null;
//       _swapProgress = 0.0;
//     }
//   }
//
//   void _performRandomSwap() {
//     if (!mounted || !widget.isShuffling) return;
//
//     // Pick two random different cards to swap
//     final card1 = _random.nextInt(cardCount);
//     int card2 = _random.nextInt(cardCount);
//     while (card2 == card1) {
//       card2 = _random.nextInt(cardCount);
//     }
//
//     setState(() {
//       _swappingCard1 = card1;
//       _swappingCard2 = card2;
//     });
//
//     _swapController!.forward(from: 0.0);
//   }
//
//   @override
//   void dispose() {
//     _swapController?.dispose();
//     super.dispose();
//   }
//
//   // Calculate position on arc for a given slot index
//   Offset _getPositionForSlot(int slotIndex, double screenWidth, double radius) {
//     final startAngle = math.pi * 1.15;
//     final sweepAngle = math.pi * 0.7;
//
//     final progress = slotIndex / (cardCount - 1);
//     final angle = startAngle + (sweepAngle * progress);
//
//     final x = (screenWidth * 0.9) / 2 + radius * math.cos(angle) - 30;
//     final y = 150 + radius * math.sin(angle) - 45;
//
//     return Offset(x, y);
//   }
//
//   double _getRotationForSlot(int slotIndex) {
//     final startAngle = math.pi * 1.15;
//     final sweepAngle = math.pi * 0.7;
//
//     final progress = slotIndex / (cardCount - 1);
//     final angle = startAngle + (sweepAngle * progress);
//
//     return angle + math.pi / 2;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final radius = screenWidth * 0.45;
//
//     return SizedBox(
//       height: 300,
//       width: screenWidth,
//       child: Center(
//         child: SizedBox(
//           width: screenWidth * 0.9,
//           height: 300,
//           child: Stack(
//             alignment: Alignment.center,
//             clipBehavior: Clip.none,
//             children: [
//               for (int cardIndex = 0; cardIndex < cardCount; cardIndex++)
//                 _buildSwappingCard(cardIndex, screenWidth, radius),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSwappingCard(int cardIndex, double screenWidth, double radius) {
//     // Current slot this card is in
//     final currentSlot = _cardPositions[cardIndex];
//
//     // Get base position for current slot
//     Offset position = _getPositionForSlot(currentSlot, screenWidth, radius);
//     double rotation = _getRotationForSlot(currentSlot);
//
//     // Check if this card is currently being swapped
//     bool isSwapping = false;
//     double elevationBoost = 0;
//
//     if (_swappingCard1 == cardIndex && _swappingCard2 != null) {
//       isSwapping = true;
//       final targetSlot = _cardPositions[_swappingCard2!];
//       final targetPosition =
//       _getPositionForSlot(targetSlot, screenWidth, radius);
//       final targetRotation = _getRotationForSlot(targetSlot);
//
//       // Curved animation progress
//       final curvedProgress = Curves.easeInOutCubic.transform(_swapProgress);
//
//       // Arc movement - card goes UP then DOWN during swap
//       final arcHeight = -60.0 * math.sin(curvedProgress * math.pi);
//
//       position = Offset(
//         position.dx + (targetPosition.dx - position.dx) * curvedProgress,
//         position.dy +
//             (targetPosition.dy - position.dy) * curvedProgress +
//             arcHeight,
//       );
//       rotation = rotation + (targetRotation - rotation) * curvedProgress;
//       elevationBoost = 10 * math.sin(curvedProgress * math.pi);
//     } else if (_swappingCard2 == cardIndex && _swappingCard1 != null) {
//       isSwapping = true;
//       final targetSlot = _cardPositions[_swappingCard1!];
//       final targetPosition =
//       _getPositionForSlot(targetSlot, screenWidth, radius);
//       final targetRotation = _getRotationForSlot(targetSlot);
//
//       final curvedProgress = Curves.easeInOutCubic.transform(_swapProgress);
//
//       // Opposite arc - this card goes DOWN then UP
//       final arcHeight = 40.0 * math.sin(curvedProgress * math.pi);
//
//       position = Offset(
//         position.dx + (targetPosition.dx - position.dx) * curvedProgress,
//         position.dy +
//             (targetPosition.dy - position.dy) * curvedProgress +
//             arcHeight,
//       );
//       rotation = rotation + (targetRotation - rotation) * curvedProgress;
//       elevationBoost = 5 * math.sin(curvedProgress * math.pi);
//     }
//
//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0.0, end: 1.0),
//         duration: Duration(milliseconds: 800 + (cardIndex * 15)),
//         curve: Curves.easeOutBack,
//         builder: (context, value, child) {
//           return Transform.scale(
//             scale: 0.3 + (value * 0.7),
//             child: Transform.rotate(
//               angle: rotation,
//               child: Opacity(
//                 opacity: value.clamp(0.0, 1.0),
//                 child: child,
//               ),
//             ),
//           );
//         },
//         child: GestureDetector(
//           onTap: widget.hasShuffled && !widget.isShuffling
//               ? () => widget.onStackSelected(cardIndex)
//               : null,
//           child: _SwapCard(
//             highlighted: cardIndex == 6,
//             isSwapping: isSwapping,
//             elevationBoost: elevationBoost,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _SwapCard extends StatelessWidget {
//   final bool highlighted;
//   final bool isSwapping;
//   final double elevationBoost;
//
//   const _SwapCard({
//     this.highlighted = false,
//     this.isSwapping = false,
//     this.elevationBoost = 0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 100),
//       width: 60,
//       height: 90,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isSwapping
//               ? const Color(0xFFFFD700) // Gold when swapping
//               : (highlighted ? Colors.white : const Color(0xFFE5D4C1)),
//           width: isSwapping ? 3 : (highlighted ? 3 : 2),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 8 + elevationBoost,
//             offset: Offset(0, 4 + elevationBoost / 2),
//           ),
//           if (isSwapping)
//             BoxShadow(
//               color: const Color(0xFFD4A574).withOpacity(0.6),
//               blurRadius: 20,
//               spreadRadius: 3,
//             ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Image.asset(
//           AppAssertImage.instance.deck1,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: highlighted || isSwapping
//                       ? [const Color(0xFFD4A574), const Color(0xFFB8956A)]
//                       : [const Color(0xFFB8956A), const Color(0xFF9B7B5E)],
//                 ),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.auto_awesome,
//                   color: Color(0xFFE5D4C1),
//                   size: 24,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// ============================================================================
// SWAP CARD - Individual card widget with swap effects
// ============================================================================







//
// // ============================================================================
// // SHUFFLE CARD SPREAD - Expressive Animation Widget
// // ============================================================================
// class ShuffleScreen extends StatelessWidget {
//   final CardController controller = Get.put(CardController());
//
//   ShuffleScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: BuildAppBar(
//         title: "Choose",
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssertImage.instance.appBackground),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.3),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: SafeArea(
//           child: Obx(() {
//             if (!controller.hasShuffled.value) {
//               return _buildShuffleView(context);
//             } else {
//               return _buildCombinedView(context);
//             }
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShuffleView(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         Obx(() => AppText(
//           data: controller.isShuffling.value
//               ? 'Shuffling Your Deck...'
//               : 'Preparing Your Reading',
//           fontSize: 24,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         )),
//         const Spacer(),
//         Obx(() => _ShuffleCardSpread(
//           isShuffling: controller.isShuffling.value,
//           hasShuffled: controller.hasShuffled.value,
//           onStackSelected: _onStackSelected,
//         )),
//         Obx(() {
//           final isShuffling = controller.isShuffling.value;
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: ElevatedButton(
//               onPressed:
//               isShuffling ? null : () => controller.shuffleAndDivideCards(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFD4A574),
//                 padding: const EdgeInsets.symmetric(vertical: 18),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 0,
//               ),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Center(
//                   child: AppText(
//                     data: isShuffling ? 'Shuffling...' : 'Draw Cards',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//         const SizedBox(height: 40),
//       ],
//     );
//   }
//
//   Widget _buildCombinedView(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         // Reading type buttons
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Obx(() {
//             final isShuffling = controller.isShuffling.value;
//             final selected = controller.readingCardCount.value;
//
//             return Row(
//               children: [
//                 Expanded(
//                   child: _buildReadingTypeButton(
//                     label: '7 card Reading',
//                     isSelected: selected == 7,
//                     isDisabled: isShuffling,
//                     onPressed: () async {
//                       await controller.setReadingType(7);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildReadingTypeButton(
//                     label: '3 card Reading',
//                     isSelected: selected == 3,
//                     isDisabled: isShuffling,
//                     onPressed: () async {
//                       await controller.setReadingType(3);
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//
//         // Card spread with shuffle animation
//         Obx(() => Transform.translate(
//           offset: const Offset(0, 130),
//           child: _ShuffleCardSpread(
//             isShuffling: controller.isShuffling.value,
//             hasShuffled: controller.hasShuffled.value,
//             onStackSelected: _onStackSelected,
//           ),
//         )),
//
//         Expanded(
//           child: Transform.translate(
//             offset: const Offset(0, -10),
//             child: Obx(() {
//               if (controller.isShuffling.value) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Animated shuffling indicator
//                       _ShuffleProgressIndicator(),
//                       const SizedBox(height: 16),
//                       const AppText(
//                         data: 'Shuffling cards...',
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return controller.readingCardCount.value == 7
//                   ? _build7CardLayout(context)
//                   : _build3CardLayout(context);
//             }),
//           ),
//         ),
//
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: AppButton(
//             buttonText: "Continue to Reading",
//             onPressed: () => Get.to(() => const RevealScreen()),
//           ),
//         ),
//         const SizedBox(height: 30),
//       ],
//     );
//   }
//
//   Widget _buildReadingTypeButton({
//     required String label,
//     required bool isSelected,
//     required bool isDisabled,
//     required VoidCallback onPressed,
//   }) {
//     return Opacity(
//       opacity: isDisabled ? 0.6 : 1.0,
//       child: ElevatedButton(
//         onPressed: isDisabled ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//           isSelected ? const Color(0xFFD4A574) : const Color(0xFF8B7355),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: isSelected
//                 ? const BorderSide(color: Colors.white, width: 2)
//                 : BorderSide.none,
//           ),
//           elevation: 0,
//         ),
//         child: AppText(
//           data: label,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   // 7-card Celtic Cross layout
//   Widget _build7CardLayout(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         _buildPositionedCard(0, top: 0, left: 140, index: 0),
//         _buildPositionedCard(1, top: 120, left: 20, index: 1),
//         _buildPositionedCard(2, top: 120, left: 105, index: 2),
//         _buildPositionedCard(3, top: 120, right: 155, index: 3),
//         _buildPositionedCard(4, top: 240, left: 140, index: 4),
//         _buildPositionedCard(5, top: 200, right: 60, index: 5),
//         _buildPositionedCard(6, top: 80, right: 60, index: 6),
//       ],
//     );
//   }
//
//   // 3-card layout (Past - Present - Future)
//   Widget _build3CardLayout(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildCardLabel(''),
//               _buildCardLabel(''),
//               _buildCardLabel(''),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildAnimatedCard(index: 0),
//             const SizedBox(width: 20),
//             _buildAnimatedCard(index: 1),
//             const SizedBox(width: 20),
//             _buildAnimatedCard(index: 2),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCardLabel(String label) {
//     return SizedBox(
//       width: 80,
//       child: AppText(
//         data: label,
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.white70,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard({required int index}) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + (index * 150)),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Transform.translate(
//             offset: Offset(0, 30 * (1 - value)),
//             child: Opacity(
//               opacity: value.clamp(0.0, 1.0),
//               child: child,
//             ),
//           ),
//         );
//       },
//       child: GestureDetector(
//         onTap: () => _onStackSelected(index),
//         child: _buildRevealCard(),
//       ),
//     );
//   }
//
//   Widget _buildPositionedCard(
//       int stackIndex, {
//         double? top,
//         double? left,
//         double? right,
//         required int index,
//       }) {
//     return Positioned(
//       top: top,
//       left: left,
//       right: right,
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0.0, end: 1.0),
//         duration: Duration(milliseconds: 600 + (index * 100)),
//         curve: Curves.easeOutBack,
//         builder: (context, value, child) {
//           return Transform.scale(
//             scale: value,
//             child: Transform.translate(
//               offset: Offset(0, 30 * (1 - value)),
//               child: Opacity(
//                 opacity: value.clamp(0.0, 1.0),
//                 child: child,
//               ),
//             ),
//           );
//         },
//         child: GestureDetector(
//           onTap: () => _onStackSelected(stackIndex),
//           child: _buildRevealCard(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRevealCard() {
//     return Container(
//       width: 70,
//       height: 105,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFFE5D4C1), width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Image.asset(
//           AppAssertImage.instance.deck1,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFFB8956A), Color(0xFF9B7B5E)],
//                 ),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.auto_awesome,
//                   color: Color(0xFFE5D4C1),
//                   size: 32,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _onStackSelected(int stackIndex) {
//     controller.selectStack(stackIndex);
//     Get.to(() => const RevealScreen());
//   }
// }
//
// class _ShuffleCardSpread extends StatefulWidget {
//   final bool isShuffling;
//   final bool hasShuffled;
//   final Function(int) onStackSelected;
//
//   const _ShuffleCardSpread({
//     required this.isShuffling,
//     required this.hasShuffled,
//     required this.onStackSelected,
//   });
//
//   @override
//   State<_ShuffleCardSpread> createState() => _ShuffleCardSpreadState();
// }
//
// class _ShuffleCardSpreadState extends State<_ShuffleCardSpread>
//     with TickerProviderStateMixin {
//   late AnimationController _shuffleController;
//   late AnimationController _glowController;
//   late Animation<double> _shuffleAnimation;
//   late Animation<double> _glowAnimation;
//
//   // Animation phases
//   static const int cardCount = 13;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Main shuffle animation controller (2 seconds, loops during shuffle)
//     _shuffleController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _shuffleAnimation = CurvedAnimation(
//       parent: _shuffleController,
//       curve: Curves.easeInOut,
//     );
//
//     // Glow/pulse animation for mystical effect
//     _glowController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//
//     _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
//       CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void didUpdateWidget(_ShuffleCardSpread oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     if (widget.isShuffling && !oldWidget.isShuffling) {
//       // Start shuffling animation
//       _shuffleController.repeat(reverse: true);
//       _glowController.repeat(reverse: true);
//     } else if (!widget.isShuffling && oldWidget.isShuffling) {
//       // Stop shuffling animation
//       _shuffleController.stop();
//       _shuffleController.reset();
//       _glowController.stop();
//       _glowController.reset();
//     }
//   }
//
//   @override
//   void dispose() {
//     _shuffleController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final radius = screenWidth * 0.45;
//     final startAngle = math.pi * 1.15;
//     final sweepAngle = math.pi * 0.7;
//
//     return SizedBox(
//       height: 300,
//       width: screenWidth,
//       child: Center(
//         child: SizedBox(
//           width: screenWidth * 0.9,
//           height: 300,
//           child: AnimatedBuilder(
//             animation: Listenable.merge([_shuffleAnimation, _glowAnimation]),
//             builder: (context, child) {
//               return Stack(
//                 alignment: Alignment.center,
//                 clipBehavior: Clip.none,
//                 children: [
//                   // Mystical glow effect during shuffle
//                   if (widget.isShuffling)
//                     Positioned(
//                       left: (screenWidth * 0.9) / 2 - 80,
//                       top: 150 - 80,
//                       child: Container(
//                         width: 160,
//                         height: 160,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFFD4A574)
//                                   .withOpacity(_glowAnimation.value * 0.4),
//                               blurRadius: 60 + (_glowAnimation.value * 40),
//                               spreadRadius: 20 + (_glowAnimation.value * 20),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                   // Cards
//                   for (int i = 0; i < cardCount; i++)
//                     _buildAnimatedCard(
//                       i,
//                       screenWidth,
//                       radius,
//                       startAngle,
//                       sweepAngle,
//                     ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard(
//       int index,
//       double screenWidth,
//       double radius,
//       double startAngle,
//       double sweepAngle,
//       ) {
//     final progress = index / (cardCount - 1);
//     final baseAngle = startAngle + (sweepAngle * progress);
//
//     // Calculate shuffle animation offsets
//     double shuffleOffsetX = 0;
//     double shuffleOffsetY = 0;
//     double shuffleRotation = 0;
//     double shuffleScale = 1.0;
//
//     if (widget.isShuffling) {
//       final animValue = _shuffleAnimation.value;
//       final cardPhase = (index / cardCount) * 2 * math.pi;
//
//       // Create a swirling/gathering effect
//       // Cards move toward center then back out
//       final gatherFactor = math.sin(animValue * math.pi);
//
//       // Each card has unique movement pattern
//       shuffleOffsetX = math.sin(cardPhase + animValue * math.pi * 4) *
//           30 *
//           (1 - gatherFactor);
//       shuffleOffsetY = math.cos(cardPhase + animValue * math.pi * 4) *
//           30 *
//           (1 - gatherFactor) -
//           (gatherFactor * radius * 0.3);
//
//       // Rotation during shuffle
//       shuffleRotation = math.sin(animValue * math.pi * 2 + cardPhase) * 0.5;
//
//       // Scale pulse
//       shuffleScale = 0.9 + (math.sin(animValue * math.pi * 2 + cardPhase) * 0.15);
//     }
//
//     // Base position on arc
//     final x = radius * math.cos(baseAngle);
//     final y = radius * math.sin(baseAngle);
//     final cardRotation = baseAngle + math.pi / 2;
//
//     return AnimatedPositioned(
//       duration: Duration(milliseconds: widget.isShuffling ? 100 : 600),
//       curve: Curves.easeInOut,
//       left: (screenWidth * 0.9) / 2 + x - 30 + shuffleOffsetX,
//       top: 150 + y - 45 + shuffleOffsetY,
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0.0, end: 1.0),
//         duration: Duration(milliseconds: 800 + (index * 15)),
//         curve: Curves.easeOutBack,
//         builder: (context, value, child) {
//           return Transform.scale(
//             scale: (0.3 + (value * 0.7)) * shuffleScale,
//             child: Transform.rotate(
//               angle: cardRotation + shuffleRotation,
//               child: Opacity(
//                 opacity: value.clamp(0.0, 1.0),
//                 child: child,
//               ),
//             ),
//           );
//         },
//         child: GestureDetector(
//           onTap: widget.hasShuffled && !widget.isShuffling
//               ? () => widget.onStackSelected(index)
//               : null,
//           child: _ShuffleCard(
//             highlighted: index == 6,
//             isShuffling: widget.isShuffling,
//             glowIntensity: widget.isShuffling ? _glowAnimation.value : 0,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ShuffleCard extends StatelessWidget {
//   final bool highlighted;
//   final bool isShuffling;
//   final double glowIntensity;
//
//   const _ShuffleCard({
//     this.highlighted = false,
//     this.isShuffling = false,
//     this.glowIntensity = 0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60,
//       height: 90,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: highlighted
//               ? Colors.white
//               : isShuffling
//               ? Color.lerp(
//             const Color(0xFFE5D4C1),
//             const Color(0xFFD4A574),
//             glowIntensity,
//           )!
//               : const Color(0xFFE5D4C1),
//           width: highlighted ? 3 : 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//           // Glow effect during shuffle
//           if (isShuffling)
//             BoxShadow(
//               color: const Color(0xFFD4A574).withOpacity(glowIntensity * 0.5),
//               blurRadius: 15 + (glowIntensity * 10),
//               spreadRadius: glowIntensity * 3,
//             ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Image.asset(
//           AppAssertImage.instance.deck1,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: highlighted
//                       ? [const Color(0xFFD4A574), const Color(0xFFB8956A)]
//                       : [const Color(0xFFB8956A), const Color(0xFF9B7B5E)],
//                 ),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.auto_awesome,
//                   color: Color(0xFFE5D4C1),
//                   size: 24,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _ShuffleProgressIndicator extends StatefulWidget {
//   @override
//   State<_ShuffleProgressIndicator> createState() =>
//       _ShuffleProgressIndicatorState();
// }
//
// class _ShuffleProgressIndicatorState extends State<_ShuffleProgressIndicator>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 80,
//       height: 60,
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Stack(
//             alignment: Alignment.center,
//             children: List.generate(3, (index) {
//               final delay = index * 0.2;
//               final animValue =
//               ((_controller.value + delay) % 1.0);
//
//               // Card bouncing up and down with rotation
//               final yOffset = math.sin(animValue * math.pi * 2) * 8;
//               final rotation = math.sin(animValue * math.pi * 2 + index) * 0.2;
//               final xOffset = (index - 1) * 20.0;
//
//               return Transform.translate(
//                 offset: Offset(xOffset, yOffset),
//                 child: Transform.rotate(
//                   angle: rotation,
//                   child: Container(
//                     width: 30,
//                     height: 45,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4A574),
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(
//                         color: const Color(0xFFE5D4C1),
//                         width: 1.5,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFFD4A574).withOpacity(0.4),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Center(
//                       child: Icon(
//                         Icons.auto_awesome,
//                         color: Color(0xFFE5D4C1),
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           );
//         },
//       ),
//     );
//   }
// }
// // ============================================================================
// // SHUFFLE CARD SPREAD - Expressive Animation Widget
// // ============================================================================









