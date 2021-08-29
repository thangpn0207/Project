import 'package:app_web_project/core/components/buttom_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiaLogUpdateSuccess extends StatelessWidget {
  String title;
  VoidCallback onPress;

  DiaLogUpdateSuccess({Key? key, required this.onPress, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: 300.h,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          Container(
            height: 100.h,
            child: Image(image: AssetImage('assets/icons/img.png')),
          ),
          ButtonCustom(
            title: "Success",
            callback: onPress,
          )
        ],
      ),
    );
  }
}
