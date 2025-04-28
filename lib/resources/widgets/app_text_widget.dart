import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';

class AppTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final int? maxLines;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool softWrap;
  final Color? color;
  final double height;
  final Color? underLineColor;
  final TextDecoration textDecoration;
  final List<Shadow>? shadows;

  const AppTextWidget({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none,
    this.fontSize,
    this.softWrap = true,
    this.maxLines,
    this.underLineColor,
    this.overflow = TextOverflow.clip,
    this.shadows,
    this.padding,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        style: TextStyle(
          shadows: shadows,
          decoration: textDecoration,
          decorationColor: underLineColor ?? AppColors.black,
          fontWeight: fontWeight,
          height: height,
          fontSize: fontSize?.sp ?? 16.sp,
          color: color ?? AppColors.black,
        ),
      ),
    );
  }
}
