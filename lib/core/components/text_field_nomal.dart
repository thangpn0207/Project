import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TextFieldNormal extends StatelessWidget {
  String labelText;
  TextEditingController textEditingController;
  TextFieldNormal({Key? key,required this.labelText,required this.textEditingController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height:65.h,
      margin: EdgeInsets.only(
          top: 10.h, left: 15.w, bottom: 20.h, right: 15.w),
      child: TextFormField(
        controller: textEditingController,
        style: TextStyle(fontSize: 16.sp,),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp
          )
        ),
      ),
    );
  }
}
