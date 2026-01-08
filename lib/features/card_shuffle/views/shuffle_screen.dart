import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soul_gate/core/widgets/buttons/app_button.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';
import '../controller/card_controller.dart';
import 'package:get/get.dart';
import '../../card_reveal/views/reveal_screen.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ==================== CARD CONTROLLER ====================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ==================== CARD CONTROLLER ====================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ==================== CARD CONTROLLER ====================
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ==================== CARD CONTROLLER ====================

class CardController extends GetxController {
  // UI states only
  var isShuffling = false.obs;
  var hasShuffled = false.obs;
  var cardsSpread = false.obs;

  // Selected card index from arc (0-77) - tracks the LAST tapped arc card
  var selectedStackIndex = Rxn<int>();

  // Reading type: always 3 now
  var readingCardCount = 3.obs;

  // Track how many cards user has selected (0, 1, 2, or 3)
  var selectedCardCount = 0.obs;

  // Store the arc card indices for each selection
  var selectedArcIndices = <int>[].obs;

  // Add deck index
  var deckIndex = 0.obs;

  // Method to set deck index
  void setDeckIndex(int index) {
    deckIndex.value = index;
  }

  // Get the appropriate deck image based on deckIndex
  String getDeckImage() {
    switch (deckIndex.value) {
      case 0:
        return AppAssertImage.instance.deck1;
      case 1:
        return AppAssertImage.instance.deck2;
      case 2:
        return AppAssertImage.instance.deck3;
      default:
        return AppAssertImage.instance.deck1;
    }
  }

  // Just animate the shuffle - no actual card data
  Future<void> shuffleAndDivideCards() async {
    isShuffling.value = true;
    cardsSpread.value = false;
    selectedStackIndex.value = null;
    selectedCardCount.value = 0;
    selectedArcIndices.clear();

    // Wait then spread cards visually
    await Future.delayed(const Duration(milliseconds: 500));
    cardsSpread.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));

    isShuffling.value = false;
    hasShuffled.value = true;
  }

  // User taps an arc card to select next card
  void selectNextCard(int arcIndex) {
    if (arcIndex < 0 || arcIndex >= 78) return;

    // If all 3 cards already selected, ignore
    if (selectedCardCount.value >= 3) return;

    // Check if this arc card was already used
    if (selectedArcIndices.contains(arcIndex)) {
      return;
    }

    // Add this arc card to selection
    selectedArcIndices.add(arcIndex);
    selectedStackIndex.value = arcIndex;

    // Increment the count - this lights up the next card
    selectedCardCount.value++;
  }

  // Check if a specific arc card is selected
  bool isArcCardSelected(int index) {
    return selectedArcIndices.contains(index);
  }

  // Check if a specific layout card is lit (0, 1, or 2)
  bool isCardLitUp(int index) {
    return selectedCardCount.value > index;
  }

  // Check if all 3 cards are selected
  bool get allCardsSelected => selectedCardCount.value >= 3;

  // Get instruction text based on current state
  String getInstructionText() {
    switch (selectedCardCount.value) {
      case 0:
        return 'Select your first card from the arc';
      case 1:
        return 'Select your second card';
      case 2:
        return 'Select your third card';
      case 3:
        return 'Your reading is ready';
      default:
        return 'Tap a card from the arc';
    }
  }

  void resetReading() {
    isShuffling.value = false;
    hasShuffled.value = false;
    cardsSpread.value = false;
    selectedStackIndex.value = null;
    selectedCardCount.value = 0;
    selectedArcIndices.clear();
  }
}

// ==================== SHUFFLE SCREEN ====================

class ShuffleScreen extends StatelessWidget {
  final CardController controller = Get.put(CardController());

  final String questionText;
  final int readingTypeIndex;
  final int deckIndex;
  final int? questionId;

  ShuffleScreen({
    super.key,
    required this.questionText,
    required this.readingTypeIndex,
    required this.deckIndex,
    this.questionId,
  });

  AppStrings appStrings = AppStrings.instance;

  @override
  Widget build(BuildContext context) {
    // Set the deck index
    controller.setDeckIndex(deckIndex);

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
        SizedBox(height: context.spacing24),
        AppText(
          data: appStrings.preparingYourReading,
          fontSize: context.responsiveFontSize(24),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        const Spacer(),
        _buildCircularCardSpread(context),
        const Spacer(),
        Obx(() {
          final isShuffling = controller.isShuffling.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.responsiveSize(40)),
            child: ElevatedButton(
              onPressed: isShuffling
                  ? null
                  : () => controller.shuffleAndDivideCards(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A574),
                padding: EdgeInsets.symmetric(vertical: context.responsiveSize(18)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.responsiveSize(30)),
                ),
                elevation: 0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: AppText(
                    data: isShuffling ? appStrings.shufflingBtn : appStrings.shuffleBtn,
                    fontSize: context.responsiveFontSize(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
        SizedBox(height: context.responsiveSize(40)),
      ],
    );
  }

  Widget _buildCircularCardSpread(BuildContext context) {
    final cardCount = 78;
    final radius = context.screenWidth * 0.43;

    final startAngle = math.pi * 1.15;
    final sweepAngle = math.pi * 0.7;

    // Dynamic card dimensions
    final stackedCardWidth = context.screenWidth * 0.267;
    final stackedCardHeight = stackedCardWidth * 1.5;
    final spreadCardWidth = context.screenWidth * 0.144;
    final spreadCardHeight = spreadCardWidth * 1.5;

    final containerHeight = context.screenHeight * 0.35;
    final containerWidth = context.screenWidth * 0.9;

    final stackCenterX = (containerWidth / 2) - (stackedCardWidth / 2);
    final stackCenterY = (containerHeight / 2) - (stackedCardHeight / 2);

    List<int> cardIndices = List.generate(cardCount, (i) => i);

    return SizedBox(
      height: containerHeight,
      width: context.screenWidth,
      child: Center(
        child: SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Obx(() {
            // Only read these values once at the Stack level
            final isSpread = controller.cardsSpread.value;
            final isShuffling = controller.isShuffling.value;
            final hasShuffled = controller.hasShuffled.value;

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Glow effect behind the stack (only when not spread)
                if (!isSpread)
                  Positioned(
                    left: stackCenterX - context.responsiveSize(10),
                    top: stackCenterY + context.responsiveSize(20),
                    child: Container(
                      width: stackedCardWidth + context.responsiveSize(20),
                      height: stackedCardHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.responsiveSize(16)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4A574).withOpacity(0.4),
                            blurRadius: context.responsiveSize(40),
                            spreadRadius: context.responsiveSize(10),
                          ),
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.2),
                            blurRadius: context.responsiveSize(60),
                            spreadRadius: context.responsiveSize(5),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Cards - each card handles its own state via Obx
                ...cardIndices.map((i) {
                  final progress = i / (cardCount - 1);
                  final angle = startAngle + (sweepAngle * progress);

                  final spreadX = radius * math.cos(angle);
                  final spreadY = radius * math.sin(angle);
                  final spreadLeft = (containerWidth / 2) + spreadX - (spreadCardWidth / 2);
                  final spreadTop = (containerHeight / 2) + spreadY - (spreadCardHeight / 2);

                  final stackLeft = stackCenterX + (i * context.responsiveSize(0.8));
                  final stackTop = stackCenterY - (i * context.responsiveSize(0.6));

                  final cardRotation = angle + math.pi / 2;

                  final currentWidth = isSpread ? spreadCardWidth : stackedCardWidth;
                  final currentHeight = isSpread ? spreadCardHeight : stackedCardHeight;

                  return AnimatedPositioned(
                    key: ValueKey('card_$i'),
                    duration: Duration(milliseconds: 600 + (i * 8)),
                    curve: Curves.easeOutCubic,
                    left: isSpread ? spreadLeft : stackLeft,
                    top: isSpread ? spreadTop : stackTop,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0.0,
                        end: isSpread ? cardRotation : 0.0,
                      ),
                      duration: Duration(milliseconds: 600 + (i * 8)),
                      curve: Curves.easeOutCubic,
                      builder: (context, rotationValue, child) {
                        return Transform.rotate(
                          angle: rotationValue,
                          child: child,
                        );
                      },
                      // Each card has its own Obx for selection state
                      child: _ArcCardWrapper(
                        index: i,
                        width: currentWidth,
                        height: currentHeight,
                        isSpread: isSpread,
                        hasShuffled: hasShuffled,
                        isShuffling: isShuffling,
                        controller: controller,
                        onTap: () => _onArcCardSelected(i),
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _onArcCardSelected(int arcIndex) {
    controller.selectNextCard(arcIndex);
  }

  void _navigateToReadings(BuildContext context) {
    if (!controller.allCardsSelected) {
      CustomSnackbar.error(
        context,
        title: 'Select Cards',
        message: 'Please select all 3 cards from the arc',
      );
      return;
    }

    AppNavigation.push(
      Get.context!,
      RevealScreen(
        deckIndex: deckIndex,
        readingTypeIndex: readingTypeIndex,
        questionText: questionText,
        cardCount: 3,
        questionId: questionId,
      ),
    );
  }

  Widget _buildCombinedView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.spacing24),

        // Dynamic instruction text
        Obx(() {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing24),
            child: AppText(
              data: controller.getInstructionText(),
              fontSize: context.responsiveFontSize(18),
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
              textAlign: TextAlign.center,
            ),
          );
        }),

        SizedBox(height: context.spacing16),

        // Card spread
        Transform.translate(
          offset: Offset(0, context.responsiveSize(70)),
          child: _buildCircularCardSpread(context),
        ),

        // 3-card layout
        Expanded(
          child: Transform.translate(
            offset: Offset(0, -context.responsiveSize(40)),
            child: Obx(() {
              if (controller.isShuffling.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFD4A574)),
                        strokeWidth: context.responsiveSize(4),
                      ),
                      SizedBox(height: context.spacing16),
                      AppText(
                        data: 'Shuffling cards...',
                        fontSize: context.responsiveFontSize(16),
                        color: Colors.white70,
                      ),
                    ],
                  ),
                );
              }
              return _build3CardLayout(context);
            }),
          ),
        ),

        // Bottom button - "Shuffle" or "Readings"
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacing24),
          child: Obx(() {
            final isShuffling = controller.isShuffling.value;
            final allSelected = controller.allCardsSelected;

            // Determine button state
            final String buttonText = isShuffling
                ? "Shuffling..."
                : allSelected
                ? "Readings"
                : "Shuffle";

            return AppButton(
              buttonText: buttonText,
              onPressed: isShuffling
                  ? null
                  : allSelected
                  ? () => _navigateToReadings(context)
                  : () => controller.shuffleAndDivideCards(),
              fillColor: allSelected
                  ? const Color(0xFFD4AF37) // Gold for Readings
                  : const Color(0xFFD4A574), // Brown for Shuffle
            );
          }),
        ),
        SizedBox(height: context.responsiveSize(20)),
      ],
    );
  }

  // 3-card layout - cards light up in order: Middle (1st), Right (2nd), Left (3rd)
  Widget _build3CardLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left card - lights up 3rd (when selectedCardCount >= 3)
            _buildLightUpCard(
              context: context,
              selectionOrder: 3, // 3rd to light up
              label: "Past",
            ),
            SizedBox(width: context.responsiveSize(18)),
            // Middle card - lights up 1st (when selectedCardCount >= 1)
            _buildLightUpCard(
              context: context,
              selectionOrder: 1, // 1st to light up
              label: "Present",
            ),
            SizedBox(width: context.responsiveSize(18)),
            // Right card - lights up 2nd (when selectedCardCount >= 2)
            _buildLightUpCard(
              context: context,
              selectionOrder: 2, // 2nd to light up
              label: "Future",
            ),
          ],
        ),
      ],
    );
  }

  // Card with light-up effect
  Widget _buildLightUpCard({
    required BuildContext context,
    required int selectionOrder, // 1 = first to light, 2 = second, 3 = third
    required String label,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (selectionOrder * 150)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.translate(
            offset: Offset(0, context.responsiveSize(30) * (1 - value)),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: Obx(() {
        // Card lights up when selectedCardCount >= selectionOrder
        final isLitUp = controller.selectedCardCount.value >= selectionOrder;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LightUpCard(
              isLitUp: isLitUp,
              context: context,
              index: selectionOrder,
              deckImage: controller.getDeckImage(),
            ),
            SizedBox(height: context.responsiveSize(8)),
            // Label below card

          ],
        );
      }),
    );
  }
}

// ==================== ARC CARD WRAPPER (handles its own state) ====================

class _ArcCardWrapper extends StatelessWidget {
  final int index;
  final double width;
  final double height;
  final bool isSpread;
  final bool hasShuffled;
  final bool isShuffling;
  final CardController controller;
  final VoidCallback onTap;

  const _ArcCardWrapper({
    required this.index,
    required this.width,
    required this.height,
    required this.isSpread,
    required this.hasShuffled,
    required this.isShuffling,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Each card only reacts to its own selection state
      final isSelected = controller.isArcCardSelected(index);
      final allSelected = controller.allCardsSelected;
      final canTap = hasShuffled && !isShuffling && !allSelected && !isSelected;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: canTap ? onTap : null,
        child: _ArcCard(
          index: index,
          width: width,
          height: height,
          isSpread: isSpread,
          isSelected: isSelected,
          context: context,
          deckImage: controller.getDeckImage(),
        ),
      );
    });
  }
}

// ==================== ARC CARD (visual only, no state) ====================

class _ArcCard extends StatelessWidget {
  final int index;
  final double width;
  final double height;
  final bool isSpread;
  final bool isSelected;
  final BuildContext context;
  final String deckImage;

  const _ArcCard({
    required this.index,
    required this.width,
    required this.height,
    required this.isSpread,
    required this.isSelected,
    required this.context,
    required this.deckImage,
  });

  @override
  Widget build(BuildContext buildContext) {
    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              isSpread ? context.responsiveSize(7) : context.responsiveSize(12)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : const Color(0xFFE5D4C1).withOpacity(0.8),
            width: isSelected
                ? context.responsiveSize(2.5)
                : context.responsiveSize(1.5),
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.6),
              blurRadius: context.responsiveSize(15),
              spreadRadius: context.responsiveSize(3),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: context.responsiveSize(7),
              offset: Offset(0, context.responsiveSize(3)),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              isSpread ? context.responsiveSize(5) : context.responsiveSize(10)),
          child: Stack(
            children: [
              // Card back image
              Positioned.fill(
                child: Image.asset(
                  deckImage,
                  fit: BoxFit.cover,
                ),
              ),
              // Selection indicator (checkmark)
              if (isSelected)
                Positioned(
                  top: context.responsiveSize(4),
                  right: context.responsiveSize(4),
                  child: Container(
                    padding: EdgeInsets.all(context.responsiveSize(3)),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: context.responsiveSize(10),
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

// ==================== LIGHT-UP CARD (3-card layout) ====================

class _LightUpCard extends StatelessWidget {
  final bool isLitUp;
  final BuildContext context;
  final int index;
  final String deckImage;

  const _LightUpCard({
    required this.isLitUp,
    required this.context,
    required this.index,
    required this.deckImage,
  });

  @override
  Widget build(BuildContext buildContext) {
    final cardWidth = context.responsiveSize(70);
    final cardHeight = context.responsiveSize(105);

    return AnimatedScale(
      scale: isLitUp ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.responsiveSize(10)),
          border: Border.all(
            color: isLitUp ? const Color(0xFFFFD700) : const Color(0xFFE5D4C1),
            width: isLitUp ? context.responsiveSize(3) : context.responsiveSize(2),
          ),
          boxShadow: isLitUp
              ? [
            // Golden glow when lit
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.6),
              blurRadius: context.responsiveSize(20),
              spreadRadius: context.responsiveSize(4),
            ),
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.4),
              blurRadius: context.responsiveSize(30),
              spreadRadius: context.responsiveSize(2),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: context.responsiveSize(7),
              offset: Offset(0, context.responsiveSize(3)),
            ),
          ],
        ),
        child: Opacity(
          opacity: isLitUp ? 1.0 : 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.responsiveSize(8)),
            child: Stack(
              children: [
                // Card image
                Positioned.fill(
                  child: Image.asset(
                    deckImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isLitUp
                                ? [const Color(0xFFD4AF37), const Color(0xFFB8960B)]
                                : [const Color(0xFFB8956A), const Color(0xFF9B7B5E)],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.auto_awesome,
                            color: const Color(0xFFE5D4C1),
                            size: context.responsiveSize(28),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Golden overlay when lit
                if (isLitUp)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.responsiveSize(8)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFFD700).withOpacity(0.15),
                            Colors.transparent,
                            const Color(0xFFFFD700).withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Sparkle icon when lit
                if (isLitUp)
                  Positioned(
                    top: context.responsiveSize(6),
                    right: context.responsiveSize(6),
                    child: Icon(
                      Icons.auto_awesome,
                      color: const Color(0xFFFFD700),
                      size: context.responsiveSize(16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}