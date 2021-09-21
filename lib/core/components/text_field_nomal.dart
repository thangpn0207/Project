import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldNormal extends StatelessWidget {
  String labelText;
  TextEditingController textEditingController;
  TextFieldNormal(
      {Key? key, required this.labelText, required this.textEditingController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      margin: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
      child: TextFormField(
        controller: textEditingController,
        style: TextStyle(
          fontSize: 16.sp,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
            ),
            labelText: labelText,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.grey)),
      ),
    );
  }
}
