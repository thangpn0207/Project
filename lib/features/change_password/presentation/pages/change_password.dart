import 'package:app_web_project/core/components/buttom_custom.dart';
import 'package:app_web_project/core/components/dialog.dart';
import 'package:app_web_project/core/components/text_field_custom.dart';
import 'package:app_web_project/features/change_password/presentation/blocs/change_password_cubit.dart';
import 'package:app_web_project/features/change_password/presentation/widgets/dialog_success.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangedPassword extends StatefulWidget {
  const ChangedPassword({Key? key}) : super(key: key);
  @override
  _ChangedPasswordState createState() => _ChangedPasswordState();
}

class _ChangedPasswordState extends State<ChangedPassword> {
  TextEditingController _password= TextEditingController();
  TextEditingController _newPassword= TextEditingController();
  TextEditingController _confirmPassword= TextEditingController();


  late ChangePasswordCubit changePasswordCubit;

  @override
  void initState() {
    // TODO: implement initState
    changePasswordCubit = inject<ChangePasswordCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordCubit>(
      create: (context) => changePasswordCubit,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !kIsWeb,
            iconTheme: IconThemeData(color: Colors.black38),
            centerTitle: true,
            title: Text(
              'Change Password',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color(0xfffcf3f4),
          ),
          body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if(state is ChangePasswordSuccess){
                showDialogApp(context, DiaLogSuccess());
              }
              },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/images/login/Background.png'))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Container(
                        child: Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFieldCustom(
                        controller: _password,
                        hintText: 'Password',
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        child: Text(
                          'New password',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFieldCustom(
                        controller: _newPassword,
                        hintText: ' New Password',
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        child: Text(
                          'Confirm new password',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFieldCustom(
                        controller: _confirmPassword,
                        hintText: 'Confirm Password',
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      ButtonCustom(title: 'Save changed',callback: (){
                        changePasswordCubit.changePassword(_password.text, _newPassword.text, _confirmPassword.text);
                        _password.text='';
                        _newPassword.text='';
                        _confirmPassword.text='';
                      },)
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
