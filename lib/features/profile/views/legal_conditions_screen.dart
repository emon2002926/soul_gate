import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';

class LegalConditionsScreen extends StatelessWidget {
  const LegalConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Center(
                  child: Text(
                    'LEGAL CONDITIONS\nOF USE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Subtitle
                const Text(
                  'SOULGATE Tarot & Light — Strong Legal Conditions Of Use',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Section 1
                _buildSection(
                  '1. No Professional Advice Clause',
                  [
                    'SoulGate Provides Spiritual Guidance Only.',
                    'No Medical, Psychological, Legal, Financial, Or Professional Advice.',
                    'Users Must Consult Licensed Professionals For Serious Or Regulated Matters.',
                  ],
                ),

                // Section 2
                _buildSection(
                  '2. Limitation Of Liability',
                  [
                    'Interpretations Are Symbolic, Subjective, And Intuitive.',
                    'SoulGate Is Not Responsible For Decisions, Outcomes, Financial Loss, Or Emotional Impact.',
                    'Maximum Liability Is Limited To The Total Amount Paid By The User In The Previous 3 Months.',
                  ],
                ),

                // Section 3
                _buildSection(
                  '3. No Guarantee Clause',
                  [
                    'No Guarantee Of Accuracy, Predictions, Or Outcomes.',
                    'Readings Are Provided "As-Is" And "As Available."',
                    'No Assurance Of Uninterrupted Service.',
                  ],
                ),

                // Section 4
                _buildSection(
                  '4. Emergency & Crisis Disclaimer',
                  [
                    'Not For Emergencies Or Crisis Situations.',
                    'Not Suitable For Self-Harm, Suicidal Ideation, Abuse, Or Danger.',
                    'Users Must Contact Emergency Services Or Mental Health Professionals When Needed.',
                  ],
                ),

                // Section 5
                _buildSection(
                  '5. User Conduct Clause',
                  [
                    'Users Must Treat The AI Respectfully.',
                    'No Illegal, Harmful, Or Abusive Queries.',
                    'Users Must Avoid Highly Sensitive Personal Data.',
                    'Violation May Result In Account Suspension.',
                  ],
                ),

                // Section 6
                _buildSection(
                  '6. Data Privacy & Non-Retention Clause',
                  [
                    'SoulGate Does Not Store Long-Term Personal Data.',
                    'Session Content Is Only Processed To Generate The Reading.',
                    'No Selling Or Sharing Of Personal Data.',
                    'Compliance-Friendly With GDPR/CCPA Principles.',
                  ],
                ),

                // Section 7
                _buildSection(
                  '7. Intellectual Property Protection Clause',
                  [
                    'All Prompts, Tarot Structures, Card Texts, Designs, Images, Audio Scripts, And Session Flows Belong To SoulGate.',
                    'Users May Not Copy, Reproduce, Reverse-Engineer, Or Commercially Exploit The App Content.',
                  ],
                ),

                // Section 8
                _buildSection(
                  '8. Indemnification Clause',
                  [
                    'Users Agree To Indemnify SoulGate, Its Founders, Team, Contractors, And AI Providers.',
                    'Covers Damages, Claims, Losses, And Legal Fees Arising From Misuse Or Violations.',
                  ],
                ),

                // Section 9
                _buildSection(
                  '9. Right To Modify The Service',
                  [
                    'SoulGate May Update, Modify, Limit, Or Discontinue Features At Any Time.',
                    'No Prior Notice Required.',
                  ],
                ),

                // Section 10
                _buildSection(
                  '10. Binding Agreement Clause',
                  [
                    'Using The App = Full Acceptance Of These Conditions Of Use.',
                    'Users Waive Any Claim Inconsistent With These Terms',
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          // Section Points
          ...points.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}