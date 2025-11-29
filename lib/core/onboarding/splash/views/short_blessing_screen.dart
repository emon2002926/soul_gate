import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../constants/app_assert_image.dart';

class ShortBlessingController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final isSpeaking = false.obs;
  final isCompleted = false.obs;
  final isInitialized = false.obs;

  final String blessingText =
      "Archangel Michael, protect this session from any false or negative energy. "
      "Reveal only what the client needs for clarity and truth. "
      "Thank you, thank you, thank you.";

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      // Configure TTS settings
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);

      // For iOS
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      // Set handlers
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

      // Start speaking after a short delay
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
      // Navigate to shuffle screen or next step
      // Get.off(() => const ShuffleScreen());
    });
  }

  Future<void> skipBlessing() async {
    await flutterTts.stop();
    isSpeaking.value = false;
    Get.back();
  }

  @override
  void onClose() {
    flutterTts.stop();
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
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFFD4AF37),
                size: 28,
              ),
            ),
          ),
        ),
        title: const Text(
          'Short Blessing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFFD4AF37),
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
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFFD4AF37),
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
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Blessing Text - Always visible now
                const Text(
                  'Archangel Michael, Protect This\nSession From Any False Or\nNegative Energy.\nReveal Only What The Client\nNeeds For Clarity And Truth.\nThank You, Thank You, Thank\nYou.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.6,
                    letterSpacing: 0.5,
                  ),
                ),

                const Spacer(flex: 2),

                // Speaking Indicator
                Obx(() {
                  if (controller.isSpeaking.value) {
                    return Column(
                      children: [
                        const _SpeakingIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Speaking...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
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

                const SizedBox(height: 40),

                // Skip Button
                TextButton(
                  onPressed: controller.skipBlessing,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SPEAKING INDICATOR WIDGET (Animated)
// ============================================================================

class _SpeakingIndicator extends StatefulWidget {
  const _SpeakingIndicator();

  @override
  State<_SpeakingIndicator> createState() => _SpeakingIndicatorState();
}

class _SpeakingIndicatorState extends State<_SpeakingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      5,
          (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers
        .map((controller) => Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    ))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 4,
                height: 20 * _animations[index].value,
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