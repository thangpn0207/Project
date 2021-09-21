import 'package:flutter/material.dart';
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
        height: 48.h,
        width: 150.w,
        child: ButtonTheme(
            child: ElevatedButton.icon(
          onPressed: _onPressed,
          icon: Image.asset(
            'assets/icons/icon_gg.png',
            height: 25.h,
            width: 25.w,
          ),
          label: Text(
            "Google",
            style: TextStyle(color: Colors.black26, fontSize: 18.sp),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.white))),
          ),
        )),
      ),
    );
  }
}
