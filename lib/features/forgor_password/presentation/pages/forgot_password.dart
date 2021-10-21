import 'package:app_web_project/core/components/dialog.dart';
import 'package:app_web_project/core/components/text_field_nomal.dart';
import 'package:app_web_project/core/widgets/dialog_update_success.dart';
import 'package:app_web_project/features/forgor_password/presentation/blocs/forgot_cubit/forgot_cubit.dart';
import 'package:app_web_project/features/forgor_password/presentation/widgets/forgot_button.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final ForgotCubit forgotCubit = inject<ForgotCubit>();
  ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotCubit>(
      create: (context) => forgotCubit,
      child: BlocListener<ForgotCubit, ForgotState>(
        listener: (context, state) {
          if (state is SendEmailSuccess) {
            showDialogApp(
                context,
                DiaLogUpdateSuccess(
                    onPress: () {
                      Navigator.pop(context);
                    },
                    title:
                        "An email has been sent to ${state.email} please verify"));
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      height: 100.h,
                      child: Center(
                          child: Image.asset('assets/logo/logomain.png')),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.h),
                      child: Text(
                        'Forgot password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      child: Text(
                        'Enter your email',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    TextFieldNormal(
                        labelText: "Email",
                        textEditingController: _emailController),
                    ForgotButton(onPressed: () {
                      forgotCubit.sendEmailReset(_emailController.text);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
