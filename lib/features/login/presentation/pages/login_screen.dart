import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/components/google_button.dart';
import 'package:app_web_project/core/components/logging_button.dart';
import 'package:app_web_project/core/components/text_field_nomal.dart';
import 'package:app_web_project/core/components/text_field_password.dart';
import 'package:app_web_project/core/navigator/route_names.dart';
import 'package:app_web_project/features/login/presentation/blocs/login_cubit/login_cubit.dart';
import 'package:app_web_project/features/register/presentation/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../../../routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginCubit loginCubit;
  late AuthenticationCubit authenticationCubit;

  @override
  void initState() {
    // TODO: implement initState
    authenticationCubit = inject<AuthenticationCubit>();
    loginCubit = inject<LoginCubit>();
    super.initState();
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => loginCubit,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: BlocListener<LoginCubit, LoginState>(
            bloc: loginCubit,
            listener: (context, state) {
              if (state.isSuccess) {
                authenticationCubit.authenticationCheck();
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
            child: BlocBuilder<LoginCubit, LoginState>(
              bloc: loginCubit,
              builder: (context, state) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/images/login/Background.png'))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80.h,
                        ),
                        Container(
                          height: 100.h,
                          child: Center(
                              child: Image.asset('assets/logo/logomain.png')),
                        ),
                        SizedBox(
                          height: 70.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 15.h),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                               left: 15.w, bottom: 30.h),
                          child: Text(
                            'Enter your email and password',
                            style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFieldNormal(
                            labelText: 'Email',
                            textEditingController: _emailController),
                        TextFieldPassword(
                            labelText: 'Password',
                            textEditingController: _passwordController),
                        SizedBox(height: 30.h,),
                        LoggingButton(onPressed: _onFormSubmitted),
                        GoogleLoginButton(onPressed: _onGooglePressed),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\' have an account ? ',
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Routes.instance.navigateTo(RouteNames.signUp);
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(color: Colors.redAccent),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    loginCubit.loginWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    _emailController.text = '';
    _passwordController.text = '';
  }

  void _onGooglePressed() {
    loginCubit.loginWithGG();
  }


}
