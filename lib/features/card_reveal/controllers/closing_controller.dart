import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/util/app_navigation.dart';
import '../../subscription/views/subscription_page.dart';


class ClosingController extends GetxController {

  // ── Navigation ────────────────────────────────────────────
  void goToSubscription() {
    AppNavigation.push(Get.context!, const SubscriptionPage());
  }

  // ── Email Support ─────────────────────────────────────────
  Future<void> openSupportEmail() async {
    final String subject = Uri.encodeComponent('Share My Thoughts About the App');
    final String body = Uri.encodeComponent(
      'Hello,\n\n'
          'I would like to share my thoughts about the app:\n\n'
          '• What I love:\n\n'
          '• What could be improved:\n\n'
          '• Any other feedback:\n\n'
          'Thank you for creating this experience.\n\n'
          'Warm regards,',
    );

    final Uri emailUri = Uri.parse(
      'mailto:support23@gmail.com?subject=$subject',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showEmailError();
      }
    } catch (e) {
      _showEmailError();
    }
  }

  void _showEmailError() {
    Get.snackbar(
      'Unable to Open Mail',
      'Please email us directly at support23@gmail.com',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }
}