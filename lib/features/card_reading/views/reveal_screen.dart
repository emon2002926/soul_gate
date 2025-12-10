import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/constants/app_assert_image.dart';
import '../controller/card_controller.dart';
import '../../home/data/tarot_card.dart';
import 'full_reading_screen.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key});

  @override
  _RevealScreenState createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  final CardController controller = Get.find<CardController>();
  List<bool> isFlipped = [];
  int? selectedCardIndex;

  @override
  void initState() {
    super.initState();
    // Initialize all cards as face down
    isFlipped = List.generate(7, (index) => false);
  }

  // Check if all cards are revealed
  void _checkAllCardsRevealed() {
    bool allRevealed = isFlipped.every((flipped) => flipped == true);

    if (allRevealed) {
      // Wait a moment before navigating
      Future.delayed(Duration(milliseconds: 2000), () {
        // Navigate to next page
        AppNavigation.push(context, FullReadingScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFF5F3EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: AppText(
          data: 'Result',
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined, color: Colors.white, size: 24),
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
          child: Stack(
            children: [
              // Celtic Cross card layout
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: selectedCardIndex != null ? 280 : 20,
                ),
                child: _buildCelticCrossLayout(context),
              ),

              // Bottom dialog for card details
              if (selectedCardIndex != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildCardDetailsDialog(
                    controller.selectedCards[selectedCardIndex!],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Celtic Cross layout with positioned cards
  Widget _buildCelticCrossLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card dimensions based on available space
        double cardWidth = (constraints.maxWidth - 60) / 4;
        double cardHeight = cardWidth * 1.5;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Top card (index 0)
            _buildPositionedCard(0,
              top: 0,
              left: constraints.maxWidth / 2 - cardWidth / 2,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),

            // Middle row - 3 cards
            _buildPositionedCard(1,
              top: cardHeight + 20,
              left: 0,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ), // Left
            _buildPositionedCard(2,
              top: cardHeight + 20,
              left: cardWidth + 20,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ), // Center
            _buildPositionedCard(3,
              top: cardHeight + 20,
              left: (cardWidth + 20) * 2,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ), // Right

            // Bottom center card (index 4)
            _buildPositionedCard(4,
              top: (cardHeight + 20) * 2,
              left: constraints.maxWidth / 2 - cardWidth / 2,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ),

            // Right column - 2 cards
            _buildPositionedCard(5,
              top: (cardHeight + 20) * 1.7,
              right: 0,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ), // Bottom right
            _buildPositionedCard(6,
              top: cardHeight + -20,
              right: 0,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
            ), // Top right
          ],
        );
      },
    );
  }

  Widget _buildPositionedCard(
      int index, {
        double? top,
        double? left,
        double? right,
        required double cardWidth,
        required double cardHeight,
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
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: _buildCardWidget(
            controller.selectedCards[index],
            index,
          ),
        ),
      ),
    );
  }

  // Individual card widget with flip animation
  Widget _buildCardWidget(TarotCard card, int index) {
    return GestureDetector(
      onTap: () => _flipCard(index),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(isFlipped[index]) != child!.key);
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
        child: isFlipped[index]
            ? _buildCardFront(card, index)
            : _buildCardBack(index),
      ),
    );
  }

  // Card back (face down)
  Widget _buildCardBack(int index) {
    return Container(
      key: ValueKey(false),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          AppAssertImage.instance.deck1,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD4A574), Color(0xFFB8956A)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
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

  // Card front (face up with card image)
  Widget _buildCardFront(TarotCard card, int index) {
    return Container(
      key: ValueKey(true),
      decoration: BoxDecoration(
        color: Color(0xFFE5D4C1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD4AF37), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
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
      color: Color(0xFFF5F3EE),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: Color(0xFF8B7BA8),
          size: 40,
        ),
      ),
    );
  }

  // Flip card animation
  void _flipCard(int index) {
    setState(() {
      isFlipped[index] = !isFlipped[index];
      if (isFlipped[index]) {
        selectedCardIndex = index;
      }
    });

    // Check if all cards are now revealed
    _checkAllCardsRevealed();
  }

  // Bottom card details dialog
  Widget _buildCardDetailsDialog(TarotCard card) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Color(0xFFF5EFE7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFD4C5B9),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 20),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card title
                Text(
                  '${card.name} tell us about.....',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C2A21),
                  ),
                ),

                SizedBox(height: 16),

                // Card description title
                Text(
                  'This cards talk about.....',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C2A21),
                  ),
                ),

                SizedBox(height: 8),

                // Card meaning/description
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5C4A42),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'The ${card.name} ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: '${card.meaning ?? "appears"} ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text:
                        'during moments when something has reached its absolute limit.\n\n',
                      ),
                      TextSpan(
                        text:
                        'A cycle is ending — often sharply, suddenly, or with emotional weight.',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Speaker button
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD4A574),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.volume_up, color: Colors.white),
                        onPressed: () {
                          // Text to speech functionality
                        },
                      ),
                    ),
                    SizedBox(width: 12),

                    // Share button
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD4A574),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/share_icon.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Share functionality
                          AppNavigation.push(context, FullReadingScreen());
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
