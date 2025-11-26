import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/widgets/text/app_text.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header with Profile
              _HomeHeader(controller: controller),

              const SizedBox(height: 24),

              // Daily Oracle Card
              _DailyOracleCard(onTap: controller.onOracleCardTap),

              const SizedBox(height: 32),

              // Ask the Oracle Section
              _AskOracleSection(controller: controller),

              const SizedBox(height: 32),

              // Difficult Moments Section
              _DifficultMomentsSection(controller: controller),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final HomeController controller;

  const _HomeHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onProfileTap,
      child: Row(
        children: [
          // Profile Avatar
          Obx(() => Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: controller.profileImageUrl.value.isNotEmpty
                  ? Image.network(
                controller.profileImageUrl.value,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
              )
                  : _buildDefaultAvatar(),
            ),
          )),

          const SizedBox(width: 12),

          // Greeting Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                'Hi, ${controller.userName.value}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              )),
              const SizedBox(height: 2),
              Text(
                'Tarot • Light • Guidance',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 28, color: Colors.grey[600]),
    );
  }
}

class _DailyOracleCard extends StatelessWidget {
  final VoidCallback onTap;

  const _DailyOracleCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E).withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              data: 'Your Daily Oracle Awaits',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
            ),
            const SizedBox(height: 8),
            AppText(
              data: 'May light surround your path today, and may clarity rise gently within you.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                height: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}

class _AskOracleSection extends StatelessWidget {
  final HomeController controller;

  const _AskOracleSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        AppText(
          data: 'Ask the Oracle',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
        ),

        const SizedBox(height: 16),

        // Oracle Prompts
        ...controller.oraclePrompts.map((prompt) => _OraclePromptItem(
          prompt: prompt,
          onTap: () => controller.onPromptTap(prompt),
        )),

        const SizedBox(height: 12),

        // Question Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller.questionController,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'What is in your mind ?',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white54,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              suffixIcon: GestureDetector(
                onTap: controller.onAskQuestion,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFBC9041),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OraclePromptItem extends StatelessWidget {
  final String prompt;
  final VoidCallback onTap;

  const _OraclePromptItem({
    required this.prompt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                prompt,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Decorative stars/sparkles
            AppText(
              data: '✦ ✦',
                fontSize: 12,
                color: const Color(0xFFBC9041).withOpacity(0.8),
                latterSpacing: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultMomentsSection extends StatelessWidget {
  final HomeController controller;

  const _DifficultMomentsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        AppText(
          data: 'In a Difficult Moment?',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,

        ),

        const SizedBox(height: 16),

        // Moment Cards Row
        Row(
          children: controller.difficultMoments.map((moment) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: controller.difficultMoments.last != moment ? 12 : 0,
                ),
                child: _DifficultMomentCard(
                  emoji: moment['emoji']!,
                  title: moment['title']!,
                  subtitle: moment['subtitle']!,
                  onTap: () => controller.onDifficultMomentTap(
                    '${moment['title']} ${moment['subtitle']}',
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DifficultMomentCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DifficultMomentCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            AppText(
              data: title,
              textAlign: TextAlign.center,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D2D2D),

            ),
            AppText(
              data: subtitle,
              textAlign: TextAlign.center,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D2D2D),
            ),
          ],
        ),
      ),
    );
  }
}