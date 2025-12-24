import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/core/util/storage_service.dart';
import '../../card_shuffle/views/full_reading_screen.dart';
import '../models/tarot_response.dart';
import '../views/widgets/reveal_dialogs.dart';

class RevealController extends GetxController {
  // Updated base URL
  static const String baseUrl = 'https://sofiapi.dsrt321.online/tarot/api';

  // Add your Bearer token here
  static  String? bearerToken =StorageService.accessToken  ; // Replace with actual token

  static const int maxRetries = 3;

  final FlutterTts flutterTts = FlutterTts();

  // Flip states for each card
  var isFlipped = <bool>[].obs;

  var selectedCardIndex = Rxn<int>();

  var allCardsRevealed = false.obs;

  // Animation states
  var isAnimating = false.obs;

  var isLoadingInterpretation = true.obs;
  var tarotReading = Rxn<TarotReading>();

  // Question for the reading
  var question = 'What truth do you need to see today about your love life?'.obs;

  // Retry state
  var retryCount = 0.obs;

  var isSpeaking = false.obs;

  @override
  void onInit() {
    super.onInit();

    try {
      _initializeController();
      _initializeTts();

      // Delay API call slightly to ensure UI is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        _fetchInterpretation();
      });
    } catch (e) {
      debugPrint('❌ RevealController initialization error: $e');
      isLoadingInterpretation.value = false;
    }
  }

  @override
  void onClose() {
    stopSpeaking();
    super.onClose();
  }

  void _initializeController() {
    try {
      isFlipped.value = List.generate(3, (index) => false);
      debugPrint('✅ RevealController initialized');
    } catch (e) {
      debugPrint('❌ RevealController initialization error: $e');
      rethrow;
    }
  }

  void _initializeTts() {
    flutterTts.setLanguage('en-US');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });
  }

  Future<void> _fetchInterpretation() async {
    isLoadingInterpretation.value = true;

    try {
      final uri = Uri.parse('$baseUrl/interpret');

      debugPrint('🔄 Making API request (attempt ${retryCount.value + 1}/$maxRetries)...');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken', // Added Bearer token
        },
        body: json.encode({
          'question': question.value,
          'custom_question': '',
          'language': 'en',
          'generate_audio': true,
          'card_count': 3,
        }),
      ).timeout(
        const Duration(seconds: 70),
        onTimeout: () {
          throw TimeoutException(
            'The reading is taking longer than expected. Please try again.',
            const Duration(seconds: 45),
          );
        },
      );

      debugPrint('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          // Parse using TarotReading model
          tarotReading.value = TarotReading.fromJson(data);

          // Initialize flip states based on actual card count from API
          final actualCardCount = tarotReading.value!.cardCount;
          isFlipped.value = List.generate(actualCardCount, (index) => false);

          isLoadingInterpretation.value = false;
          retryCount.value = 0;

          debugPrint('✅ Interpretation loaded successfully');
          debugPrint('📊 Cards: ${tarotReading.value!.interpretations.length}');
          debugPrint('📝 Final interpretation length: ${tarotReading.value!.finalInterpretation.length}');
        } else {
          debugPrint('❌ API returned success=false');
          isLoadingInterpretation.value = false;
          _handleApiError('Server returned an error');
        }
      } else {
        debugPrint('❌ API error: ${response.statusCode}');
        debugPrint('📄 Response body: ${response.body}');
        isLoadingInterpretation.value = false;
        _handleApiError('Server error (${response.statusCode})');
      }
    } on TimeoutException catch (e) {
      debugPrint('⏱️ Timeout: $e');
      isLoadingInterpretation.value = false;
      _handleApiError('Request timed out. The AI is taking longer than expected.');
    } catch (e) {
      debugPrint('❌ API error: $e');
      isLoadingInterpretation.value = false;
      _handleApiError('An unexpected error occurred');
    }
  }

  /// Handle API errors with retry option
  void _handleApiError(String message) {
    if (retryCount.value < maxRetries - 1) {
      _showRetryDialog(message);
    } else {
      _showErrorDialog(message);
      retryCount.value = 0;
    }
  }

  /// Show retry dialog
  void _showRetryDialog(String message) {
    RevealDialogs.showRetryDialog(
      message: message,
      currentAttempt: retryCount.value + 1,
      maxRetries: maxRetries,
      onRetry: () {
        Get.back();
        retryCount.value++;
        _fetchInterpretation();
      },
      onGoBack: () {
        Get.back();
        Get.back();
        retryCount.value = 0;
      },
    );
  }

  /// Show final error dialog after all retries
  void _showErrorDialog(String message) {
    RevealDialogs.showErrorDialog(
      message: message,
      onTryAgain: () {
        Get.back();
        retryCount.value = 0;
        _fetchInterpretation();
      },
      onGoBack: () {
        Get.back();
        Get.back();
      },
    );
  }

  /// Show final interpretation dialog
  void _showFinalInterpretation() {
    final reading = tarotReading.value;
    if (reading == null || reading.finalInterpretation.isEmpty) return;

    RevealDialogs.showFinalInterpretation(
      interpretation: reading.finalInterpretation,
      onListen: () => speakText(reading.finalInterpretation),
    );
  }

  void flipCard(int index) {
    if (index < 0 || index >= isFlipped.length) return;
    if (isAnimating.value) return;

    isAnimating.value = true;

    // Toggle flip state
    isFlipped[index] = !isFlipped[index];

    if (isFlipped[index]) {
      selectedCardIndex.value = index;
    }

    _checkAllCardsRevealed();

    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimating.value = false;
    });
  }

  /// Check if all cards have been flipped
  void _checkAllCardsRevealed() {
    final allRevealed = isFlipped.every((flipped) => flipped == true);

    if (allRevealed && !allCardsRevealed.value) {
      allCardsRevealed.value = true;
      _onAllCardsRevealed();
    }
  }

  /// Called when all cards are revealed
  void _onAllCardsRevealed() {
    // Show final interpretation after all cards revealed
    Future.delayed(const Duration(milliseconds: 1000), () {
      _showFinalInterpretation();
    });
  }

  /// Navigate to full reading screen
  void navigateToFullReading() {
    // Show final interpretation instead of navigating
    _showFinalInterpretation();
    AppNavigation.push(Get.context!, FullReadingScreen(finalMessage: tarotReading.value!.finalInterpretation,));
  }

  /// Close card details panel
  void closeCardDetails() {
    selectedCardIndex.value = null;
    stopSpeaking();
  }

  /// Reset reveal state (useful for re-reading)
  void resetReveal() {
    final reading = tarotReading.value;
    final cardCount = reading?.cardCount ?? 3;
    isFlipped.value = List.generate(cardCount, (index) => false);
    selectedCardIndex.value = null;
    allCardsRevealed.value = false;
    isAnimating.value = false;
    retryCount.value = 0;
    stopSpeaking();
  }

  /// Text-to-speech for any text
  Future<void> speakText(String text) async {
    if (isSpeaking.value) {
      await stopSpeaking();
      return;
    }

    isSpeaking.value = true;
    await flutterTts.speak(text);
  }

  /// Text-to-speech for card meaning
  Future<void> speakCardMeaning(TarotCard card) async {
    final interpretation = currentCardInterpretation;
    if (interpretation == null) {
      debugPrint('No interpretation available for: ${card.name}');
      return;
    }

    await speakText(interpretation.interpretation);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    isSpeaking.value = false;
  }

  int get cardCount {
    return tarotReading.value?.cardCount ?? 3;
  }

  List<TarotCard> get cards {
    return tarotReading.value?.cards ?? [];
  }

  bool get is7CardReading {
    return cardCount == 7;
  }

  TarotCard? getCardAt(int index) {
    final cardsList = cards;
    if (index < 0 || index >= cardsList.length) return null;
    return cardsList[index];
  }

  bool isCardFlipped(int index) {
    if (index < 0 || index >= isFlipped.length) return false;
    return isFlipped[index];
  }

  TarotCard? get currentSelectedCard {
    final index = selectedCardIndex.value;
    if (index == null || index < 0 || index >= cards.length) {
      return null;
    }
    return cards[index];
  }

  CardInterpretation? get currentCardInterpretation {
    final reading = tarotReading.value;
    if (reading == null) return null;

    final index = selectedCardIndex.value;
    if (index == null || index < 0 || index >= reading.interpretations.length) {
      return null;
    }
    return reading.interpretations[index];
  }

  String getPositionLabel(int index) {
    final reading = tarotReading.value;
    if (reading == null) return '';
    if (index < 0 || index >= reading.interpretations.length) return '';
    return reading.interpretations[index].position;
  }

  String getInterpretationText(int index) {
    final reading = tarotReading.value;
    if (reading == null) return '';
    if (index < 0 || index >= reading.interpretations.length) return '';
    return reading.interpretations[index].interpretation;
  }

  /// Get card symbol/emoji for card
  String getCardSymbol(int index) {
    final reading = tarotReading.value;
    if (reading == null) return '';
    if (index < 0 || index >= reading.interpretations.length) return '';
    return reading.interpretations[index].symbol;
  }

  List<CardInterpretation> get interpretations {
    return tarotReading.value?.interpretations ?? [];
  }

  String get finalInterpretation {
    return tarotReading.value?.finalInterpretation ?? '';
  }

  /// Get final audio URL
  String get finalAudioUrl {
    return tarotReading.value?.finalAudioUrl ?? '';
  }
}