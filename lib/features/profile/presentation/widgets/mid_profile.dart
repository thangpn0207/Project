import 'package:app_web_project/core/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MidProfile extends StatelessWidget {
  UserModel userModel;
   MidProfile({Key? key,required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 90.h,
        color: Color(0xfffcf3f4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          decoration: BoxDecoration(
              color: Color(0xfffae7e9),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Photos',
                    style: TextStyle(
                      color: Color(0xffc7abba),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    userModel.photos.toString(),
                    style: TextStyle(
                      color: Color(0xff6a515e),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Color(0xffc7abba),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    userModel.phone??'',
                    style: TextStyle(
                      color: Color(0xff6a515e),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Age',
                    style: TextStyle(
                      color: Color(0xffc7abba),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    userModel.age??'',
                    style: TextStyle(
                      color: Color(0xff6a515e),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
