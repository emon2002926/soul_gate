import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_gate/core/util/app_navigation.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../controller/profile_controller.dart';
import 'change_password_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    AppStrings appStrings = AppStrings.instance;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: BuildAppBar(
        title: appStrings.profile,
        sideButtonIcon: Icons.account_circle_outlined,
        onBackButtonPrassed: (){
          Navigator.pop(context);
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertImage.instance.appBackground),
            fit: BoxFit.cover,
            // Optional: Add a dark overlay for better text readability
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Header Section
                _buildProfileHeader(controller),

                const SizedBox(height: 24),



                const SizedBox(height: 16),

                // Account Settings Section
                _buildMenuCard(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xFFE8A54B),
                      title: 'Edit Profile',
                      subtitle: 'Update your account details.',
                      onTap: controller.onEditProfile,
                    ),
                    const Divider(height: 1, indent: 56),
                    // _buildMenuItem(
                    //   icon: Icons.lock_outline_rounded,
                    //   iconColor: const Color(0xFFE8A54B),
                    //   title: 'Change Password',
                    //   subtitle: 'Change your account password securely.',
                    //   onTap: (){
                    //     AppNavigation.push(context, ChangePasswordPage());
                    //   },
                    // ),
                  ],
                ),

                const SizedBox(height: 16),

                // Support Section
                _buildMenuCard(
                  children: [
                    // _buildMenuItem(
                    //   icon: Icons.info_outline_rounded,
                    //   iconColor: const Color(0xFFE85C4A),
                    //   title: 'About us',
                    //   subtitle: 'Learn about our team and mission.',
                    //   onTap: controller.onAboutUs,
                    // ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: const Color(0xFFE85C4A),
                      title: 'Privacy Policy',
                      subtitle: 'Understand how we protect your data.',
                      onTap: controller.onPrivacyPolicy,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_sharp,
                      iconColor: const Color(0xFFE85C4A),
                      title: 'Legal Conditions of Use',
                      subtitle: 'Legal Conditions of Use.',
                      onTap: controller.onContactUs,
                    ),
                    _buildMenuItem(
                      icon: Icons.chat_bubble,
                      iconColor: const Color(0xFFE85C4A),
                      title: 'Share Your Thoughts',
                      subtitle: '',
                      onTap: controller.openSupportEmail,
                    ),

// Delete Account Section
                    _buildMenuCard(
                      children: [
                        _buildMenuItem(
                          icon: Icons.delete_outline_rounded,
                          iconColor: const Color(0xFFE85C4A),
                          title: 'Delete Account',
                          subtitle: 'Permanently delete your account.',
                          onTap:() {
                            controller.confirmDeleteAccount(context);
                          },
                        ),
                      ],
                    ),

                    _buildMenuItem(
                      icon: Icons.logout,
                      iconColor: const Color(0xFFE85C4A),
                      title: 'LogOut',
                      subtitle: '',
                      onTap: controller.logUot,
                    ),
                  ],
                ),

                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Column(
      children: [
        // Profile Image
        Obx(() => Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: controller.profileImageUrl.value.isNotEmpty
                ? Image.network(
              controller.profileImageUrl.value,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildDefaultAvatar(),
            )
                : _buildDefaultAvatar(),
          ),
        )),

        const SizedBox(height: 12),

        // User Name
        Obx(() => Text(
          controller.userName.value,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        )),

        const SizedBox(height: 6),

        // Premium Badge
        Obx(() => controller.isPremiumUser.value
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Premium User',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        )
            : const SizedBox.shrink()),

        const SizedBox(height: 4),

        // Email
        Obx(() => Text(
          controller.userEmail.value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white60,
          ),
        )),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E8E),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}