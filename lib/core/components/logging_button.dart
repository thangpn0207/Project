import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoggingButton extends StatelessWidget {
  VoidCallback _onPressed;

  LoggingButton({Key? key, required VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        height: 48.h,
        width: 320.w,
        child: ButtonTheme(
            child: ElevatedButton.icon(
          onPressed: _onPressed,
          icon: Icon(
            Icons.mail,
            color: Colors.white,
            size: 25.sp,
          ),
          label: Text(
            "Login with Email",
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
