import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/widgets/app_bar/build_app_bar.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import 'dart:math' as math;
import '../../../core/constants/app_strings.dart';
import '../../../core/util/app_navigation.dart';
import '../../profile/views/profile_page.dart';
import '../controllers/reveal_controller.dart';
import '../models/tarot_response.dart';


class RevealScreen extends StatelessWidget {
  final String questionText;
  final int readingTypeIndex;
  final int deckIndex;
  final int? questionId;
  final int cardCount;
  final bool isSceoundTime;

  RevealScreen({
    super.key,
    required this.questionText,
    required this.readingTypeIndex,
    required this.deckIndex,
    this.questionId,
    required this.cardCount,
    required this.isSceoundTime,
  });

  AppStrings appStrings = AppStrings();

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<RevealController>()) {
      final oldController = Get.find<RevealController>();
      oldController.stopSpeaking();
      Get.delete<RevealController>(force: true);
    }

    final controller = Get.put(RevealController());
    controller.delayedFetchInterpretation(questionText, cardCount);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F3EE),
      appBar: BuildAppBar(
        title: appStrings.yourReading,
        showSideButton: true,
        sideButtonIcon: Icons.account_circle_outlined,
        onSideButtonPressed: ()=>AppNavigation.push(Get.context!, ProfilePage()),
        onBackButtonPrassed: (){
          Navigator.pop(context);
        },
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
            final isLoading = controller.isLoadingInterpretation.value;
            final allCardsRevealed = controller.allCardsRevealed.value;

            return Stack(
              children: [
                // Main content - Cards positioned higher when panel is open
                if (isLoading)
                  _buildLoadingView()
                else
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    top: allCardsRevealed ? 40 : 0,
                    left: 0,
                    right: 0,
                    bottom: allCardsRevealed
                        ? MediaQuery.of(context).size.height * 0.65
                        : 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _Build3CardLayout(
                        controller: controller,
                        deckImage: controller.getDeckImage(deckIndex),
                      ),
                    ),
                  ),

                // All cards details panel - shows all interpretations
                if (allCardsRevealed && !isLoading)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _AllCardsDetailsPanel(
                      controller: controller,
                      questionText: questionText,
                      isSecoundTime: isSceoundTime,
                    ),
                  ),

                // Loading overlay
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.01),
                      child: Center(
                        child: _LoadingWidget(),
                      ),
                    ),
                  ),
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
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.2).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF9B7EBD).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF9B7EBD),
                size: 40,
              ),
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
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppText(
            data: appStrings.loadingTimeoutMessage,
            textAlign: TextAlign.center,
            fontSize: 13,
            color: Color(0xFF8B7355),
          ),
        ],
      ),
    );
  }
}

class _Build3CardLayout extends StatelessWidget {
  final RevealController controller;
  final String deckImage;

  const _Build3CardLayout({
    required this.controller,
    required this.deckImage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableHeight = constraints.maxHeight;
        double cardWidth = (constraints.maxWidth - 60) / 3.5;
        double cardHeight = cardWidth * 1.5;

        if (cardHeight > availableHeight * 0.8) {
          cardHeight = availableHeight * 0.8;
          cardWidth = cardHeight / 1.5;
        }

        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AnimatedCard(
                      controller: controller,
                      index: 0,
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                      dekImage: deckImage,
                    ),
                    const SizedBox(width: 20),
                    _AnimatedCard(
                      controller: controller,
                      index: 1,
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                      dekImage: deckImage,
                    ),
                    const SizedBox(width: 20),
                    _AnimatedCard(
                      controller: controller,
                      index: 2,
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                      dekImage: deckImage,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  final RevealController controller;
  final int index;
  final double cardWidth;
  final double cardHeight;
  final String dekImage;

  const _AnimatedCard({
    required this.controller,
    required this.index,
    required this.cardWidth,
    required this.cardHeight,
    required this.dekImage,
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
      child: Obx(() {
        final isFlipped = controller.isCardFlipped(index);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          width: cardWidth,
          height: cardHeight,
          child: _FlipCard(
            controller: controller,
            index: index,
            dekImage: dekImage,
          ),
        );
      }),
    );
  }
}

class _FlipCard extends StatelessWidget {
  final RevealController controller;
  final int index;
  final String dekImage;

  const _FlipCard({
    required this.controller,
    required this.index,
    required this.dekImage,
  });

  @override
  Widget build(BuildContext context) {
    final card = controller.getCardAt(index);
    if (card == null) return const SizedBox.shrink();

    return Obx(() {
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
                transform: Matrix4.rotationY(value * math.pi),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: isFlipped
            ? _CardFront(key: const ValueKey(true), card: card)
            : _CardBack(key: const ValueKey(false), dekImage: dekImage),
      );
    });
  }
}

class _CardBack extends StatelessWidget {
  final String dekImage;
  const _CardBack({super.key, required this.dekImage});

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
          dekImage,
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
    final imageUrl = card.image;

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
          const Icon(
            Icons.auto_awesome,
            color: Color(0xFF8B7BA8),
            size: 40,
          ),
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

// NEW: Panel showing all card interpretations in a scrollable view
class _AllCardsDetailsPanel extends StatelessWidget {
  final RevealController controller;
  final String questionText;
  final bool isSecoundTime;

  const _AllCardsDetailsPanel({
    required this.controller,
    required this.questionText,
    required this.isSecoundTime,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: MediaQuery.of(context).size.height * 0.65,
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
          const SizedBox(height: 16),

          // Header with action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  data: AppStrings.instance.yourReading,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C2A21),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A574),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: IconButton(
                    iconSize: 24,
                    icon: Image.asset(
                      AppAssertImage.instance.shareIcon,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      controller.navigateToFullReading(
                        questionText,
                        isSecoundTime,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Scrollable list of all card interpretations
          Expanded(
            child: Obx(() {
              final interpretations = controller.interpretations;
              final cards = controller.cards;

              if (interpretations.isEmpty || cards.isEmpty) {
                return Center(
                  child: AppText(
                    data: 'No interpretations available',
                    fontSize: 14,
                    color: Color(0xFF8B7355),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: interpretations.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final interpretation = interpretations[index];
                  final card = cards[index];

                  return _CardInterpretationItem(
                    card: card,
                    interpretation: interpretation,
                    controller: controller,
                    index: index,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Individual card interpretation item
class _CardInterpretationItem extends StatelessWidget {
  final TarotCard card;
  final CardInterpretation interpretation;
  final RevealController controller;
  final int index;

  const _CardInterpretationItem({
    required this.card,
    required this.interpretation,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4C5B9),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with symbol and name
          Row(
            children: [
              if (interpretation.symbol.isNotEmpty) ...[
                AppText(
                  data: interpretation.symbol,
                  fontSize: 24,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C2A21),
                    ),
                    if (interpretation.position.isNotEmpty)
                      AppText(
                        data: interpretation.position,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8B7355),
                      ),
                  ],
                ),
              ),
              // Audio button for this card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A574),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() {
                  final isSpeaking = controller.isSpeaking.value &&
                      controller.currentPlayingCardIndex.value == index;
                  return IconButton(
                    iconSize: 22,
                    icon: Icon(
                      isSpeaking ? Icons.stop : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () => controller.speakCardAtIndex(index),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Interpretation text
          AppText(
            data: interpretation.interpretation.isNotEmpty
                ? interpretation.interpretation
                : card.meaning,
            fontSize: 14,
            color: Color(0xFF5C4A42),
            height: 1.5,
          ),
        ],
      ),
    );
  }
}