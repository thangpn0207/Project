import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../injection_container.dart';

class DialogLogOut extends StatelessWidget {

  DialogLogOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authenticationCubit = inject<AuthenticationCubit>();
    return Container(
      height: 150.h,
      width: 150.h,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              'Ara you sure?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          SizedBox(height: 5.h,),
          Container(
            child: Text(
              'Do you want logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          // Container(
          //   height: 100.h,
          //   child: Image(image: AssetImage('assets/icons/img.png')),
          // ),
          SizedBox(height: 20.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "No",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  )),
              TextButton(
                  onPressed: () {
                    authenticationCubit.logOut();
                  },
                  child: Text(
                    "Yes",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
