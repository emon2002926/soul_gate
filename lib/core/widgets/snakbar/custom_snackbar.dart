import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
      BuildContext context, {
        required String title,
        required String message,
        Color backgroundColor = Colors.red,
        Duration duration = const Duration(seconds: 3),
        bool isTop = true,
      }) {
    if (isTop) {
      _showTopSnackbar(context, title, message, backgroundColor, duration);
    } else {
      _showBottomSnackbar(context, title, message, backgroundColor, duration);
    }
  }

  static void error(
      BuildContext context, {
        required String title,
        required String message,
      }) {
    show(
      context,
      title: title,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  static void success(
      BuildContext context, {
        required String title,
        required String message,
      }) {
    show(
      context,
      title: title,
      message: message,
      backgroundColor: Colors.green,
    );
  }

  static void warning(
      BuildContext context, {
        required String title,
        required String message,
      }) {
    show(
      context,
      title: title,
      message: message,
      backgroundColor: Colors.orange,
    );
  }

  static void info(
      BuildContext context, {
        required String title,
        required String message,
      }) {
    show(
      context,
      title: title,
      message: message,
      backgroundColor: Colors.blue,
    );
  }

  static void _showTopSnackbar(
      BuildContext context,
      String title,
      String message,
      Color backgroundColor,
      Duration duration,
      ) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(duration, () => overlayEntry.remove());
  }

  static void _showBottomSnackbar(
      BuildContext context,
      String title,
      String message,
      Color backgroundColor,
      Duration duration,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }
}

// Usage Examples:
// CustomSnackbar.error(
//   context,
//   title: 'Error',
//   message: 'Failed to shuffle cards: $message',
// );
//
// CustomSnackbar.success(
//   context,
//   title: 'Success',
//   message: 'Cards shuffled successfully!',
// );
//
// CustomSnackbar.show(
//   context,
//   title: 'Custom',
//   message: 'This is a custom snackbar',
//   backgroundColor: Colors.purple,
//   isTop: false, // Shows at bottom
// );