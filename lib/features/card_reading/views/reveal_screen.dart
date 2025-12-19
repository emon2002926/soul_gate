import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import '../../home/data/tarot_card.dart';
import '../controller/reveal_controller.dart';


class RevealScreen extends StatelessWidget {
  const RevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize RevealController
    final controller = Get.put(RevealController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F3EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const AppText(
          data: 'Result',
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined,
                color: Colors.white, size: 24),
            onPressed: () {},
          ),
        ],
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
            final hasSelectedCard = controller.selectedCardIndex.value != null;

            return Stack(
              children: [
                // Card layout
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: hasSelectedCard ? 280 : 20,
                  ),
                  child: controller.is7CardReading
                      ? _Build7CardLayout(controller: controller)
                      : _Build3CardLayout(controller: controller),
                ),

                // Card details panel
                if (hasSelectedCard)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _CardDetailsPanel(
                      card: controller.currentSelectedCard!,
                      controller: controller,
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// 7-Card Celtic Cross Layout Widget
class _Build7CardLayout extends StatelessWidget {
  final RevealController controller;

  const _Build7CardLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - 60) / 4;
        double cardHeight = cardWidth * 1.5;

        return Stack(
          alignment: Alignment.center,
          children: [
            _PositionedCard(
              controller: controller,
              index: 0,
              top: 0,
              left: constraints.maxWidth / 2 - cardWidth / 2,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),
            _PositionedCard(
              controller: controller,
              index: 1,
              top: cardHeight + 20,
              left: 0,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),
            _PositionedCard(
              controller: controller,
              index: 2,
              top: cardHeight + 20,
              left: cardWidth + 20,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),
            _PositionedCard(
              controller: controller,
              index: 3,
              top: cardHeight + 20,
              left: (cardWidth + 20) * 2,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),
            _PositionedCard(
              controller: controller,
              index: 4,
              top: (cardHeight + 20) * 2,
              left: constraints.maxWidth / 2 - cardWidth / 2,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),
            _PositionedCard(
              controller: controller,
              index: 5,
              top: (cardHeight + 20) * 1.7,
              right: 0,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),
            _PositionedCard(
              controller: controller,
              index: 6,
              top: cardHeight - 20,
              right: 0,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),
          ],
        );
      },
    );
  }
}

// 3-Card Layout Widget
class _Build3CardLayout extends StatelessWidget {
  final RevealController controller;

  const _Build3CardLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - 60) / 3.5;
        double cardHeight = cardWidth * 1.5;

        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedCard(
                controller: controller,
                index: 0,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
              const SizedBox(width: 20),
              _AnimatedCard(
                controller: controller,
                index: 1,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
              const SizedBox(width: 20),
              _AnimatedCard(
                controller: controller,
                index: 2,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Positioned Card for 7-card layout
class _PositionedCard extends StatelessWidget {
  final RevealController controller;
  final int index;
  final double? top;
  final double? left;
  final double? right;
  final double cardWidth;
  final double cardHeight;

  const _PositionedCard({
    required this.controller,
    required this.index,
    this.top,
    this.left,
    this.right,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: _FlipCard(
            controller: controller,
            index: index,
          ),
        ),
      ),
    );
  }
}

// Animated Card for 3-card layout
class _AnimatedCard extends StatelessWidget {
  final RevealController controller;
  final int index;
  final double cardWidth;
  final double cardHeight;

  const _AnimatedCard({
    required this.controller,
    required this.index,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
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
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: _FlipCard(
          controller: controller,
          index: index,
        ),
      ),
    );
  }
}

// Flip Card Widget with animation
class _FlipCard extends StatelessWidget {
  final RevealController controller;
  final int index;

  const _FlipCard({
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final card = controller.getCardAt(index);
    if (card == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => controller.flipCard(index),
      child: Obx(() {
        final isFlipped = controller.isCardFlipped(index);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
            return AnimatedBuilder(
              animation: rotate,
              child: child,
              builder: (context, child) {
                final isUnder = (ValueKey(isFlipped) != child!.key);
                var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                tilt *= isUnder ? -1.0 : 1.0;
                final value = isUnder ? animation.value : 1.0 - animation.value;
                return Transform(
                  transform: Matrix4.rotationY(value * 3.14159),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          child: isFlipped
              ? _CardFront(key: const ValueKey(true), card: card)
              : _CardBack(key: const ValueKey(false)),
        );
      }),
    );
  }
}

// Card Back Widget
class _CardBack extends StatelessWidget {
  const _CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5D4C1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          AppAssertImage.instance.deck1,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD4A574), Color(0xFFB8956A)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFE5D4C1),
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Card Front Widget
class _CardFront extends StatelessWidget {
  final TarotCard card;

  const _CardFront({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5D4C1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: card.imagePath.isNotEmpty
            ? Image.network(
          card.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildCardPlaceholder();
          },
        )
            : _buildCardPlaceholder(),
      ),
    );
  }

  Widget _buildCardPlaceholder() {
    return Container(
      color: const Color(0xFFF5F3EE),
      child: const Center(
        child: Icon(
          Icons.auto_awesome,
          color: Color(0xFF8B7BA8),
          size: 40,
        ),
      ),
    );
  }
}

// Card Details Panel Widget
class _CardDetailsPanel extends StatelessWidget {
  final TarotCard card;
  final RevealController controller;

  const _CardDetailsPanel({
    required this.card,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD4C5B9),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card title
                Text(
                  '${card.name} tell us about.....',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C2A21),
                  ),
                ),

                const SizedBox(height: 16),

                // Section title
                const Text(
                  'This card talks about.....',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C2A21),
                  ),
                ),

                const SizedBox(height: 8),

                // Card meaning
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5C4A42),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'The ${card.name} ',
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: '${card.meaning ?? "appears"} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                        text:
                        'during moments when something has reached its absolute limit.\n\n',
                      ),
                      const TextSpan(
                        text:
                        'A cycle is ending — often sharply, suddenly, or with emotional weight.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TTS button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A574),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.white),
                        onPressed: () => controller.speakCardMeaning(card),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Share button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A574),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/share_icon.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.share, color: Colors.white);
                          },
                        ),
                        onPressed: () => controller.navigateToFullReading(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}