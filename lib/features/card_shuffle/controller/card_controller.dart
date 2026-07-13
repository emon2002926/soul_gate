import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../data/tarot_data.dart';

class CardController extends GetxController {
  // UI states only
  var isShuffling = false.obs;
  var hasShuffled = false.obs;
  var cardsSpread = false.obs;

  var selectedStackIndex = Rxn<int>();

  var readingCardCount = 3.obs;

  var selectedCardCount = 0.obs;

  var selectedArcIndices = <int>[].obs;

  var deckIndex = 0.obs;

  void setDeckIndex(int index) {
    deckIndex.value = index;
  }

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


  final List<int> randomCardIndices = [];



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
    if (allCardsSelected || isArcCardSelected(arcIndex)) return;

    // Pick a random card not already selected
    final available = tarotCards
        .where((c) => !selectedCards.contains(c))
        .toList()
      ..shuffle();

    selectedCards.add(available.first);

    // your existing arc selection tracking stays the same
    selectedArcIndices.add(arcIndex);
    selectedCardCount.value = selectedArcIndices.length;
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
        return AppStrings.instance.selectFirstCard;
      case 1:
        return AppStrings.instance.selectSecondCard;
      case 2:
        return AppStrings.instance.selectThirdCard;
      case 3:
        return AppStrings.instance.yourReadingIsReady;
      default:
        return AppStrings.instance.threeCardReading;
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


  // Add this to your CardController
  final List<TarotCard> selectedCards = []; // stores the 3 randomly picked cards

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
