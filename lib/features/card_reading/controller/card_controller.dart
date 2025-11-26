import 'package:get/get.dart';
import '../../home/data/cards_data.dart';
import '../../home/data/tarot_card.dart';

class CardController extends GetxController {
  // All 78 cards
  List<TarotCard> allCards = [];

  // 13 stacks of 6 cards each
  var cardStacks = <List<TarotCard>>[].obs;

  // Final selected cards (6 from chosen + 1 extra)
  var selectedCards = <TarotCard>[].obs;

  // UI states
  var isShuffling = false.obs;
  var hasShuffled = false.obs;

  @override
  void onInit() {
    super.onInit();
    allCards = CardsData.getAllCards(); // Load 78 cards
  }

  // Shuffle deck + divide into 13 stacks of 6
  void shuffleAndDivideCards() {
    isShuffling.value = true;

    // Copy and shuffle
    List<TarotCard> shuffled = List.from(allCards);
    shuffled.shuffle();

    // Clear old stacks
    cardStacks.clear();

    // Divide into 13 stacks × 6 cards
    for (int i = 0; i < 13; i++) {
      int start = i * 6;
      int end = start + 6;
      List<TarotCard> stack = shuffled.sublist(start, end);
      cardStacks.add(stack);
    }

    // Stop shuffle after animation delay
    Future.delayed(Duration(seconds: 2), () {
      isShuffling.value = false;
      hasShuffled.value = true;
    });
  }

  // User selects a stack → choose 6 + 1 from others
  void selectStack(int stackIndex) {
    if (stackIndex < 0 || stackIndex >= cardStacks.length) return;

    // 1️⃣ Get chosen stack
    List<TarotCard> chosenStack = List.from(cardStacks[stackIndex]);
    chosenStack.shuffle();

    // Pick 6 cards
    List<TarotCard> chosenSix = chosenStack.take(6).toList();

    // 2️⃣ Combine all other stacks into 1 list
    List<TarotCard> otherCards = [];
    for (int i = 0; i < cardStacks.length; i++) {
      if (i != stackIndex) {
        otherCards.addAll(cardStacks[i]);
      }
    }

    otherCards.shuffle();

    // Pick 1 extra card
    TarotCard extraCard = otherCards.first;

    // 3️⃣ Final selected cards
    selectedCards.value = [
      ...chosenSix,
      extraCard,
    ];
  }

  // Reset everything
  void resetReading() {
    cardStacks.clear();
    selectedCards.clear();
    isShuffling.value = false;
    hasShuffled.value = false;
  }
}
