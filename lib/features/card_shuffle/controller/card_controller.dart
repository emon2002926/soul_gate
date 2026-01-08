import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';

class CardController extends GetxController {
  // UI states only
  var isShuffling = false.obs;
  var hasShuffled = false.obs;
  var cardsSpread = false.obs;

  // Selected card index from arc (0-77)
  var selectedStackIndex = Rxn<int>();

  // Reading type: 7 or 3
  var readingCardCount = 7.obs;

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

  // Set reading type and reshuffle animation
  Future<void> setReadingType(int cardCount) async {
    if (readingCardCount.value != cardCount) {
      readingCardCount.value = cardCount;
      selectedStackIndex.value = null;
      await shuffleAndDivideCards();
    }
  }

  // Just animate the shuffle - no actual card data
  Future<void> shuffleAndDivideCards() async {
    isShuffling.value = true;
    cardsSpread.value = false;
    selectedStackIndex.value = null;

    // Wait then spread cards visually
    await Future.delayed(const Duration(milliseconds: 500));
    cardsSpread.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));

    isShuffling.value = false;
    hasShuffled.value = true;
  }

  // Select a card from the arc
  void selectStackForHighlight(int index) {
    if (index < 0 || index >= 78) return;

    // Toggle selection
    if (selectedStackIndex.value == index) {
      selectedStackIndex.value = null;
    } else {
      selectedStackIndex.value = index;
    }
  }

  void resetReading() {
    isShuffling.value = false;
    hasShuffled.value = false;
    cardsSpread.value = false;
    selectedStackIndex.value = null;
  }
}