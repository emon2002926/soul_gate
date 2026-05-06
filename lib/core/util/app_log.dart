import 'dart:convert';

import 'package:flutter/material.dart';

import '../widgets/snakbar/custom_snackbar.dart';


class AppLog {
  AppLog._();

  static void request(String endpoint, {dynamic body, String method = 'POST'}) {
    assert(() {
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 🚀 $method → $endpoint');
      if (body != null) debugPrint('│ 📦 Body: ${jsonEncode(body)}');
      debugPrint('└─────────────────────────────────────────');
      return true;
    }());
  }

  static void response(String endpoint, dynamic response) {
    assert(() {
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ ✅ RESPONSE ← $endpoint');
      debugPrint('│ 📬 ${jsonEncode(response)}');
      debugPrint('└─────────────────────────────────────────');
      return true;
    }());
  }

  static void error(String endpoint, dynamic error, {int? statusCode, bool showSnackBar = true}) {
    // Extract a clean message from the error body
    String? snackMessage;

    if (error is String) {
      try {
        final decoded = jsonDecode(error);
        snackMessage = decoded['message'] as String?;
      } catch (_) {
        snackMessage = error; // plain string fallback
      }
    } else if (error is Map) {
      snackMessage = error['message'] as String?;
    }

    snackMessage ??= 'Something went wrong. Please try again.';

    // Show snackbar automatically
    if (showSnackBar) {
      CustomSnackBar.error(snackMessage);
    }

    assert(() {
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ ❌ ERROR ← $endpoint');
      if (statusCode != null) debugPrint('│ 🔴 Status: $statusCode');
      debugPrint('│ 💬 $error');
      debugPrint('└─────────────────────────────────────────');
      return true;
    }());
  }

  static void info(String message) {
    assert(() {
      debugPrint('ℹ️  $message');
      return true;
    }());
  }
}