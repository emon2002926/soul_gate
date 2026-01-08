import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';

class CardController extends GetxController {
  // UI states only
  var isShuffling = false.obs;
  var hasShuffled = false.obs;
  var cardsSpread = false.obs;

  // Selected card index from arc (0-77)
  var selectedStackIndex = Rxn<int>();

  // Reading type: always 3 now
  var readingCardCount = 3.obs;

  // Sequential light-up state for 3 cards (0, 1, 2)
  var currentLitIndex = (-1).obs; // -1 means none lit, 0 = first, 1 = second, 2 = third
  var isLightingUp = false.obs; // Animation in progress

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
    currentLitIndex.value = -1;
    isLightingUp.value = false;

    // Wait then spread cards visually
    await Future.delayed(const Duration(milliseconds: 500));
    cardsSpread.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));

    isShuffling.value = false;
    hasShuffled.value = true;
  }

  // Select a card from the arc - triggers sequential light-up
  void selectStackForHighlight(int index) {
    if (index < 0 || index >= 78) return;
    if (isLightingUp.value) return; // Don't allow during animation

    // If same card tapped, deselect
    if (selectedStackIndex.value == index) {
      selectedStackIndex.value = null;
      currentLitIndex.value = -1;
      return;
    }

    // Select the arc card
    selectedStackIndex.value = index;

    // Start sequential light-up animation
    _startSequentialLightUp();
  }

  // Sequential light-up effect - one card at a time
  Future<void> _startSequentialLightUp() async {
    isLightingUp.value = true;
    currentLitIndex.value = -1;

    // Light up card 0 (first card)
    await Future.delayed(const Duration(milliseconds: 400));
    currentLitIndex.value = 0;

    // Light up card 1 (second card)
    await Future.delayed(const Duration(milliseconds: 500));
    currentLitIndex.value = 1;

    // Light up card 2 (third card)
    await Future.delayed(const Duration(milliseconds: 500));
    currentLitIndex.value = 2;

    isLightingUp.value = false;
  }

  // Check if a specific card is lit
  bool isCardLitUp(int index) {
    return currentLitIndex.value >= index;
  }

  // Check if all 3 cards are lit up
  bool get allCardsLitUp => currentLitIndex.value >= 2;

  void resetReading() {
    isShuffling.value = false;
    hasShuffled.value = false;
    cardsSpread.value = false;
    selectedStackIndex.value = null;
    currentLitIndex.value = -1;
    isLightingUp.value = false;
  }
}
