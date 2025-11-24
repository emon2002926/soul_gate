import 'package:flutter/material.dart';

class AppNavigation {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Clear previous pages and navigate forward
  static void pushAndClear(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
          (Route<dynamic> route) => false,
    );
  }

}
