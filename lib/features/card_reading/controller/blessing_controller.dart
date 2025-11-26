// blessing_controller.dart
import 'package:get/get.dart';
import 'package:soul_gate/core/util/app_navigation.dart';

import '../views/shuffle_screen.dart';


class BlessingIntroController extends GetxController {
  final isLoading = false.obs;

  void onGoToBlessing() {
    AppNavigation.push(Get.context!,ShuffleScreen());
  }
}
