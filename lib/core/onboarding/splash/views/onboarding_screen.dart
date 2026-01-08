import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_assert_image.dart';
import 'package:get/get.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/buttons/app_button.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PageView Content
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) => controller.currentPage.value = index,
                  itemCount: onboardingPages.length,
                  itemBuilder: (context, index) {
                    final data = onboardingPages[index];

                    // Combined Reading & Deck Selection Page
                    if (data.type == OnboardingPageType.selectionPage) {
                      return _SelectionPage(data: data, controller: controller);
                    }

                    // Standard pages
                    return _OnboardingPage(data: data);
                  },
                ),
              ),

              // Page Indicator
              Obx(() => Padding(
                padding: EdgeInsets.only(bottom: _getResponsiveSize(context, 12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(
                        horizontal: _getResponsiveSize(context, 4),
                      ),
                      width: controller.currentPage.value == index
                          ? _getResponsiveSize(context, 24)
                          : _getResponsiveSize(context, 8),
                      height: _getResponsiveSize(context, 8),
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? const Color(0xFFD4AF37)
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(
                          _getResponsiveSize(context, 4),
                        ),
                      ),
                    ),
                  ),
                ),
              )),

              // Bottom Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _getResponsiveSize(context, 24),
                ),
                child: Obx(() {
                  final isLastPage = controller.currentPage.value == onboardingPages.length - 1;
                  final currentPageData = onboardingPages[controller.currentPage.value];

                  return AppButton(
                    buttonText: currentPageData.buttonText,
                    onPressed: () {
                      if (isLastPage) {
                        controller.completeOnboarding();
                      } else {
                        controller.nextPage();
                      }
                    },
                    fillColor: const Color(0xFFD4AF37).withOpacity(0.85),
                    buttonHeight: 52,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  );
                }),
              ),

              SizedBox(height: _getResponsiveSize(context, 20)),
            ],
          ),
        ),
      ),
    );
  }

  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }
}

// Standard Onboarding Page
class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsiveSize(context, 32),
        ),
        child: Column(
          children: [
            SizedBox(height: _getResponsiveSize(context, 60)),

            Text(
              data.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                fontSize: _getResponsiveFontSize(context, 32),
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.2,
                letterSpacing: 1.5,
              ),
            ),

            // Subtitle (if exists)
            if (data.subtitle != null) ...[
              SizedBox(height: _getResponsiveSize(context, 14)),
              Text(
                data.subtitle!.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 14),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 2.5,
                ),
              ),
            ],

            SizedBox(height: _getResponsiveSize(context, 50)),

            // Center Image (if exists)
            if (data.centerImage != null) ...[
              Image.asset(
                data.centerImage!,
                width: _getResponsiveSize(context, 240),
                height: _getResponsiveSize(context, 240),
                fit: BoxFit.contain,
              ),
              SizedBox(height: _getResponsiveSize(context, 30)),
            ],

            // Features List (if exists)
            if (data.features != null) ...[
              ...data.features!.map((feature) => Padding(
                padding: EdgeInsets.only(
                  bottom: _getResponsiveSize(context, 20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      feature.icon,
                      color: Colors.white.withOpacity(0.9),
                      size: _getResponsiveSize(context, 20),
                    ),
                    SizedBox(width: _getResponsiveSize(context, 14)),
                    Expanded(
                      child: Text(
                        feature.text.toUpperCase(),
                        style: GoogleFonts.cinzel(
                          fontSize: _getResponsiveFontSize(context, 13),
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.95),
                          letterSpacing: 1.3,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],

            // Description (if exists)
            if (data.description != null) ...[
              Text(
                data.description!,
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  fontSize: _getResponsiveFontSize(context, 17),
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.95),
                  height: 1.6,
                  letterSpacing: 0.5,
                ),
              ),
            ],

            SizedBox(height: _getResponsiveSize(context, 100)),
          ],
        ),
      ),
    );
  }

  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }

  double _getResponsiveFontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }
}

// Combined Reading Preference & Deck Selection Page
class _SelectionPage extends StatelessWidget {
  final OnboardingData data;
  final OnboardingController controller;

  const _SelectionPage({
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsiveSize(context, 24),
      ),
      child: Column(
        children: [
          SizedBox(height: _getResponsiveSize(context, 30)),

          // Reading Preference Section
          Text(
            AppStrings.instance.howWouldYouLikeYourReading,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: _getResponsiveFontSize(context, 22),
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.3,
              letterSpacing: 1,
            ),
          ),

          SizedBox(height: _getResponsiveSize(context, 20)),

          // Reading Type Selection Cards
          Obx(() => Row(
            children: [
              // Audio & Text Reading
              Expanded(
                child: _SelectionCard(
                  icon: Icons.graphic_eq_rounded,
                  label: 'Audio & Text Reading',
                  isSelected: controller.selectedReadingType.value == ReadingType.audioAndText,
                  onTap: () => controller.selectReadingType(ReadingType.audioAndText),
                ),
              ),
              SizedBox(width: _getResponsiveSize(context, 12)),

              // Text Reading
              Expanded(
                child: _SelectionCard(
                  icon: Icons.menu_book_rounded,
                  label: 'Text Reading',
                  isSelected: controller.selectedReadingType.value == ReadingType.textOnly,
                  onTap: () => controller.selectReadingType(ReadingType.textOnly),
                ),
              ),
            ],
          )),

          SizedBox(height: _getResponsiveSize(context, 30)),

          // Deck Selection Section
          Text(
            AppStrings.instance.selectDeckOfCards,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: _getResponsiveFontSize(context, 19),
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),

          SizedBox(height: _getResponsiveSize(context, 18)),

          // Deck Cards
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DeckCard(
                deckType: DeckType.classic,
                imagePath: AppAssertImage.instance.deck1,
                isSelected: controller.selectedDeck.value == DeckType.classic,
                onTap: () => controller.selectDeck(DeckType.classic),
              ),
              SizedBox(width: _getResponsiveSize(context, 10)),
              _DeckCard(
                deckType: DeckType.mystical,
                imagePath: AppAssertImage.instance.deck2,
                isSelected: controller.selectedDeck.value == DeckType.mystical,
                onTap: () => controller.selectDeck(DeckType.mystical),
              ),
              SizedBox(width: _getResponsiveSize(context, 10)),
              _DeckCard(
                deckType: DeckType.celestial,
                imagePath: AppAssertImage.instance.deck3,
                isSelected: controller.selectedDeck.value == DeckType.celestial,
                onTap: () => controller.selectDeck(DeckType.celestial),
              ),
            ],
          )),

          SizedBox(height: _getResponsiveSize(context, 100)),
        ],
      ),
    );
  }

  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }

  double _getResponsiveFontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }
}

// Selection Card Widget (for Reading Type)
class _SelectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _getResponsiveSize(context, 100),
        padding: EdgeInsets.all(_getResponsiveSize(context, 10)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(
            _getResponsiveSize(context, 16),
          ),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Checkmark (if selected)
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: _getResponsiveSize(context, 18),
                  height: _getResponsiveSize(context, 18),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: _getResponsiveSize(context, 11),
                  ),
                ),
              ),

            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  icon,
                  size: _getResponsiveSize(context, 28),
                  color: Colors.white,
                ),

                SizedBox(height: _getResponsiveSize(context, 6)),

                // Label
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 10),
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }

  double _getResponsiveFontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }
}

// Deck Card Widget
// Deck Card Widget
class _DeckCard extends StatelessWidget {
  final DeckType deckType;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeckCard({
    required this.deckType,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _getResponsiveSize(context, 95),  // Increased from 80
        height: _getResponsiveSize(context, 135), // Increased from 110
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            _getResponsiveSize(context, 12),
          ),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : Colors.white.withOpacity(0.4),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: Stack(
          children: [
            // Deck Image
            ClipRRect(
              borderRadius: BorderRadius.circular(
                _getResponsiveSize(context, 10),
              ),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Checkmark Overlay (if selected)
            if (isSelected)
              Positioned(
                top: _getResponsiveSize(context, 6),  // Increased from 5
                right: _getResponsiveSize(context, 6), // Increased from 5
                child: Container(
                  width: _getResponsiveSize(context, 22),  // Increased from 18
                  height: _getResponsiveSize(context, 22), // Increased from 18
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: _getResponsiveSize(context, 14), // Increased from 11
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }
}