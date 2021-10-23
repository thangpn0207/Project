import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaittingApp extends StatefulWidget {
  const WaittingApp({Key? key}) : super(key: key);

  @override
  _WaittingAppState createState() => _WaittingAppState();
}

class _WaittingAppState extends State<WaittingApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/splash/background.png',
                  ),
                  fit: BoxFit.fill)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 70.h,
                ),
                Container(
                  height: 90.h,
                  child: Image.asset('assets/logo/logomain.png'),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                  child: Center(
                      child: Container(
                          child:
                              Image.asset('assets/images/splash/house.png'))),
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
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
