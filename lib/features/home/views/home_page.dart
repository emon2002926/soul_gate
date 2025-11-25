import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_gate/features/home/views/reveal_screen.dart';
import '../controllers/card_controller.dart';
import 'dart:math' as math;
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Card Reading Screen'),
      ),
    );
  }
}
