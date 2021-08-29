import 'package:app_web_project/core/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchUserTitle extends StatelessWidget {
  final UserModel userModel;

  SearchUserTitle({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Container(
            height: 45.h,
            width: 45.w,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userModel.imgUrl ?? 'null'),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.displayName ?? 'null',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff6a515e),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                userModel.email ?? 'null',
                style: TextStyle(fontSize: 18.sp, color: Color(0xff6a515e)),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ))
        ],
      ),
    );
  }
}
