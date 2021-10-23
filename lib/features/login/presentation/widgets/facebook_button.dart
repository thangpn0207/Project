import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookLoginButton extends StatelessWidget {
  VoidCallback _onPressed;

  FacebookLoginButton({Key? key, required VoidCallback onPressed})
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
          icon: Icon(
            FontAwesomeIcons.facebook,
            color: Colors.white,
            size: 25.sp,
          ),
          label: Text(
            "Facebook",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.blue))),
          ),
        )),
      ),
    );
  }
}
