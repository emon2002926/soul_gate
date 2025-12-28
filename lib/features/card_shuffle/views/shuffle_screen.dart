import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soul_gate/core/widgets/buttons/app_button.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../controller/card_controller.dart';
import 'package:get/get.dart';
import '../../card_reveal/views/reveal_screen.dart';

class ShuffleScreen extends StatelessWidget {
  final CardController controller = Get.put(CardController());

  final String questionText;
  final int readingTypeIndex;
  final int deckIndex;
  final int? questionId;
  ShuffleScreen({super.key, required this.questionText, required this.readingTypeIndex, required this.deckIndex, this.questionId});
  AppStrings appStrings = AppStrings.instance;


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
        SizedBox(height: context.spacing24),
        AppText(
          data: appStrings.preparingYourReading,
          fontSize: context.responsiveFontSize(24),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        const Spacer(),
        Obx(() => _buildCircularCardSpread(context)),
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
    final isShuffling = controller.isShuffling.value;
    final hasShuffled = controller.hasShuffled.value;
    final isSpread = controller.cardsSpread.value;
    final selectedIndex = controller.selectedStackIndex.value;

    final cardCount = 78;
    final radius = context.screenWidth * 0.43;

    final startAngle = math.pi * 1.15;
    final sweepAngle = math.pi * 0.7;

    // Dynamic card dimensions
    final stackedCardWidth = context.screenWidth * 0.267; // ~100px on 375px screen
    final stackedCardHeight = stackedCardWidth * 1.5; // Maintain aspect ratio
    final spreadCardWidth = context.screenWidth * 0.144; // ~54px on 375px screen
    final spreadCardHeight = spreadCardWidth * 1.5; // Maintain aspect ratio

    final containerHeight = context.screenHeight * 0.35; // ~300px responsive
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
          child: Stack(
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
              // Cards - ORIGINAL ANIMATION LOGIC PRESERVED
              ...cardIndices.map((i) {
                final progress = i / (cardCount - 1);
                final angle = startAngle + (sweepAngle * progress);

                final spreadX = radius * math.cos(angle);
                final spreadY = radius * math.sin(angle);
                final spreadLeft = (containerWidth / 2) + spreadX - (spreadCardWidth / 2);
                final spreadTop = (containerHeight / 2) + spreadY - (spreadCardHeight / 2);

                // ORIGINAL stack positioning
                final stackLeft = stackCenterX + (i * context.responsiveSize(0.8));
                final stackTop = stackCenterY - (i * context.responsiveSize(0.6));

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
                        context: context,
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

  void _onLayoutCardSelected(int stackIndex,BuildContext context) {
    if (controller.selectedStackIndex.value == null) {
      Get.snackbar(
        'Select a Card',
        'Please tap a card from the arc above first',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFD4A574).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.all(context.responsiveSize(16)),
        borderRadius: context.responsiveSize(12),
      );
      return;
    }

    AppNavigation.push(
      Get.context!,
      RevealScreen(
        deckIndex: deckIndex,
        readingTypeIndex: readingTypeIndex,
        questionText: questionText,
        cardCount: controller.readingCardCount.value,
        questionId: questionId,
      ),
    );
  }

  Widget _buildCombinedView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.spacing24),
        // Reading type buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacing24),
          child: Obx(() {
            final isShuffling = controller.isShuffling.value;
            final selected = controller.readingCardCount.value;

            return Row(
              children: [
                Expanded(
                  child: _buildReadingTypeButton(
                    context: context,
                    label: appStrings.sevenCardReading,
                    isSelected: selected == 7,
                    isDisabled: isShuffling,
                    onPressed: () async {
                      await controller.setReadingType(7);
                    },
                  ),
                ),
                SizedBox(width: context.spacing12),
                Expanded(
                  child: _buildReadingTypeButton(
                    context: context,
                    label: appStrings.threeCardReading,
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
          offset: Offset(0, context.responsiveSize(90)),
          child: Obx(() => _buildCircularCardSpread(context)),
        ),
        //Todo Space bwteen Arc and Fan layout
        Expanded(
          child: Transform.translate(
            offset: Offset(0, -context.responsiveSize(60)),
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
              return controller.readingCardCount.value == 7
                  ? _build7CardLayout(context)
                  : _build3CardLayout(context);
            }),
          ),
        ),

        // Shuffle button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacing24),
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
        SizedBox(height: context.responsiveSize(30)),
      ],
    );
  }

  Widget _buildReadingTypeButton({
    required BuildContext context,
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
          padding: EdgeInsets.symmetric(vertical: context.responsiveSize(12)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.responsiveSize(12)),
            side: isSelected
                ? BorderSide(color: Colors.white, width: context.responsiveSize(2))
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: AppText(
          data: label,
          fontSize: context.responsiveFontSize(16),
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

      return SizedBox(
        height: context.heightPercentage(100), // ← ADD THIS - gives more vertical space
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildPositionedCard(context, 0, top: context.responsiveSize(0), left: context.responsiveSize(130), index: 0, enabled: hasSelected),
            _buildPositionedCard(context, 1, top: context.responsiveSize(100), left: context.responsiveSize(45), index: 1, enabled: hasSelected),
            _buildPositionedCard(context, 2, top: context.responsiveSize(100), left: context.responsiveSize(130), index: 2, enabled: hasSelected),
            _buildPositionedCard(context, 3, top: context.responsiveSize(100), right: context.responsiveSize(118), index: 3, enabled: hasSelected),
            _buildPositionedCard(context, 4, top: context.responsiveSize(200), left: context.responsiveSize(130), index: 4, enabled: hasSelected),
            _buildPositionedCard(context, 5, top: context.responsiveSize(142), right: context.responsiveSize(42), index: 5, enabled: hasSelected),
            _buildPositionedCard(context, 6, top: context.responsiveSize(45), right: context.responsiveSize(42), index: 6, enabled: hasSelected),
          ],
        ),
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
            padding: EdgeInsets.symmetric(horizontal: context.responsiveSize(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
          ),
          SizedBox(height: context.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedLayoutCard(context: context, index: 0, enabled: hasSelected),
              SizedBox(width: context.responsiveSize(18)),
              _buildAnimatedLayoutCard(context: context, index: 1, enabled: hasSelected),
              SizedBox(width: context.responsiveSize(18)),
              _buildAnimatedLayoutCard(context: context, index: 2, enabled: hasSelected),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildAnimatedLayoutCard({required BuildContext context, required int index, required bool enabled}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 150)),
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
      child: GestureDetector(
        onTap: () => _onLayoutCardSelected(index,context),
        child: _LayoutCard(enabled: enabled, context: context),
      ),
    );
  }

  Widget _buildPositionedCard(
      BuildContext context,
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
              offset: Offset(0, context.responsiveSize(30) * (1 - value)),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: () => _onLayoutCardSelected(stackIndex,context),
          child: _LayoutCard(enabled: enabled, context: context),
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
  final BuildContext context;

  const _AnimatedCard({
    required this.index,
    required this.width,
    required this.height,
    required this.isSpread,
    required this.isSelected,
    required this.context,
    this.isStacked = false,
    this.stackIndex = 0,
    this.totalStackVisible = 15,
  });

  @override
  Widget build(BuildContext buildContext) {
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
          borderRadius: BorderRadius.circular(isSpread ? context.responsiveSize(7) : context.responsiveSize(12)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : isTopCard
                ? const Color(0xFFD4A574)
                : const Color(0xFFE5D4C1).withOpacity(0.8),
            width: isSelected ? context.responsiveSize(2.5) : (isTopCard ? context.responsiveSize(2.0) : context.responsiveSize(1.5)),
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.5),
              blurRadius: context.responsiveSize(12),
              spreadRadius: context.responsiveSize(2),
            ),
          ]
              : isStacked
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: context.responsiveSize(8),
              offset: Offset(context.responsiveSize(2), context.responsiveSize(4)),
            ),
            if (isTopCard)
              BoxShadow(
                color: const Color(0xFFD4A574).withOpacity(0.3),
                blurRadius: context.responsiveSize(15),
                spreadRadius: -context.responsiveSize(2),
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
          borderRadius: BorderRadius.circular(isSpread ? context.responsiveSize(5) : context.responsiveSize(10)),
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
                      borderRadius: BorderRadius.circular(context.responsiveSize(10)),
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
                  top: context.responsiveSize(4),
                  right: context.responsiveSize(4),
                  child: Container(
                    padding: EdgeInsets.all(context.responsiveSize(2)),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: context.responsiveSize(12),
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
  final BuildContext context;

  const _LayoutCard({required this.enabled, required this.context});

  @override
  Widget build(BuildContext buildContext) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: context.responsiveSize(48),
      height: context.responsiveSize(76),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.responsiveSize(7)),
        border: Border.all(
          color: enabled ? const Color(0xFFD4A574) : const Color(0xFFE5D4C1),
          width: enabled ? context.responsiveSize(2.2) : context.responsiveSize(1.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: context.responsiveSize(7),
            offset: Offset(0, context.responsiveSize(3)),
          ),
          if (enabled)
            BoxShadow(
              color: const Color(0xFFD4A574).withOpacity(0.4),
              blurRadius: context.responsiveSize(11),
              spreadRadius: context.responsiveSize(1.5),
            ),
        ],
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: enabled ? 1.0 : 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.responsiveSize(5)),
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
                  borderRadius: BorderRadius.circular(context.responsiveSize(5)),
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
      ),
    );
  }
}







