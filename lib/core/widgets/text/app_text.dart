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

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.displaySmall ?? const TextStyle();

    final textWidget = Text(
      translate ? data.tr : data,
      maxLines: maxLines??20,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      style: baseStyle.copyWith(
        height: height,
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        fontFamily:  GoogleFonts.inter().fontFamily,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
      textScaler: TextScaler.linear(textScaleFactor),
    );

    if (!frosted) return textWidget;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: textWidget,
        ),
      ),
    );
  }
}
