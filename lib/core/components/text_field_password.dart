import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TextFieldPassword extends StatefulWidget {
  String labelText;
  TextEditingController textEditingController;
  TextFieldPassword({Key? key,required this.labelText,required this.textEditingController}) : super(key: key);
  @override
  _TextFieldPasswordState createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return   Container(
      height: 65.h,
      margin: EdgeInsets.only(
          top: 10.h, left: 15.w, bottom: 20.h, right: 15.w),
      child: TextFormField(
        controller: widget.textEditingController,
        style: TextStyle(fontSize: 16.sp),
        obscureText: _passwordVisible,
        decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(),
              child: IconButton(
                icon: Icon(_passwordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            )),
      ),
    );
  }
}
