
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ButtonApp extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final Color? color;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final double? sizeText;
  final Color? textColor;

  ButtonApp(
      {this.title,
        this.width,
        this.onTap,
        this.color,
        this.textColor,
        this.height,
        this.sizeText,
        this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
        margin: margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: color ?? Colors.white),
        child: Center(
          child: Text(
            title??'',style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: sizeText??16.sp,
            color: textColor??Colors.black
          ),
          ),
        ),
      ),
    );
  }
}
