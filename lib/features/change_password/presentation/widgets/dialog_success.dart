import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/components/buttom_custom.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DiaLogSuccess extends StatelessWidget {
  const DiaLogSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
      child: Column(
        children: [
          Container(
            child: Text('Changed password success, you need login again!',style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600
            ),textAlign: TextAlign.center,),
          ),
          SizedBox(height: 10.h,),
          ButtonCustom(title: 'Done',callback: (){
            inject<AuthenticationCubit>().logOut();
          },)
        ],
      ),
    );
  }
}
