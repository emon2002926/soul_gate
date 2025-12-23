import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import '../../../../features/card_shuffle/views/shuffle_screen.dart';
import '../../../../features/profile/views/profile_page.dart';
import '../../../constants/app_assert_image.dart';


class ShortBlessingController extends GetxController
    with GetTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  final isSpeaking = false.obs;
  final isCompleted = false.obs;
  final isInitialized = false.obs;

  // Animation controllers for speaking indicator
  late List<AnimationController> speakingAnimControllers;
  late List<Animation<double>> speakingAnimations;

  final String blessingText =
      "In this moment, I open this session with clarity and intention. "
      "Archangel Michael surrounds us with his light and protects this space. "
      "Guides of light, reveal only what serves the highest good. "
      "May every message bring truth, peace, and alignment. "
      "Thank you, thank you, thank you. And so it is.";

  @override
  void onInit() {
    super.onInit();
    _initSpeakingAnimations();
    _initTts();
  }

  void _initSpeakingAnimations() {
    speakingAnimControllers = List.generate(
      5,
          (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      )..repeat(reverse: true),
    );

    speakingAnimations = speakingAnimControllers
        .map((controller) => Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    ))
        .toList();
  }

  Future<void> _initTts() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);

      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      flutterTts.setStartHandler(() {
        isSpeaking.value = true;
      });

      flutterTts.setCompletionHandler(() {
        isSpeaking.value = false;
        isCompleted.value = true;
        _onBlessingComplete();
      });

      flutterTts.setErrorHandler((msg) {
        debugPrint("TTS Error: $msg");
        isSpeaking.value = false;
      });

      isInitialized.value = true;

      await Future.delayed(const Duration(milliseconds: 1000));
      await _speakBlessing();
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> _speakBlessing() async {
    if (isInitialized.value) {
      isSpeaking.value = true;
      var result = await flutterTts.speak(blessingText);
      if (result != 1) {
        debugPrint("TTS speak failed");
      }
    }
  }

  void _onBlessingComplete() {
    Future.delayed(const Duration(seconds: 2), () {
      // AppNavigation.push(Get.context!, ShuffleScreen());
    });
  }

  Future<void> skipBlessing() async {
    await flutterTts.stop();
    isSpeaking.value = false;
    AppNavigation.push(Get.context!, ShuffleScreen());
  }

  @override
  void onClose() {
    flutterTts.stop();
    for (var controller in speakingAnimControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}

class ShortBlessingScreen extends StatelessWidget {
  const ShortBlessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShortBlessingController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              controller.flutterTts.stop();
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        title: const Text(
          'Saint Michael\'s Blessing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to profile
                AppNavigation.push(Get.context!, ProfilePage());
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
            // Optional: Add a dark overlay for better text readability
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Saint Michael Image
              Image.asset(
                AppAssertImage.instance.saintMichaelImage, // Add this image to your assets
                width: 280,
                height: 280,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Blessing Text
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          'IN THIS MOMENT, I OPEN THIS SESSION\nWITH CLARITY AND INTENTION.\nARCHANGEL MICHAEL SURROUNDS US\nWITH HIS LIGHT AND PROTECTS THIS\nSPACE.\nGUIDES OF LIGHT, REVEAL ONLY WHAT\nSERVES THE HIGHEST GOOD.\nMAY EVERY MESSAGE BRING TRUTH, PEACE,\nAND ALIGNMENT.\nTHANK YOU, THANK YOU, THANK YOU.\nAND SO IT IS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.5,
                            letterSpacing: 0.8,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Speaking Indicator
                        Obx(() {
                          if (controller.isSpeaking.value) {
                            return Column(
                              children: [
                                SpeakingIndicator(controller: controller),
                                const SizedBox(height: 16),
                                const Text(
                                  'Speaking...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          } else if (controller.isCompleted.value) {
                            return Column(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFFD4AF37),
                                  size: 40,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Blessing Complete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox(height: 70);
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Skip Button
              TextButton(
                onPressed: controller.skipBlessing,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeakingIndicator extends StatelessWidget {
  final ShortBlessingController controller;

  const SpeakingIndicator({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: controller.speakingAnimations[index],
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 4,
                height: 20 * controller.speakingAnimations[index].value,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}