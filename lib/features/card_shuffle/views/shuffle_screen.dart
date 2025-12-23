import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soul_gate/core/widgets/buttons/app_button.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../controller/card_controller.dart';
import 'package:get/get.dart';
import '../../card_reveal/views/reveal_screen.dart';

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

    final cardCount = 78;
    final radius = screenWidth * 0.43;

    final startAngle = math.pi * 1.15;
    final sweepAngle = math.pi * 0.7;

    const double stackedCardWidth = 100.0;
    const double stackedCardHeight = 150.0;
    const double spreadCardWidth = 54.0;
    const double spreadCardHeight = 81.0;

    const double containerHeight = 300.0;
    final containerWidth = screenWidth * 0.9;

    final stackCenterX = (containerWidth / 2) - (stackedCardWidth / 2);
    final stackCenterY = (containerHeight / 2) - (stackedCardHeight / 2);

    List<int> cardIndices = List.generate(cardCount, (i) => i);

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
            children: [
              // Glow effect behind the stack (only when not spread)
              if (!isSpread)
                Positioned(
                  left: stackCenterX - 10,
                  top: stackCenterY + 20,
                  child: Container(
                    width: stackedCardWidth + 20,
                    height: stackedCardHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4A574).withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          blurRadius: 60,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              // Cards - ORIGINAL ANIMATION LOGIC PRESERVED
              ...cardIndices.map((i) {
                final progress = i / (cardCount - 1);
                final angle = startAngle + (sweepAngle * progress);

                final spreadX = radius * math.cos(angle);
                final spreadY = radius * math.sin(angle);
                final spreadLeft = (containerWidth / 2) + spreadX - (spreadCardWidth / 2);
                final spreadTop = (containerHeight / 2) + spreadY - (spreadCardHeight / 2);

                // ORIGINAL stack positioning
                final stackLeft = stackCenterX + (i * 0.8);
                final stackTop = stackCenterY - (i * 0.6);

                final cardRotation = angle + math.pi / 2;

                final currentWidth = isSpread ? spreadCardWidth : stackedCardWidth;
                final currentHeight = isSpread ? spreadCardHeight : stackedCardHeight;

                final isSelected = selectedIndex == i;

                // ORIGINAL ANIMATION - UNCHANGED
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
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (hasShuffled && !isShuffling) {
                          _onArcCardSelected(i);
                        }
                      },
                      child: _AnimatedCard(
                        index: i,
                        width: currentWidth,
                        height: currentHeight,
                        isSpread: isSpread,
                        isSelected: isSelected,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
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

class _AnimatedCard extends StatelessWidget {
  final int index;
  final double width;
  final double height;
  final bool isSpread;
  final bool isSelected;
  final bool isStacked;
  final int stackIndex;
  final int totalStackVisible;

  const _AnimatedCard({
    required this.index,
    required this.width,
    required this.height,
    required this.isSpread,
    required this.isSelected,
    this.isStacked = false,
    this.stackIndex = 0,
    this.totalStackVisible = 15,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate opacity for stacked cards (bottom cards slightly darker)
    final stackOpacity = isStacked
        ? 0.85 + (stackIndex / totalStackVisible) * 0.15
        : 1.0;

    // Top card of stack gets special treatment
    final isTopCard = isStacked && stackIndex == totalStackVisible - 1;

    return AnimatedScale(
      scale: isSelected ? 1.15 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isSpread ? 7 : 12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : isTopCard
                ? const Color(0xFFD4A574)
                : const Color(0xFFE5D4C1).withOpacity(0.8),
            width: isSelected ? 2.5 : (isTopCard ? 2.0 : 1.5),
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ]
              : isStacked
              ? [
            // Layered shadow for depth effect
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
            if (isTopCard)
              BoxShadow(
                color: const Color(0xFFD4A574).withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: -2,
              ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSpread ? 5 : 10),
          child: Stack(
            children: [
              // Card back image
              Positioned.fill(
                child: Opacity(
                  opacity: stackOpacity,
                  child: Image.asset(
                    AppAssertImage.instance.deck1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Subtle gradient overlay for top card glow
              if (isTopCard && !isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                          Colors.transparent,
                          const Color(0xFFD4A574).withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              // Selection indicator
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
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







