import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dialog widgets for Reveal Screen
class RevealDialogs {
  /// Show retry dialog with automatic retry option
  static void showRetryDialog({
    required String message,
    required int currentAttempt,
    required int maxRetries,
    required VoidCallback onRetry,
    required VoidCallback onGoBack,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: _RetryDialogContent(
          message: message,
          currentAttempt: currentAttempt,
          maxRetries: maxRetries,
          onRetry: onRetry,
          onGoBack: onGoBack,
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show styled error dialog (final error after retries)
  static void showErrorDialog({
    required String message,
    required VoidCallback onTryAgain,
    required VoidCallback onGoBack,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: _ErrorDialogContent(
          message: message,
          onTryAgain: onTryAgain,
          onGoBack: onGoBack,
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show final interpretation dialog
  static void showFinalInterpretation({
    required String interpretation,
    required VoidCallback onListen,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: _FinalInterpretationContent(
          interpretation: interpretation,
          onListen: onListen,
        ),
      ),
    );
  }
}


/// Retry Dialog Content Widget
class _RetryDialogContent extends StatelessWidget {
  final String message;
  final int currentAttempt;
  final int maxRetries;
  final VoidCallback onRetry;
  final VoidCallback onGoBack;

  const _RetryDialogContent({
    required this.message,
    required this.currentAttempt,
    required this.maxRetries,
    required this.onRetry,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A574).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFD4A574),
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Connection Issue',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C2A21),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5C4A42),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Attempt $currentAttempt of $maxRetries',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8B7355),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A574),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onGoBack,
              child: const Text(
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
    );
  }
}

/// Error Dialog Content Widget
class _ErrorDialogContent extends StatelessWidget {
  final String message;
  final VoidCallback onTryAgain;
  final VoidCallback onGoBack;

  const _ErrorDialogContent({
    required this.message,
    required this.onTryAgain,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A574).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFD4A574),
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Reading Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C2A21),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5C4A42),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTryAgain,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A574),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onGoBack,
              child: const Text(
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
    );
  }
}

/// Final Interpretation Dialog Content Widget
class _FinalInterpretationContent extends StatelessWidget {
  final String interpretation;
  final VoidCallback onListen;

  const _FinalInterpretationContent({
    required this.interpretation,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Your Reading',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C2A21),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Text(
                interpretation,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5C4A42),
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onListen,
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  label: const Text(
                    'Listen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A574),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B7355),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}