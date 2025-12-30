import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:soul_gate/features/card_shuffle/views/question_screen.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/util/app_navigation.dart';
import 'package:get/get.dart';

class FullReadingScreen extends StatelessWidget {
  final String questionText;
  final String finalMessage;
  final String audioUrl;

  FullReadingScreen({
    super.key,
    required this.finalMessage,
    required this.audioUrl,
    required this.questionText,
  });

  AppStrings appStrings = AppStrings.instance;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FullReadingController(audioUrl: audioUrl));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F3EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            controller.stopAudio();
            Navigator.pop(context);
          },
        ),
        title: AppText(
          data: appStrings.appProgressMessage,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildReadingCard(context, controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingCard(
    BuildContext context,
    FullReadingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(AppAssertImage.instance.cardBg),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: AppText(
                data: appStrings.appProgressTitle,
                textAlign: TextAlign.center,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3C2A21),
              ),
            ),

            const SizedBox(height: 24),

            // Reading content
            AppText(
              data: finalMessage,
              textAlign: TextAlign.center,
              fontSize: 15,
              color: const Color(0xFF5C4A42),
              height: 1.6,
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Speaker button with loading/playing state
                Obx(() {
                  final isLoading = controller.isDownloadingAudio.value;
                  final isPlaying = controller.isSpeaking.value;

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A574),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(
                              isPlaying ? Icons.stop : Icons.volume_up,
                              color: Colors.white,
                            ),
                      onPressed: isLoading
                          ? null
                          : () {
                              controller.playAudio();
                            },
                    ),
                  );
                }),
                const SizedBox(width: 12),

                // Share button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A574),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Image.asset(
                      AppAssertImage.instance.shareIcon,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      AppNavigation.push(context, QuestionScreen());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Controller for FullReadingScreen
class FullReadingController extends GetxController {
  final String audioUrl;
  final audioPlayer = AudioPlayer();

  var isSpeaking = false.obs;
  var isDownloadingAudio = false.obs;

  FullReadingController({required this.audioUrl});

  @override
  void onInit() {
    super.onInit();
    _initializeAudioPlayer();
  }

  @override
  void onClose() {
    stopAudio();
    audioPlayer.dispose();
    super.onClose();
  }

  void _initializeAudioPlayer() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        isSpeaking.value = true;
      } else if (state == PlayerState.completed ||
          state == PlayerState.stopped) {
        isSpeaking.value = false;
      }
    });
  }

  Future<void> playAudio() async {
    if (audioUrl.isEmpty) {
      debugPrint('❌ No audio URL provided');
      Get.snackbar(
        'Audio Unavailable',
        'No audio available for this reading',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      if (isSpeaking.value) {
        await stopAudio();
        return;
      }

      debugPrint('🔊 Downloading audio from: $audioUrl');
      isDownloadingAudio.value = true;

      // Construct full URL
      String fullUrl;
      if (audioUrl.startsWith('http')) {
        fullUrl = audioUrl;
      } else {
        const String audioBaseUrl = 'https://sofiapi.dsrt321.online';
        fullUrl = '$audioBaseUrl$audioUrl';
      }

      // Add timestamp parameter
      if (!fullUrl.contains('?t=')) {
        final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        fullUrl = '$fullUrl?t=$timestamp';
      }

      debugPrint('🔊 Full audio URL: $fullUrl');

      // Download the file
      final response = await http
          .get(
            Uri.parse(fullUrl),
            headers: {'Authorization': 'Bearer ${StorageService.accessToken}'},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'final_reading_${DateTime.now().millisecondsSinceEpoch}.mp3';
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

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    isSpeaking.value = false;
    isDownloadingAudio.value = false;
  }
}
