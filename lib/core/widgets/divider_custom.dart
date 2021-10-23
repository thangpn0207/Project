import 'package:app_web_project/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerCustom extends StatelessWidget {
  const DividerCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtils.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                width: 120.w,
                child: Divider(
                  height: 5.h,
                  color: Colors.grey,
                )),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 11.w),
              child: Text(
                'Or',
                style: TextStyle(fontSize: 18.sp, color: Colors.black45),
              )),
          Align(
            alignment: Alignment.center,
            child: Container(
                width: 120.w,
                child: Divider(
                  height: 5.h,
                  color: Colors.grey,
                )),
          ),
        ],
      ),
    );
  }
}
