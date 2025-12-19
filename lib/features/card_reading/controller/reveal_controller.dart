import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/data/tarot_card.dart';
import 'card_controller.dart';

class RevealController extends GetxController {
  // Reference to CardController
  late CardController cardController;

  // Flip states for each card
  var isFlipped = <bool>[].obs;

  // Currently selected card index for details panel
  var selectedCardIndex = Rxn<int>();

  // Track if all cards are revealed
  var allCardsRevealed = false.obs;

  // Animation states
  var isAnimating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    // Get the CardController instance
    cardController = Get.find<CardController>();

    // Initialize flip states based on reading card count
    final cardCount = cardController.readingCardCount.value;
    isFlipped.value = List.generate(cardCount, (index) => false);
  }

  // Get the number of cards in current reading
  int get cardCount => cardController.readingCardCount.value;

  // Get selected cards from CardController
  List<TarotCard> get selectedCards => cardController.selectedCards;

  // Check if using 7-card layout
  bool get is7CardReading => cardController.readingCardCount.value == 7;

  // Flip a specific card
  void flipCard(int index) {
    if (index < 0 || index >= isFlipped.length) return;
    if (isAnimating.value) return;

    isAnimating.value = true;

    // Toggle flip state
    isFlipped[index] = !isFlipped[index];

    // Update selected card index if card is now face up
    if (isFlipped[index]) {
      selectedCardIndex.value = index;
    }

    // Check if all cards are revealed
    _checkAllCardsRevealed();

    // Reset animation lock after flip duration
    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimating.value = false;
    });
  }

  // Check if all cards have been flipped
  void _checkAllCardsRevealed() {
    final allRevealed = isFlipped.every((flipped) => flipped == true);

    if (allRevealed && !allCardsRevealed.value) {
      allCardsRevealed.value = true;
      _onAllCardsRevealed();
    }
  }

  // Called when all cards are revealed
  void _onAllCardsRevealed() {
    // Navigate to full reading screen after delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      navigateToFullReading();
    });
  }

  // Navigate to full reading screen
  void navigateToFullReading() {
    // Using Get navigation - replace with your actual FullReadingScreen route
    Get.toNamed('/full-reading');
  }

  // Get card at specific index
  TarotCard? getCardAt(int index) {
    if (index < 0 || index >= selectedCards.length) return null;
    return selectedCards[index];
  }

  // Check if specific card is flipped
  bool isCardFlipped(int index) {
    if (index < 0 || index >= isFlipped.length) return false;
    return isFlipped[index];
  }

  // Get currently selected card for details panel
  TarotCard? get currentSelectedCard {
    final index = selectedCardIndex.value;
    if (index == null || index < 0 || index >= selectedCards.length) {
      return null;
    }
    return selectedCards[index];
  }

  // Close card details panel
  void closeCardDetails() {
    selectedCardIndex.value = null;
  }

  // Reset reveal state (useful for re-reading)
  void resetReveal() {
    final cardCount = cardController.readingCardCount.value;
    isFlipped.value = List.generate(cardCount, (index) => false);
    selectedCardIndex.value = null;
    allCardsRevealed.value = false;
    isAnimating.value = false;
  }

  // Text-to-speech for card meaning (placeholder)
  void speakCardMeaning(TarotCard card) {
    // Implement TTS functionality
    // You can use flutter_tts package here
    debugPrint('Speaking meaning for: ${card.name}');
  }

  // Share card (placeholder)
  void shareCard(TarotCard card) {
    // Implement share functionality
    debugPrint('Sharing card: ${card.name}');
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}