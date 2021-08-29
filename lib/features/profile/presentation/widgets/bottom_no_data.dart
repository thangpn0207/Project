import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BottomProfileNoData extends StatelessWidget {
  const BottomProfileNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 10,
      child: SingleChildScrollView(
        child: Container(
          color: Color(0xfffae7e9),
          child: Container(
            padding: EdgeInsets.only(top: 30.h, bottom: 100.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
              color: Color(0xfffcf3f4),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/infor/1.jpg',
                      width: 150.w,
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/infor/2.jpg',
                          width: 150.w,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Image.asset(
                          'assets/images/infor/3.jpg',
                          width: 150.w,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
