import 'package:flutter/material.dart';
import '../../constants/app_assert_image.dart';
import '../text/app_text.dart';
class BuildSliverAppBar extends StatelessWidget {
  final bool showBackButton;
  final bool showProfileIcon;
  final String? title;
  final String? profileImage;
  final VoidCallback? onProfileTap;

  const BuildSliverAppBar({
    super.key,
    this.showBackButton = false,
    this.showProfileIcon = true,
    this.title,
    this.profileImage,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      snap: true,
      pinned: false,
      elevation: 0,
      leading: showBackButton
          ? Padding(
        padding: const EdgeInsets.only(top: 20),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      )
          : null,
      title: Padding(
        padding: const EdgeInsets.only(top: 28),
        child: AppText(
          data: "$title" ?? "Hello astro8!",
          color: Colors.white,
          fontSize: 28,
        ),
      ),
      actions: showProfileIcon
          ? [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, right: 16),
          child: GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: profileImage != null && profileImage!.isNotEmpty
                  ? NetworkImage(profileImage!) as ImageProvider
                  : AssetImage(AppAssertImage.instance.profile),
              onBackgroundImageError: profileImage != null && profileImage!.isNotEmpty
                  ? (exception, stackTrace) {
                // Error will fall back to showing backgroundColor
              }
                  : null,
              child: profileImage != null && profileImage!.isNotEmpty
                  ? null
                  : null, // Image will be shown via backgroundImage
            ),
          ),
        ),
      ]
          : null,
    );
  }
}