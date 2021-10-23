import 'package:app_web_project/core/components/buttom_custom.dart';
import 'package:app_web_project/core/components/dialog.dart';
import 'package:app_web_project/core/components/text_field_custom.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/navigator/route_names.dart';
import 'package:app_web_project/core/widgets/dialog_update_success.dart';
import 'package:app_web_project/features/routes.dart';
import 'package:app_web_project/features/update_info/presentation/blocs/update_info_cubit/update_info_cubit.dart';
import 'package:app_web_project/features/update_info/presentation/widgets/avatar.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateInfo extends StatefulWidget {
  UserModel userModel;

  UpdateInfo({Key? key, required this.userModel}) : super(key: key);

  @override
  _UpdateInfoState createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  TextEditingController _displayName = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _age = TextEditingController();
  late UpdateInfoCubit updateInfoCubit;

  @override
  void initState() {
    // TODO: implement initState
    updateInfoCubit = inject<UpdateInfoCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeBoxTop = SizedBox(
      height: 15.h,
    );
    final sizeBoxBottom = SizedBox(
      height: 10.h,
    );

    return BlocProvider<UpdateInfoCubit>(
      create: (context) => updateInfoCubit,
      child: BlocListener<UpdateInfoCubit, UpdateInfoState>(
        listener: (context, state) async{
          // TODO: implement listener
          if (state is UpdateInfoSuccess) {
           await showDialogApp(
                context,
                DiaLogUpdateSuccess(
                    onPress: (){
                      Routes.instance.navigateTo(RouteNames.home);
                    },
                    title: 'You have successfully updated your information'));
          }
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: !kIsWeb,
              iconTheme: IconThemeData(color: Colors.black38),
              centerTitle: true,
              title: Text(
                'Update Infomation',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Color(0xfffcf3f4),
            ),
            body: BlocBuilder<UpdateInfoCubit, UpdateInfoState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 40.h,
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
                          height: 30.h,
                        ),
                        Center(
                            child: AvatarSelect(
                          imageUrl: widget.userModel.imgUrl ?? '',
                        )),
                        Center(
                          child: Text(
                            'Edit avatar',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        ),
                        sizeBoxTop,
                        Container(
                          child: Text(
                            'Display name',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        ),
                        sizeBoxBottom,
                        TextFieldCustom(
                          controller: _displayName,
                          hintText: widget.userModel.displayName,
                        ),
                        sizeBoxTop,
                        Container(
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        ),
                        sizeBoxBottom,
                        TextFieldCustom(
                          isEdit: false,
                          hintText: widget.userModel.email,
                        ),
                        sizeBoxTop,
                        Container(
                          child: Text(
                            'Location',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        ),
                        sizeBoxBottom,
                        TextFieldCustom(
                          controller: _location,
                          hintText: widget.userModel.location,
                        ),
                        sizeBoxTop,
                        Container(
                          child: Text(
                            'Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        ),
                        sizeBoxBottom,
                        TextFieldCustom(
                          controller: _phone,
                          hintText: widget.userModel.phone,
                        ),
                        sizeBoxTop,
                        Container(
                          child: Text(
                            'Age',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.black),
                          ),
                        ),
                        sizeBoxBottom,
                        TextFieldCustom(
                          controller: _age,
                          hintText: widget.userModel.age,
                        ),
                        ButtonCustom(
                          title: 'Save changed',
                          callback: () {
                            updateInfo(_displayName.text.trim(), _location.text.trim(),
                                _phone.text.trim(), _age.text.trim());
                          },
                        ),

                      ],
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  void updateInfo(
      String displayName, String location, String phone, String age) {
    updateInfoCubit.updateInfoUser(
        widget.userModel.id ?? '',
        widget.userModel.email ?? '',
        displayName != '' ? displayName : widget.userModel.displayName ?? '',
        phone != '' ? phone : widget.userModel.phone ?? '',
        age != '' ? age : widget.userModel.age ?? '',
        location != '' ? location : widget.userModel.location ?? '');
  }
}
