import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BottomProfileNoData extends StatelessWidget {
  const BottomProfileNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xfffae7e9),
        child: Container(
          padding: EdgeInsets.only(top: 30.h, bottom: 100.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
            color: Color(0xfffcf3f4),
          ),

        ),
      ),
    );
  }
}
