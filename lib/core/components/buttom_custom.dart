import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ButtonCustom extends StatelessWidget {
  VoidCallback? callback;
  String title;
  ButtonCustom({Key? key,this.callback,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:
        EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 5.h),
        width: 364.w,
        height: 48.h,
        child: ButtonTheme(
            child: ElevatedButton(
              onPressed: callback,
              child: Text(
               title,
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.redAccent))),
              ),
            )),
      ),
    );
  }
}
