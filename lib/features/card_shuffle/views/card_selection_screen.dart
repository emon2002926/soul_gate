// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:math' as math;
//
// import '../../../core/constants/app_assert_image.dart';
// import '../../../core/widgets/buttons/app_button.dart';
//
// class CardShuffleScreen extends StatelessWidget {
//   final String question;
//
//   const CardShuffleScreen({
//     super.key,
//     required this.question,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CardShuffleController());
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssertImage.instance.appBackground),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Top Bar
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Back Button
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFD4AF37),
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: () => Get.back(),
//                         icon: const Icon(
//                           Icons.arrow_back_ios_new,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//
//                     // Choose Text
//                     const Text(
//                       'Choose',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                         letterSpacing: 1,
//                       ),
//                     ),
//
//                     // Profile Icon
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.person,
//                           color: Color(0xFF1E3A8A),
//                           size: 26,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Reading Type Buttons
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: Obx(() => Row(
//                   children: [
//                     Expanded(
//                       child: _ReadingTypeButton(
//                         text: '7 card Reading',
//                         isSelected: controller.selectedReadingType.value == ReadingType.sevenCard,
//                         onTap: () => controller.selectReadingType(ReadingType.sevenCard),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: _ReadingTypeButton(
//                         text: '3 card reading',
//                         isSelected: controller.selectedReadingType.value == ReadingType.threeCard,
//                         onTap: () => controller.selectReadingType(ReadingType.threeCard),
//                       ),
//                     ),
//                   ],
//                 )),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Card Display Area
//               Expanded(
//                 child: Stack(
//                   children: [
//                     // Circular card arrangement
//                     Center(
//                       child: SizedBox(
//                         width: 400,
//                         height: 400,
//                         child: Stack(
//                           children: List.generate(40, (index) {
//                             final angle = (index * 2 * math.pi) / 40;
//                             final radius = 160.0;
//                             final x = radius * math.cos(angle - math.pi / 2);
//                             final y = radius * math.sin(angle - math.pi / 2);
//
//                             return Positioned(
//                               left: 200 + x - 25,
//                               top: 200 + y - 40,
//                               child: Transform.rotate(
//                                 angle: angle,
//                                 child: Container(
//                                   width: 50,
//                                   height: 80,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     border: Border.all(color: Colors.black, width: 2),
//                                     gradient: const LinearGradient(
//                                       colors: [Color(0xFFD4AF37), Color(0xFF8B6914)],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                     ),
//
//                     // Hand cursor in center
//                     Center(
//                       child: Container(
//                         margin: const EdgeInsets.only(top: 50),
//                         child: const Icon(
//                           Icons.back_hand,
//                           color: Colors.white,
//                           size: 60,
//                         ),
//                       ),
//                     ),
//
//                     // Scattered cards at bottom
//                     Positioned(
//                       bottom: 80,
//                       left: 0,
//                       right: 0,
//                       child: SizedBox(
//                         height: 350,
//                         child: Stack(
//                           children: [
//                             // Row 1 - Bottom
//                             Positioned(
//                               bottom: 0,
//                               left: 50,
//                               child: _ScatteredCard(rotation: -0.05),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 140,
//                               child: _ScatteredCard(rotation: 0.03),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 230,
//                               child: _ScatteredCard(rotation: -0.02),
//                             ),
//
//                             // Row 2 - Middle
//                             Positioned(
//                               bottom: 110,
//                               left: 180,
//                               child: _ScatteredCard(rotation: 0.08),
//                             ),
//                             Positioned(
//                               bottom: 160,
//                               left: 90,
//                               child: _ScatteredCard(rotation: -0.1),
//                             ),
//
//                             // Row 3 - Top
//                             Positioned(
//                               bottom: 250,
//                               left: 320,
//                               child: _ScatteredCard(rotation: 0.15),
//                             ),
//                             Positioned(
//                               bottom: 200,
//                               left: 360,
//                               child: _ScatteredCard(rotation: -0.05),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Bottom Button
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: AppButton(
//                   buttonText: 'Continue to Reading',
//                   onPressed: () {
//                     controller.continueToReading();
//                   },
//                   fillColor: const Color(0xFFD4AF37).withOpacity(0.9),
//                   buttonHeight: 60,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   borderRadius: 30,
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Reading Type Button
// class _ReadingTypeButton extends StatelessWidget {
//   final String text;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _ReadingTypeButton({
//     required this.text,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? const Color(0xFFD4AF37)
//               : const Color(0xFFD4AF37).withOpacity(0.6),
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: isSelected
//               ? [
//             BoxShadow(
//               color: const Color(0xFFD4AF37).withOpacity(0.4),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ]
//               : null,
//         ),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Scattered Card Widget
// class _ScatteredCard extends StatelessWidget {
//   final double rotation;
//
//   const _ScatteredCard({
//     this.rotation = 0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Transform.rotate(
//       angle: rotation,
//       child: Container(
//         width: 75,
//         height: 115,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.black, width: 3),
//           image: DecorationImage(
//             image: AssetImage(AppAssertImage.instance.deck2), // Use your card back image
//             fit: BoxFit.cover,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(2, 4),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ==================== Controllers ====================
//
// enum ReadingType { sevenCard, threeCard }
//
// class CardShuffleController extends GetxController {
//   final selectedReadingType = ReadingType.sevenCard.obs;
//   final isShuffled = false.obs;
//   final selectedCards = <int>[].obs;
//
//   void selectReadingType(ReadingType type) {
//     selectedReadingType.value = type;
//     selectedCards.clear();
//   }
//
//   void shuffleCards() {
//     isShuffled.value = true;
//   }
//
//   void toggleCard(int index) {
//     if (selectedCards.contains(index)) {
//       selectedCards.remove(index);
//     } else {
//       selectedCards.add(index);
//     }
//   }
//
//   void continueToReading() {
//     // Navigate to reading screen
//     Get.toNamed('/card-reading', arguments: {
//       'selectedCards': selectedCards,
//       'readingType': selectedReadingType.value,
//     });
//   }
// }