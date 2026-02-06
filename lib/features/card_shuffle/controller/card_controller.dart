import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';

class CardController extends GetxController {
  // UI states only
  var isShuffling = false.obs;
  var hasShuffled = false.obs;
  var cardsSpread = false.obs;

  // Selected card index from arc (0-77) - tracks the LAST tapped arc card
  var selectedStackIndex = Rxn<int>();

  // Reading type: always 3 now
  var readingCardCount = 3.obs;

  // Track how many cards user has selected (0, 1, 2, or 3)
  var selectedCardCount = 0.obs;

  // Store the arc card indices for each selection
  var selectedArcIndices = <int>[].obs;

  // Add deck index
  var deckIndex = 0.obs;

  // Method to set deck index
  void setDeckIndex(int index) {
    deckIndex.value = index;
  }

  // Get the appropriate deck image based on deckIndex
  String getDeckImage(int deckIndex) {
    switch (deckIndex) {
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
    selectedCardCount.value = 0;
    selectedArcIndices.clear();

    // Wait then spread cards visually
    await Future.delayed(const Duration(milliseconds: 500));
    cardsSpread.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));

    isShuffling.value = false;
    hasShuffled.value = true;
  }

  // User taps an arc card to select next card
  void selectNextCard(int arcIndex) {
    if (arcIndex < 0 || arcIndex >= 78) return;

    // If all 3 cards already selected, ignore
    if (selectedCardCount.value >= 3) return;

    // Check if this arc card was already used
    if (selectedArcIndices.contains(arcIndex)) {
      return;
    }

    // Add this arc card to selection
    selectedArcIndices.add(arcIndex);
    selectedStackIndex.value = arcIndex;

    // Increment the count - this lights up the next card
    selectedCardCount.value++;
  }

  // Check if a specific arc card is selected
  bool isArcCardSelected(int index) {
    return selectedArcIndices.contains(index);
  }

  // Check if a specific layout card is lit (0, 1, or 2)
  bool isCardLitUp(int index) {
    return selectedCardCount.value > index;
  }

  // Check if all 3 cards are selected
  bool get allCardsSelected => selectedCardCount.value >= 3;

  // Get instruction text based on current state
  String getInstructionText() {
    switch (selectedCardCount.value) {
      case 0:
        return 'Select your first card from the arc';
      case 1:
        return 'Select your second card';
      case 2:
        return 'Select your third card';
      case 3:
        return 'Your reading is ready';
      default:
        return 'Tap a card from the arc';
    }
  }

  void resetReading() {
    isShuffling.value = false;
    hasShuffled.value = false;
    cardsSpread.value = false;
    selectedStackIndex.value = null;
    selectedCardCount.value = 0;
    selectedArcIndices.clear();
  }

  @override
  void onInit() {
    super.onInit();
    // Reset everything when controller is initialized
    resetReading();
    print('CardController initialized - all data cleared');
  }

  @override
  void onClose() {
    // Clean up when controller is disposed
    print('CardController disposed - cleaning up data');
    resetReading();
    super.onClose();
  }
}
