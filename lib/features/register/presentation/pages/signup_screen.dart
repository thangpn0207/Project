import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/components/dialog.dart';
import 'package:app_web_project/core/components/signup_button.dart';
import 'package:app_web_project/core/components/text_field_nomal.dart';
import 'package:app_web_project/core/components/text_field_password.dart';
import 'package:app_web_project/core/widgets/dialog_update_success.dart';
import 'package:app_web_project/features/register/presentation/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _displayName = TextEditingController();
  late SignUpCubit signUpCubit;
  late AuthenticationCubit authenticationCubit;
  @override
  void initState() {
    // TODO: implement initState
    signUpCubit = inject<SignUpCubit>();
    authenticationCubit = inject<AuthenticationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (context) => signUpCubit,
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.isSuccess) {
            showDialogApp(
                context,
                DiaLogUpdateSuccess(
                    onPress: () {
                      authenticationCubit.authenticationCheck();
                    },
                    title: "You have successfully registered, thank you"));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Waiting...'),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                ],
              ),
              backgroundColor: Color(0xffffae88),
            ));
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/login/Background.png'))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    height: 100.h,
                    child:
                        Center(child: Image.asset('assets/logo/logomain.png')),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.sp),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w, bottom: 10.h),
                    child: Text(
                      'Enter your information to signup',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  TextFieldNormal(
                      labelText: "UserName",
                      textEditingController: _usernameController),
                  TextFieldPassword(
                      labelText: "Password",
                      textEditingController: _passwordController),
                  TextFieldPassword(
                      labelText: "Confirm Password",
                      textEditingController: _confirmPasswordController),
                  TextFieldNormal(
                      labelText: "Display Name",
                      textEditingController: _displayName),
                  Container(
                    margin: EdgeInsets.only(top: 25.h, left: 15.w, right: 15.w),
                    child: Row(
                      children: [
                        Text('Our ', style: TextStyle(fontSize: 16.sp)),
                        Container(
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize: 16.sp),
                            ),
                          ),
                        ),
                        Text(' and ', style: TextStyle(fontSize: 16.sp)),
                        Container(
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Terms of Service',
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SignUpButton(onPressed: () {
                    OnSignINButton(
                        _usernameController.text.trim(),
                        _passwordController.text.trim(),
                        _confirmPasswordController.text.trim(),
                        _displayName.text.trim());
                  }),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account ? ',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.black),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 16.sp),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void OnSignINButton(String userName, String password, String confirmPassword,
      String displayName) {
    signUpCubit.registerUser(userName, password, confirmPassword, displayName);
  }
}
