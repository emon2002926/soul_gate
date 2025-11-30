import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A reusable starry night background widget for the Soul-gate app.
/// Creates a gradient background with randomly positioned stars.
class StarryBackground extends StatelessWidget {
  /// Number of stars to generate (default: 100)
  final int starCount;

  /// Gradient colors from top to bottom
  /// Default: Deep navy to lighter blue gradient
  final List<Color>? gradientColors;

  /// Maximum star opacity (0.0 - 1.0, default: 0.8)
  final double maxStarOpacity;

  /// Maximum star size in pixels (default: 4.0)
  final double maxStarSize;

  /// Minimum star size in pixels (default: 1.0)
  final double minStarSize;

  /// Seed for random generation (use same seed for consistent star positions)
  /// If null, uses index-based seeding for consistent rebuild behavior
  final int? randomSeed;

  /// Child widget to display on top of the background
  final Widget? child;

  const StarryBackground({
    super.key,
    this.starCount = 100,
    this.gradientColors,
    this.maxStarOpacity = 0.8,
    this.maxStarSize = 4.0,
    this.minStarSize = 1.0,
    this.randomSeed,
    this.child,
  });

  /// Default Soul-gate gradient colors
  static const List<Color> defaultGradient = [
    Color(0xFF0A1628),
    Color(0xFF1a2744),
    Color(0xFF2d4a7c),
  ];

  /// Alternative darker gradient
  static const List<Color> darkGradient = [
    Color(0xFF050D1A),
    Color(0xFF0A1628),
    Color(0xFF1a2744),
  ];

  /// Purple mystical gradient
  static const List<Color> mysticalGradient = [
    Color(0xFF1A0A28),
    Color(0xFF2D1A44),
    Color(0xFF4A2D7C),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors ?? defaultGradient,
        ),
      ),
      child: Stack(
        children: [
          // Generate stars
          ..._generateStars(screenSize),
          // Child content
          if (child != null) child!,
        ],
      ),
    );
  }

  List<Widget> _generateStars(Size screenSize) {
    return List.generate(starCount, (index) {
      final random = math.Random(randomSeed != null ? randomSeed! + index : index);
      final starSize = random.nextDouble() * (maxStarSize - minStarSize) + minStarSize;

      return Positioned(
        left: random.nextDouble() * screenSize.width,
        top: random.nextDouble() * screenSize.height,
        child: _Star(
          size: starSize,
          opacity: random.nextDouble() * maxStarOpacity,
        ),
      );
    });
  }
}

/// Individual star widget
class _Star extends StatelessWidget {
  final double size;
  final double opacity;

  const _Star({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Animated version with twinkling stars
class AnimatedStarryBackground extends StatefulWidget {
  final int starCount;
  final List<Color>? gradientColors;
  final double maxStarOpacity;
  final double maxStarSize;
  final double minStarSize;
  final Widget? child;

  /// Duration of the twinkle animation cycle
  final Duration twinkleDuration;

  const AnimatedStarryBackground({
    super.key,
    this.starCount = 100,
    this.gradientColors,
    this.maxStarOpacity = 0.8,
    this.maxStarSize = 4.0,
    this.minStarSize = 1.0,
    this.child,
    this.twinkleDuration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedStarryBackground> createState() => _AnimatedStarryBackgroundState();
}

class _AnimatedStarryBackgroundState extends State<AnimatedStarryBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_StarData> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.twinkleDuration,
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateStarData();
  }

  void _generateStarData() {
    final screenSize = MediaQuery.of(context).size;
    _stars = List.generate(widget.starCount, (index) {
      final random = math.Random(index);
      return _StarData(
        x: random.nextDouble() * screenSize.width,
        y: random.nextDouble() * screenSize.height,
        size: random.nextDouble() * (widget.maxStarSize - widget.minStarSize) +
            widget.minStarSize,
        baseOpacity: random.nextDouble() * widget.maxStarOpacity,
        twinklePhase: random.nextDouble(), // Random phase offset for each star
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.gradientColors ?? StarryBackground.defaultGradient,
        ),
      ),
      child: Stack(
        children: [
          // Animated stars
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: _stars.map((star) {
                  // Calculate twinkle effect with phase offset
                  final twinkle = math.sin(
                    (_controller.value + star.twinklePhase) * math.pi * 2,
                  );
                  final opacity = (star.baseOpacity * (0.5 + twinkle * 0.5))
                      .clamp(0.1, widget.maxStarOpacity);

                  return Positioned(
                    left: star.x,
                    top: star.y,
                    child: Container(
                      width: star.size,
                      height: star.size,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          // Child content
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

/// Data class for animated star properties
class _StarData {
  final double x;
  final double y;
  final double size;
  final double baseOpacity;
  final double twinklePhase;

  _StarData({
    required this.x,
    required this.y,
    required this.size,
    required this.baseOpacity,
    required this.twinklePhase,
  });
}