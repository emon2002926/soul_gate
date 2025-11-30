import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../core/background/starry_background.dart';
import '../controller/card_controller.dart';
import '../../home/data/tarot_card.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key});

  @override
  _RevealScreenState createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  final CardController controller = Get.find<CardController>();
  List<bool> isFlipped = [];

  @override
  void initState() {
    super.initState();
    // Initialize all cards as face down
    isFlipped = List.generate(7, (index) => false);
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
          onPressed: () {Navigator.pop(context);},
        ),
        title: AppText(
          data: 'Result',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: StarryBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),

              // Grid of 7 cards
              Expanded(
                child: Obx(() {
                  return GridView.builder(
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: controller.selectedCards.length,
                    itemBuilder: (context, index) {
                      return _buildCardWidget(
                        controller.selectedCards[index],
                        index,
                      );
                    },
                  );
                }),
              ),

              // Bottom decoration
              _buildBottomDecoration(),
            ],
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
              final value = isUnder
                  ? animation.value
                  : 1.0 - animation.value;
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
        color: Color(0xFF8B7BA8), // Purple
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD4C5B9), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.energy_savings_leaf,
          color: Color(0xFFD4AF37), // Gold
          size: 50,
        ),
      ),
    );
  }

  // Card front (face up with card info)
  Widget _buildCardFront(TarotCard card, int index) {
    return Container(
      key: ValueKey(true),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD4AF37), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card image placeholder
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Color(0xFFF5F3EE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Color(0xFF8B7BA8),
              size: 30,
            ),
          ),
          SizedBox(height: 8),

          // Card name
          Text(
            card.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3C2A21),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Flip card animation
  void _flipCard(int index) {
    setState(() {
      isFlipped[index] = !isFlipped[index];
    });
  }

  // Bottom decoration
  Widget _buildBottomDecoration() {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Icon(
            Icons.spa,
            size: 50,
            color: Color(0xFFD4C5B9).withOpacity(0.3),
          ),
        ),
        SizedBox(height: 20),

        // View Details button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to card details or interpretation screen
              Get.snackbar(
                'Reading Complete',
                'Card interpretations coming soon!',
                backgroundColor: Color(0xFFC8A882),
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFC8A882),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: AppText(
                  data: 'View Full Reading',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}