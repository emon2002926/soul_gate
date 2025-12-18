import 'package:get/get.dart';
import '../../home/data/cards_data.dart';
import '../../home/data/tarot_card.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';

class CardController extends GetxController {
  // Base URL for API
  static const String baseUrl = 'https://sofiai.dsrt321.online/api'; // For Android emulator

  // All 78 cards
  List<TarotCard> allCards = [];

  // 13 stacks of 6 cards each
  var cardStacks = <List<TarotCard>>[].obs;

  // Final selected cards
  var selectedCards = <TarotCard>[].obs;

  // UI states
  var isShuffling = false.obs;
  var hasShuffled = false.obs;

  // Reading type: 7 or 3
  var readingCardCount = 7.obs;

  // Shuffle API response data
  var shuffleCount = 0.obs;
  var shufflesRemaining = 7.obs;

  @override
  void onInit() {
    super.onInit();
    allCards = CardsData.getAllCards();
  }

  @override
  void onReady() {
    super.onReady();
    shuffleAndDivideCards();
  }

  // Set reading type and call shuffle API
  Future<void> setReadingType(int cardCount) async {
    readingCardCount.value = cardCount;
    await shuffleAndDivideCards();
  }

  // Shuffle deck via API + divide into stacks locally
  Future<void> shuffleAndDivideCards() async {
    isShuffling.value = true;

    try {
      final response = await _callShuffleApi();

      if (response != null && response['success'] == true) {
        shuffleCount.value = response['shuffle_count'] ?? 0;
        shufflesRemaining.value = response['shuffles_remaining'] ?? 0;

        _performLocalShuffle();

        await Future.delayed(Duration(seconds: 2));

        isShuffling.value = false;
        hasShuffled.value = true;
      } else {
        isShuffling.value = false;
        _showNetworkErrorDialog();
      }
    } catch (e) {
      isShuffling.value = false;
      _showNetworkErrorDialog();
    }
  }

  // Local shuffle logic
  void _performLocalShuffle() {
    List<TarotCard> shuffled = List.from(allCards);
    shuffled.shuffle();

    cardStacks.clear();

    for (int i = 0; i < 13; i++) {
      int start = i * 6;
      int end = start + 6;
      List<TarotCard> stack = shuffled.sublist(start, end);
      cardStacks.add(stack);
    }
  }

  // API call to shuffle endpoint
  Future<Map<String, dynamic>?> _callShuffleApi() async {
    try {
      final uri = Uri.parse('$baseUrl/shuffle').replace(
        queryParameters: {'Content-Type': 'application/json'},
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("resonse askjfh: ${response.body}");
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Shuffle API exception: $e');
      return null;
    }
  }

  // Show network error dialog
  void _showNetworkErrorDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFFF5F3EE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFD4A574).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  color: Color(0xFFD4A574),
                  size: 48,
                ),
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'Connection Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C2A21),
                ),
              ),
              SizedBox(height: 12),

              // Message
              Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5C4A42),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),

              // Retry button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    shuffleAndDivideCards(); // Retry
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4A574),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go back to previous screen
                  },
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8B7355),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // User selects a stack
  void selectStack(int stackIndex) {
    if (stackIndex < 0 || stackIndex >= cardStacks.length) return;

    if (readingCardCount.value == 7) {
      _select7Cards(stackIndex);
    } else {
      _select3Cards(stackIndex);
    }
  }

  void _select7Cards(int stackIndex) {
    List<TarotCard> chosenStack = List.from(cardStacks[stackIndex]);
    chosenStack.shuffle();

    List<TarotCard> chosenSix = chosenStack.take(6).toList();

    List<TarotCard> otherCards = [];
    for (int i = 0; i < cardStacks.length; i++) {
      if (i != stackIndex) {
        otherCards.addAll(cardStacks[i]);
      }
    }
    otherCards.shuffle();

    TarotCard extraCard = otherCards.first;

    selectedCards.value = [...chosenSix, extraCard];
  }

  void _select3Cards(int stackIndex) {
    List<TarotCard> chosenStack = List.from(cardStacks[stackIndex]);
    chosenStack.shuffle();

    selectedCards.value = chosenStack.take(3).toList();
  }

  void resetReading() {
    cardStacks.clear();
    selectedCards.clear();
    isShuffling.value = false;
    hasShuffled.value = false;
    shuffleCount.value = 0;
    shufflesRemaining.value = 7;
  }
}