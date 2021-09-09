import 'dart:async';
import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/navigator/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen() : super();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthenticationCubit authenticationCubit;

  @override
  void initState() {
    // TODO: implement initState
    authenticationCubit = inject<AuthenticationCubit>();
    Timer(Duration(seconds: 2), () {
      Routes.instance.navigateTo(RouteNames.login);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
      create: (context) => authenticationCubit,
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context,state){
          if (state is AuthenticationStateSuccess) {
            Routes.instance.navigateTo(RouteNames.home);
          } else if (state is AuthenticationStateFail) {
            Routes.instance.navigateTo(RouteNames.login);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                  'assets/images/splash/background.png',
                ))),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 90.h,
                      ),
                      Expanded(
                        child: Center(
                            child: Container(
                                child:
                                    Image.asset('assets/images/splash/house.png'))),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Expanded(
                        child: Container(
                            child: Text(
                          'Welcome To Home',
                          style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Expanded(
                        child: Container(
                          height: 60.h,
                          child: Image.asset('assets/logo/logomain.png'),
                        ),
                      ),
                      CircularProgressIndicator(
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
