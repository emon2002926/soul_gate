import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/constants/app_colors.dart';
import 'package:soul_gate/core/util/screen_size.dart';
import 'package:soul_gate/core/widgets/app_bar/build_app_bar.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import 'dart:math' as math;
import '../../../core/constants/app_strings.dart';
import '../controllers/reveal_controller.dart';
import '../models/tarot_response.dart';

class RevealScreen extends StatelessWidget {
  final String questionText;
  final int readingTypeIndex;
  final int deckIndex;
  final int? questionId;
  final int cardCount;
  RevealScreen({
    super.key,
    required this.questionText,
    required this.readingTypeIndex,
    required this.deckIndex,
    this.questionId,
    required this.cardCount,
  });
  AppStrings appStrings = AppStrings();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RevealController());
    controller.delayedFetchInterpretation(questionText, cardCount);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F3EE),
      appBar: BuildAppBar(showSideButton: false, title: appStrings.yourReading),
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
            final isLoading = controller.isLoadingInterpretation.value;
            final hasSelectedCard = controller.selectedCardIndex.value != null;

            return Stack(
              children: [
                // Main content
                if (isLoading)
                  // _buildLoadingView()
                  Center(child: _LoadingWidget())
                else
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: hasSelectedCard ? 350 : 20,
                    ),
                    child: controller.is7CardReading
                        ? _Build7CardLayout(controller: controller)
                        : _Build3CardLayout(controller: controller),
                  ),

                // Card details panel
                if (hasSelectedCard && !isLoading)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _CardDetailsPanel(
                      card: controller.currentSelectedCard!,
                      interpretation: controller.currentCardInterpretation,
                      controller: controller,
                      questionText: questionText,
                    ),
                  ),

                // Loading overlay with pulsing animation
                // if (isLoading)
                //   Positioned.fill(
                //     child: Container(
                //       color: Colors.transparent,
                //       // color: Colors.black.withOpacity(0.01),
                //       child: Center(child: _LoadingWidget()),
                //     ),
                //   ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFFD4A574)),
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          AppText(
            data: appStrings.consultingTheCards,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatefulWidget {
  @override
  State<_LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<_LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _messageIndex = 0;
  Timer? _timer;

  final List<String> _messages = AppStrings.instance.messages;
  AppStrings appStrings = AppStrings.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Change message every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacing12),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing32,
        vertical: context.responsiveSize(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(context.responsiveSize(12)),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.2).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFFffffff),
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _messages[_messageIndex],
              key: ValueKey<int>(_messageIndex),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFffffff),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppText(
            data: appStrings.loadingTimeoutMessage,
            textAlign: TextAlign.center,
            fontSize: 13,
            color: Color(0xFFffffff),
          ),
        ],
      ),
    );
  }
}

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

class _Build3CardLayout extends StatelessWidget {
  final RevealController controller;

  const _Build3CardLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - 60) / 3.5;
        double cardHeight = cardWidth * 1.5;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Cards
            Row(
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
          ],
        );
      },
    );
  }
}

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
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            ),
          );
        },
        child: Obx(() {
          final isSelected = controller.selectedCardIndex.value == index;
          final isFlipped = controller.isCardFlipped(index);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            width: isSelected && isFlipped ? cardWidth * 1.1 : cardWidth,
            height: isSelected && isFlipped ? cardHeight * 1.1 : cardHeight,
            child: _FlipCard(controller: controller, index: index),
          );
        }),
      ),
    );
  }
}

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
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          ),
        );
      },
      child: Obx(() {
        final isSelected = controller.selectedCardIndex.value == index;
        final isFlipped = controller.isCardFlipped(index);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          width: isSelected && isFlipped ? cardWidth * 1.1 : cardWidth,
          height: isSelected && isFlipped ? cardHeight * 1.1 : cardHeight,
          child: _FlipCard(controller: controller, index: index),
        );
      }),
    );
  }
}

class _FlipCard extends StatelessWidget {
  final RevealController controller;
  final int index;

  const _FlipCard({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final card = controller.getCardAt(index);
    if (card == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => controller.flipCard(index),
      child: Obx(() {
        final isFlipped = controller.isCardFlipped(index);
        final isSelected = controller.selectedCardIndex.value == index;

        return AnimatedScale(
          scale: isSelected && isFlipped ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: AnimatedSwitcher(
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
                  final value = isUnder
                      ? animation.value
                      : 1.0 - animation.value;
                  return Transform(
                    transform: Matrix4.rotationY(value * math.pi),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
              );
            },
            child: isFlipped
                ? _CardFront(key: const ValueKey(true), card: card)
                : _CardBack(key: const ValueKey(false)),
          ),
        );
      }),
    );
  }
}

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
        child: _buildCardImage(),
      ),
    );
  }

  Widget _buildCardImage() {
    // Construct full image URL from card.image path
    final imageUrl = '${card.image}';

    if (card.image.isEmpty) {
      return _buildCardPlaceholder();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildCardPlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF8B7BA8)),
          ),
        );
      },
    );
  }

  Widget _buildCardPlaceholder() {
    return Container(
      color: const Color(0xFFF5F3EE),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF8B7BA8), size: 40),
          const SizedBox(height: 8),
          AppText(
            data: card.name,
            textAlign: TextAlign.center,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5C4A42),
          ),
        ],
      ),
    );
  }
}

class _CardDetailsPanel extends StatelessWidget {
  final TarotCard card;
  final CardInterpretation? interpretation;
  final RevealController controller;
  final String questionText;

  const _CardDetailsPanel({
    required this.card,
    required this.interpretation,
    required this.controller,
    required this.questionText,
  });

  @override
  Widget build(BuildContext context) {
    final position = interpretation?.position ?? '';
    final interpretationText = interpretation?.interpretation ?? '';
    final symbol = interpretation?.symbol ?? '';

    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
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

            Container(
              constraints: const BoxConstraints(maxHeight: 352),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (symbol.isNotEmpty) ...[
                          AppText(
                            data: symbol,
                            fontSize: 26,
                            color: Color(0xFFD4A574),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: card.name,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3C2A21),
                              ),
                              if (position.isNotEmpty)
                                AppText(
                                  data: position,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF8B7355),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    if (interpretationText.isNotEmpty)
                      AppText(
                        data: interpretationText,
                        fontSize: 15,
                        color: Color(0xFF5C4A42),
                        height: 1.6,
                      )
                    else
                      AppText(
                        data: card.meaning,
                        fontSize: 15,
                        color: Color(0xFF5C4A42),
                        height: 1.6,
                      ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Close button
                        TextButton.icon(
                          onPressed: () => controller.closeCardDetails(),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF8B7355),
                            size: 22,
                          ),
                          label: AppText(
                            data: AppStrings.instance.close,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B7355),
                          ),
                        ),

                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4A574),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Obx(() {
                                final isSpeaking = controller.isSpeaking.value;
                                return IconButton(
                                  iconSize: 26,
                                  icon: Icon(
                                    isSpeaking ? Icons.stop : Icons.volume_up,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      controller.speakCardMeaning(card),
                                );
                              }),
                            ),
                            const SizedBox(width: 13),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4A574),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: IconButton(
                                iconSize: 26,
                                icon: Image.asset(
                                  AppAssertImage.instance.shareIcon,
                                  width: 26,
                                  height: 26,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  controller.navigateToFullReading(
                                    questionText,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
