import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpButton extends StatelessWidget {
  VoidCallback _onPressed;

  SignUpButton({Key? key, required VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        width: 320.w,
        height: 48.h,
        child: ButtonTheme(
            child: ElevatedButton(
          onPressed: _onPressed,
          child: Text(
            "SignUp",
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
