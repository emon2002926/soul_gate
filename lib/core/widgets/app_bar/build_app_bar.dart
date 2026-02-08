import 'package:flutter/material.dart';
import 'dart:ui';



class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? titleColor;
  final Color? iconColor;
  final bool enableFrostEffect;
  final bool showSideButton;
  final VoidCallback? onSideButtonPressed;
  final IconData sideButtonIcon;
  final bool showBackButton;
  final Color? backgroundColor;  // Added backgroundColor parameter
  final double? titleSize;
  final FontWeight? fontWeight;
  final VoidCallback? onBackButtonPrassed ;

  const BuildAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.iconColor,
    this.enableFrostEffect = false,
    this.showSideButton = false,
    this.onSideButtonPressed,
    this.sideButtonIcon = Icons.more_vert,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleSize,
    this.fontWeight,
    this.onBackButtonPrassed,
  });

  @override
  Widget build(BuildContext context) {
    final appBarContent = AppBar(
      backgroundColor: backgroundColor ?? (enableFrostEffect
          ? Colors.white.withOpacity(0.15)
          : Colors.transparent),  // Default color if backgroundColor is null
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
        icon: Icon(Icons.arrow_back_ios, color: iconColor ?? Colors.white),
        onPressed:  onBackButtonPrassed,
      )
          : null,
      title: Text(
        title ?? "",
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: titleSize??24,
          fontWeight:fontWeight?? FontWeight.normal,
        ),
      ),
      centerTitle: true,
      actions: showSideButton
          ? [
        IconButton(
          icon: Icon(sideButtonIcon, color: iconColor ?? Colors.white),
          onPressed: onSideButtonPressed,
          iconSize: 24,
        )
      ]
          : null,
    );

    return enableFrostEffect
        ? ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: backgroundColor?.withOpacity(0.2) ?? Colors.transparent,  // Apply background color with opacity
          child: appBarContent,
        ),
      ),
    )
        : appBarContent;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
