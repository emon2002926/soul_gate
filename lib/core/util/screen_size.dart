// lib/utils/size_config.dart
import 'package:flutter/material.dart';

  extension ScreenSize on BuildContext {
    // Screen dimensions
    double get screenWidth => MediaQuery.of(this).size.width;
    double get screenHeight => MediaQuery.of(this).size.height;

    // Responsive width (percentage of screen width)
    double widthPercentage(double percentage) => screenWidth * (percentage / 100);

    // Responsive height (percentage of screen height)
    double heightPercentage(double percentage) => screenHeight * (percentage / 100);

    // Responsive size (general purpose - based on screen width, 375px baseline)
    double responsiveSize(double size) => screenWidth * (size / 375);

    // Responsive font size (based on screen width)
    double responsiveFontSize(double size) => screenWidth * (size / 375);

    // Responsive spacing
    double get spacing4 => screenWidth * 0.01;
    double get spacing8 => screenWidth * 0.02;
    double get spacing12 => screenWidth * 0.03;
    double get spacing16 => screenWidth * 0.04;
    double get spacing24 => screenWidth * 0.06;
    double get spacing32 => screenWidth * 0.08;

    // Card dimensions (for tarot cards)
    double get cardWidth => screenWidth * 0.25; // ~25% of screen
    double get cardHeight => cardWidth * 1.5; // Maintain aspect ratio
  }