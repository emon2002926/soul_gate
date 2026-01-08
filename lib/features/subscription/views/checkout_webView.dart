import 'package:flutter/material.dart';
import 'package:soul_gate/core/util/app_navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

// Import your navigation utilities
// import 'package:your_app/utils/app_navigation.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../core/onboarding/splash/views/onboarding_screen.dart';

// TODO: Import your actual OnboardingScreen
// import 'package:soul_gate/screens/onboarding_screen.dart';

class CheckoutWebView extends StatefulWidget {
  final String url;

  const CheckoutWebView({
    super.key,
    required this.url,
  });

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  late final WebViewController _controller;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print('=== CheckoutWebView initialized ===');
    print('URL to load: ${widget.url}');
    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      print('Initializing WebViewController...');

      // Platform-specific parameters with hardware acceleration disabled for emulator
      late final PlatformWebViewControllerCreationParams params;

      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        // iOS
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        // Android - disable hardware acceleration to prevent OpenGL crashes
        params = PlatformWebViewControllerCreationParams();
      }

      _controller = WebViewController.fromPlatformCreationParams(params);

      // Android-specific settings
      if (_controller.platform is AndroidWebViewController) {
        print('Configuring Android WebView settings...');
        AndroidWebViewController.enableDebugging(true);
        (_controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }

      _controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              print('✅ onPageStarted: $url');
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
              _checkUrlForCompletion(url);
            },
            onPageFinished: (String url) {
              print('✅ onPageFinished: $url');
              setState(() {
                isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              print('❌ WebResourceError:');
              print('  - Description: ${error.description}');
              print('  - ErrorCode: ${error.errorCode}');
              print('  - ErrorType: ${error.errorType}');

              setState(() {
                isLoading = false;
                errorMessage = 'Failed to load payment page.\n\n'
                    'This might be due to emulator limitations.\n'
                    'Please try on a real device.';
              });
            },
            onNavigationRequest: (NavigationRequest request) {
              print('🔄 Navigation request: ${request.url}');

              if (_isSuccessUrl(request.url)) {
                print('✅ Success URL detected!');
                _handlePaymentSuccess();
                return NavigationDecision.navigate;
              } else if (_isCancelUrl(request.url)) {
                print('⚠️ Cancel URL detected!');
                _handlePaymentCancel();
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
            onHttpError: (HttpResponseError error) {
              print('❌ HTTP Error: ${error.response?.statusCode}');
            },
          ),
        );

      print('Loading URL: ${widget.url}');
      _controller.loadRequest(Uri.parse(widget.url));
      print('WebViewController initialized successfully');
    } catch (e) {
      print('❌ Error initializing WebView: $e');
      setState(() {
        errorMessage = 'Failed to initialize payment page.\n\n'
            'If using emulator, please try on a real device.\n\n'
            'Error: $e';
        isLoading = false;
      });
    }
  }

  bool _isSuccessUrl(String url) {
    // Updated to match your backend success endpoint
    return url.contains('/subscriptions/stripe/success') && url.contains('session_id=');
  }

  bool _isCancelUrl(String url) {
    return url.contains('/cancel') ||
        url.contains('payment_status=cancel') ||
        url.contains('checkout/cancel');
  }

  void _checkUrlForCompletion(String url) {
    if (_isSuccessUrl(url)) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _handlePaymentSuccess();
        }
      });
    } else if (_isCancelUrl(url)) {
      _handlePaymentCancel();
    }
  }

  void _handlePaymentSuccess() {
    print('🎉 Payment successful! Navigating to onboarding...');
    Get.back(); // Close WebView

    // Navigate to onboarding page
    AppNavigation.pushAndClear(context, OnboardingScreen());
    // Get.offAll(
    //       () =>  OnboardingScreen(), // TODO: Replace with your actual OnboardingScreen import
    //   transition: Transition.fadeIn,
    //   duration: const Duration(milliseconds: 300),
    // );

    // Show success message
    Get.snackbar(
      'Payment Successful!',
      'Your subscription is now active',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF8B7BA8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _handlePaymentCancel() {
    print('⚠️ Payment cancelled by user');
    Navigator.pop(context); // Close WebView

    Get.snackbar(
      'Payment Cancelled',
      'You can try again anytime',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFD4A574),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B7BA8),
        elevation: 0,
        title: const Text(
          'Complete Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _showCancelDialog,
        ),
        actions: [
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFF8B7BA8),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              errorMessage = null;
                              _initializeWebView();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBC9041),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            Get.snackbar(
                              'Tip',
                              'WebView works best on real devices',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: const Color(0xFF8B7BA8),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 3),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: _controller),

          if (isLoading && errorMessage == null)
            Container(
              color: const Color(0xFFF5F5DC),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFF8B7BA8)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading payment page...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFFF5F5DC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Cancel Payment?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A4A),
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel the payment process?',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4A4A4A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Continue',
              style: TextStyle(
                color: Color(0xFF8B7BA8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _handlePaymentCancel();
            },
            child: const Text(
              'Cancel Payment',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder - replace with your actual OnboardingScreen
