import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../../../../features/card_shuffle/views/shuffle_screen.dart';
import '../../../../features/profile/views/profile_page.dart';
import '../../../constants/app_assert_image.dart';
import '../../../constants/app_strings.dart';
import '../../../util/screen_size.dart';
import '../../../util/storage_service.dart';


class ShortBlessingScreen extends StatelessWidget {
  final String questionText;
  final int readingTypeIndex;
  final int deckIndex;
  final int? questionId;

  const ShortBlessingScreen({
    super.key,
    required this.questionText,
    required this.readingTypeIndex,
    required this.deckIndex,
    this.questionId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShortBlessingController(
      questionText: questionText,
      readingTypeIndex: readingTypeIndex,
      deckIndex: deckIndex,
    ));
    AppStrings appStrings = AppStrings.instance;

    print("questionText: $questionText");
    print("questionId: $questionId");
    print("readingTypeIndex: $readingTypeIndex");
    print("deckIndex: $deckIndex");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(context.spacing8),
          child: GestureDetector(
            onTap: () {
              controller.audioPlayer.stop();
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: context.responsiveSize(24),
              ),
            ),
          ),
        ),
        title: AppText(
          data: appStrings.saintMichaelsBlessingTitle,
          fontSize: context.responsiveFontSize(18),
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(context.spacing8),
            child: GestureDetector(
              onTap: () {
                AppNavigation.push(Get.context!, ProfilePage());
              },
              child: Container(
                padding: EdgeInsets.all(context.spacing8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: context.responsiveSize(24),
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
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              SizedBox(height: context.heightPercentage(2),),
              // Saint Michael Image
              Image.asset(
                AppAssertImage.instance.saintMichaelImage,
                width: context.widthPercentage(74.7), // ~280px on 375px screen
                height: context.widthPercentage(74.7),
                fit: BoxFit.contain,
              ),

              SizedBox(height: context.heightPercentage(2)),

              // Blessing Text
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.spacing32),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.instance.saintMichaelsBlessingText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: context.responsiveFontSize(16),
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.5,
                            letterSpacing: 0.8,
                          ),
                        ),

                        SizedBox(height: context.heightPercentage(5)),

                        // Playing Indicator
                        Obx(() {
                          if (controller.isPlaying.value) {
                            return Column(
                              children: [
                                _SimpleSpeakingIndicator(),
                                SizedBox(height: context.spacing16),
                                Text(
                                  'Playing...',
                                  style: TextStyle(
                                    fontSize: context.responsiveFontSize(14),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          } else if (controller.isCompleted.value) {
                            return Column(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: const Color(0xFFD4AF37),
                                  size: context.responsiveSize(40),
                                ),
                                SizedBox(height: context.spacing12),
                                Text(
                                  'Blessing Complete',
                                  style: TextStyle(
                                    fontSize: context.responsiveFontSize(14),
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            );
                          }
                          return SizedBox(height: context.responsiveSize(70));
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
                  appStrings.skip,
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(15),
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),

              SizedBox(height: context.heightPercentage(3.75)),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple speaking indicator without animation controller
class _SimpleSpeakingIndicator extends StatefulWidget {
  @override
  State<_SimpleSpeakingIndicator> createState() => _SimpleSpeakingIndicatorState();
}

class _SimpleSpeakingIndicatorState extends State<_SimpleSpeakingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> controllers;
  late List<Animation<double>> animations;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      5,
          (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      )..repeat(reverse: true),
    );

    animations = controllers
        .map((controller) => Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    ))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.responsiveSize(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: animations[index],
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: context.responsiveSize(3)),
                width: context.responsiveSize(4),
                height: context.responsiveSize(20) * animations[index].value,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(context.responsiveSize(2)),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// Controller remains the same
class ShortBlessingController extends GetxController {
  final audioPlayer = AudioPlayer();
  final isPlaying = false.obs;
  final isCompleted = false.obs;
  final isInitialized = false.obs;

  // Animation controllers for speaking indicator
  late List<AnimationController> speakingAnimControllers;
  late List<Animation<double>> speakingAnimations;

  final String blessingText = AppStrings.instance.saintMichaelsBlessingTextSH;
  final String? questionText;
  final int? readingTypeIndex;
  final int? deckIndex;

  ShortBlessingController({
    this.questionText,
    this.readingTypeIndex,
    this.deckIndex,
  });

  @override
  void onInit() {
    super.onInit();
    _initSpeakingAnimations();
    _initAudio();
  }

  void _initSpeakingAnimations() {
    // Since we don't have vsync in GetxController, we'll handle this differently
    // We'll use a simpler animation approach
  }

  Future<void> _initAudio() async {
    try {
      // Get current language
      final language = StorageService.language;

      // Determine audio file path based on language
      final audioPath = language == 'es'
          ? 'assets/audio/blessing_es.mp3'
          : 'assets/audio/blessing_en.mp3';

      print('Loading audio: $audioPath for language: $language');

      // Set audio source from asset
      await audioPlayer.setSource(AssetSource(
          language == 'es'
              ? 'audio/blessing_es.mp3'
              : 'audio/blessing_en.mp3'
      ));

      // Listen to player state
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.playing) {
          isPlaying.value = true;
        } else if (state == PlayerState.completed) {
          isPlaying.value = false;
          isCompleted.value = true;
          _onBlessingComplete();
        } else {
          isPlaying.value = false;
        }
      });

      isInitialized.value = true;

      // Auto-play after 1 second
      await Future.delayed(const Duration(milliseconds: 1000));
      await _playBlessing();
    } catch (e) {
      debugPrint("Audio Init Error: $e");
      // If audio fails, skip to next screen after showing error
      Get.snackbar(
        'Audio Error',
        'Could not load blessing audio',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _playBlessing() async {
    if (isInitialized.value) {
      try {
        isPlaying.value = true;
        await audioPlayer.resume();
      } catch (e) {
        debugPrint("Audio play failed: $e");
        isPlaying.value = false;
      }
    }
  }

  void _onBlessingComplete() {
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to shuffle screen with parameters
      AppNavigation.push(
        Get.context!,
        ShuffleScreen(
          questionText: questionText ?? '',
          readingTypeIndex: readingTypeIndex ?? 0,
          deckIndex: deckIndex ?? 0,
        ),
      );
    });
  }

  Future<void> skipBlessing() async {
    await audioPlayer.stop();
    isPlaying.value = false;

    // Navigate to shuffle screen with parameters
    AppNavigation.push(
      Get.context!,
      ShuffleScreen(
        questionText: questionText ?? '',
        readingTypeIndex: readingTypeIndex ?? 0,
        deckIndex: deckIndex ?? 0,
      ),
    );
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
