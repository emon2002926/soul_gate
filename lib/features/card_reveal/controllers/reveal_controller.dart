import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/core/util/storage_service.dart';
import '../../card_shuffle/views/full_reading_screen.dart';
import '../../subscription/views/subscription_page.dart';
import '../models/tarot_response.dart';
import '../views/widgets/reveal_dialogs.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RevealController extends GetxController {
  // Updated base URL
  static const String baseUrl = 'https://sofiapi.dsrt321.online/tarot/api';

  // Bearer token
  static String? bearerToken = StorageService.accessToken;

  static const int maxRetries = 3;

  final audioPlayer = AudioPlayer();

  // Flip states for each card
  var isFlipped = <bool>[].obs;

  var selectedCardIndex = Rxn<int>();

  var allCardsRevealed = false.obs;

  var isAnimating = false.obs;

  var isLoadingInterpretation = true.obs;
  var tarotReading = Rxn<TarotReading>();

  var retryCount = 0.obs;

  var isSpeaking = false.obs;
  var isDownloadingAudio = false.obs;

  @override
  void onInit() {
    super.onInit();

    try {
      _initializeController();
      _initializeAudioPlayer();
    } catch (e) {
      debugPrint('❌ RevealController initialization error: $e');
      isLoadingInterpretation.value = false;
    }
  }

  @override
  void onClose() {
    stopSpeaking();
    audioPlayer.dispose();
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

  void _initializeAudioPlayer() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        isSpeaking.value = true;
      } else if (state == PlayerState.completed || state == PlayerState.stopped) {
        isSpeaking.value = false;
      }
    });
  }

  void delayedFetchInterpretation(String question, int cardCount) {
    Future.delayed(const Duration(milliseconds: 100), () {
      _fetchInterpretation(question, cardCount);
    });
  }

  Future<void> fetchInterpretation(String question, int cardCount) async {
    try {
      isLoadingInterpretation.value = true;
      await _fetchInterpretation(question, cardCount);
    } catch (e) {
      debugPrint('❌ Failed to fetch interpretation: $e');
      isLoadingInterpretation.value = false;

      Get.snackbar(
        'Error',
        'Failed to load interpretation. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _fetchInterpretation(String question, int cardCount) async {
    isLoadingInterpretation.value = true;

    try {
      final uri = Uri.parse('$baseUrl/interpret');

      debugPrint('🔄 Making API request (attempt ${retryCount.value + 1}/$maxRetries)...');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: json.encode({
          'question': question,
          'custom_question': '',
          'language': StorageService.language,
          'generate_audio': true,
          'card_count': cardCount,
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
          tarotReading.value = TarotReading.fromJson(data);

          final actualCardCount = tarotReading.value!.cardCount;
          isFlipped.value = List.generate(actualCardCount, (index) => false);

          isLoadingInterpretation.value = false;
          retryCount.value = 0;

          debugPrint('✅ Interpretation loaded successfully');
          debugPrint('📊 Cards: ${tarotReading.value!.interpretations.length}');
          debugPrint('📝 Final interpretation length: ${tarotReading.value!.finalInterpretation.length}');
          debugPrint('🔊 Final audio URL: ${tarotReading.value!.finalAudioUrl}');
        } else {
          debugPrint('❌ API returned success=false');
          isLoadingInterpretation.value = false;
          _handleApiError('Server returned an error', cardCount, question, response.statusCode);
        }
      } else if (response.statusCode == 403) {
        // Handle subscription error
        debugPrint('❌ Subscription required (403)');
        debugPrint('📄 Response body: ${response.body}');
        isLoadingInterpretation.value = false;
        _handleSubscriptionError();
      } else {
        debugPrint('❌ API error: ${response.statusCode}');
        debugPrint('📄 Response body: ${response.body}');
        isLoadingInterpretation.value = false;
        _handleApiError('Server error (${response.statusCode})', cardCount, question, response.statusCode);
      }
    } on TimeoutException catch (e) {
      debugPrint('⏱️ Timeout: $e');
      isLoadingInterpretation.value = false;
      _handleApiError('Request timed out. The AI is taking longer than expected.', cardCount, question, null);
    } catch (e) {
      debugPrint('❌ API error: $e');
      isLoadingInterpretation.value = false;
      _handleApiError('An unexpected error occurred', cardCount, question, null);
    }
  }

  void _handleSubscriptionError() {
    RevealDialogs.showSubscriptionRequiredDialog(
      onGoToSubscription: () {
        Get.back(); // Close dialog
        Get.back(); // Go back from reveal screen
        // Navigate to subscription page
        AppNavigation.push(Get.context!, const SubscriptionPage());
      },
      onGoBack: () {
        Get.back(); // Close dialog
        Get.back(); // Go back from reveal screen
      },
    );
  }

  void _handleApiError(String message, int cardCount, String question, int? statusCode) {
    // Don't retry if it's a 403 error (already handled separately)
    if (statusCode == 403) return;

    if (retryCount.value < maxRetries - 1) {
      _showRetryDialog(message, cardCount, question);
    } else {
      _showErrorDialog(message, cardCount, question);
      retryCount.value = 0;
    }
  }

  void _showRetryDialog(String message, int cardCount, String question) {
    RevealDialogs.showRetryDialog(
      message: message,
      currentAttempt: retryCount.value + 1,
      maxRetries: maxRetries,
      onRetry: () {
        Get.back();
        retryCount.value++;
        _fetchInterpretation(question, cardCount);
      },
      onGoBack: () {
        Get.back();
        Get.back();
        retryCount.value = 0;
      },
    );
  }

  void _showErrorDialog(String message, int cardCount, String question) {
    RevealDialogs.showErrorDialog(
      message: message,
      onTryAgain: () {
        Get.back();
        retryCount.value = 0;
        _fetchInterpretation(question, cardCount);
      },
      onGoBack: () {
        Get.back();
        Get.back();
      },
    );
  }

  void _showFinalInterpretation() {
    final reading = tarotReading.value;
    if (reading == null || reading.finalInterpretation.isEmpty) return;

    RevealDialogs.showFinalInterpretation(
      interpretation: reading.finalInterpretation,
      onListen: () => playFinalAudio(),
    );
  }

  void flipCard(int index) {
    if (index < 0 || index >= isFlipped.length) return;
    if (isAnimating.value) return;

    isAnimating.value = true;

    isFlipped[index] = !isFlipped[index];

    if (isFlipped[index]) {
      selectedCardIndex.value = index;
    }

    _checkAllCardsRevealed();

    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimating.value = false;
    });
  }

  void _checkAllCardsRevealed() {
    final allRevealed = isFlipped.every((flipped) => flipped == true);

    if (allRevealed && !allCardsRevealed.value) {
      allCardsRevealed.value = true;
      _onAllCardsRevealed();
    }
  }

  void _onAllCardsRevealed() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      _showFinalInterpretation();
    });
  }

  void navigateToFullReading(String message) {
    _showFinalInterpretation();
    AppNavigation.push(
      Get.context!,
      FullReadingScreen(
        finalMessage: tarotReading.value!.finalInterpretation,
        audioUrl: tarotReading.value!.finalAudioUrl,
        questionText: message,
      ),
    );
  }

  void closeCardDetails() {
    selectedCardIndex.value = null;
    stopSpeaking();
  }

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

  /// Download and play audio from URL
  Future<void> playAudioFromUrl(String audioUrl) async {
    if (audioUrl.isEmpty) {
      debugPrint('❌ No audio URL provided');
      Get.snackbar(
        'Audio Unavailable',
        'No audio available for this content',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      if (isSpeaking.value) {
        await stopSpeaking();
        return;
      }

      debugPrint('🔊 Downloading audio from: $audioUrl');
      isDownloadingAudio.value = true;

      // Construct full URL
      String fullUrl;
      if (audioUrl.startsWith('http')) {
        fullUrl = audioUrl;
      } else {
        fullUrl = '$baseUrl$audioUrl';
      }

      // Add timestamp parameter
      if (!fullUrl.contains('?t=')) {
        final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        fullUrl = '$fullUrl?t=$timestamp';
      }

      debugPrint('🔊 Full audio URL: $fullUrl');

      // Download the file
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final fileName = 'tarot_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
        final filePath = '${tempDir.path}/$fileName';

        // Write file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        debugPrint('✅ Audio downloaded to: $filePath');
        debugPrint('📦 File size: ${response.bodyBytes.length} bytes');

        isDownloadingAudio.value = false;

        // Play from local file
        await audioPlayer.play(DeviceFileSource(filePath));
        isSpeaking.value = true;

        // Clean up file after playing
        audioPlayer.onPlayerComplete.listen((_) async {
          try {
            if (await file.exists()) {
              await file.delete();
              debugPrint('🗑️ Cleaned up audio file: $filePath');
            }
          } catch (e) {
            debugPrint('⚠️ Could not delete temp file: $e');
          }
        });
      } else {
        debugPrint('❌ Failed to download audio: ${response.statusCode}');
        isDownloadingAudio.value = false;
        Get.snackbar(
          'Download Failed',
          'Could not download audio (${response.statusCode})',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('❌ Audio download/playback error: $e');
      isDownloadingAudio.value = false;
      isSpeaking.value = false;

      Get.snackbar(
        'Audio Error',
        'Failed to play audio: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> playFinalAudio() async {
    final audioUrl = finalAudioUrl;
    if (audioUrl.isEmpty) {
      debugPrint('❌ No final audio URL available');
      return;
    }
    await playAudioFromUrl(audioUrl);
  }

  Future<void> playCardAudio() async {
    final interpretation = currentCardInterpretation;
    if (interpretation == null) {
      debugPrint('❌ No interpretation available');
      return;
    }

    final audioUrl = interpretation.audioUrl;
    if (audioUrl.isEmpty) {
      debugPrint('❌ No audio URL for this card');
      return;
    }

    await playAudioFromUrl(audioUrl);
  }

  Future<void> speakCardMeaning(TarotCard card) async {
    await playCardAudio();
  }

  Future<void> stopSpeaking() async {
    await audioPlayer.stop();
    isSpeaking.value = false;
    isDownloadingAudio.value = false;
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

  String get finalAudioUrl {
    return tarotReading.value?.finalAudioUrl ?? '';
  }
}