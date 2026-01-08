import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.data,
    this.fontSize = 16,
    this.textScaleFactor = 0.9,
    this.color,
    this.fontWeight = FontWeight.w400,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.height,
    this.decoration,
    this.decorationColor,
    this.translate = false,
    this.fontFamily,
    this.frosted = false,
    this.latterSpacing,
    this.useResponsiveFontSize = true, // New parameter
  });

  final String data;
  final double? fontSize;
  final double textScaleFactor;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final bool translate;
  final String? fontFamily;
  final bool frosted;
  final double? latterSpacing;
  final bool useResponsiveFontSize; // Toggle responsive sizing

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.displaySmall ?? const TextStyle();

    // Calculate responsive font size
    final responsiveFontSize = useResponsiveFontSize && fontSize != null
        ? _getResponsiveFontSize(context, fontSize!)
        : fontSize;

    final textWidget = Text(
      translate ? data.tr : data,
      maxLines: maxLines ?? 20,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      style: baseStyle.copyWith(
        height: height,
        fontSize: responsiveFontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        fontFamily: GoogleFonts.inter().fontFamily,
        decoration: decoration,
        decorationColor: decorationColor,
        letterSpacing: latterSpacing,
      ),
      textScaler: TextScaler.linear(textScaleFactor),
    );

    if (!frosted) return textWidget;

    return ClipRRect(
      borderRadius: BorderRadius.circular(_getResponsiveSize(context, 10)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _getResponsiveSize(context, 8),
            vertical: _getResponsiveSize(context, 4),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(_getResponsiveSize(context, 10)),
          ),
          child: textWidget,
        ),
      ),
    );
  }

  // Responsive font size calculation (based on 375px standard width)
  double _getResponsiveFontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }

  // Responsive size for padding/borders
  double _getResponsiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (size / 375);
  }
}