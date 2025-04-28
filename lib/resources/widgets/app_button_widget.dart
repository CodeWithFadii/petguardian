import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_colors.dart';
import '../utils.dart';
import 'app_text_widget.dart';

class AppButtonWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? color;
  final FontWeight? fontWeight;
  final bool showShadow;
  final VoidCallback? onTap;
  final double? fontSize;
  final Widget? trailing;
  final Widget? leading;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  const AppButtonWidget({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
    this.padding,
    this.margin,
    this.width,
    this.borderRadius,
    this.color,
    this.fontWeight,
    this.trailing,
    this.leading,
    this.fontSize,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          boxShadow:
              showShadow
                  ? [
                    BoxShadow(
                      color: Utils().withOpacity(color: Colors.grey, opacity: 0.4),
                      spreadRadius: -2,
                      blurRadius: 19.3,
                      offset: Offset(0, 7),
                    ),
                  ]
                  : [],
          color: color ?? AppColors.secondary,
          borderRadius: borderRadius ?? BorderRadius.circular(24),
        ),
        padding: padding ?? EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.5.w),
        margin: margin ?? EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null)
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: SizedBox(height: 3.h, width: 6.w, child: leading!),
              ),
            AppTextWidget(
              text: text,
              color: textColor ?? AppColors.white,
              fontSize: fontSize ?? 16.5,
              fontWeight: fontWeight ?? FontWeight.w700,
            ),
            if (trailing != null)
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: SizedBox(height: 3.h, width: 6.w, child: trailing!),
              ),
          ],
        ),
      ),
    );
  }
}
