import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleLoginButton extends StatelessWidget {
  VoidCallback _onPressed;

  GoogleLoginButton({Key? key, required VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        width: 364.w,
        height: 48.h,
        child: ButtonTheme(
            child: ElevatedButton.icon(
          onPressed: _onPressed,
          icon: Icon(
            FontAwesomeIcons.google,
            color: Colors.white,
            size: 18.sp,
          ),
          label: Text(
            "SignIn with Google",
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
