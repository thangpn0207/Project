import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/components/bottom_sheet_app.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/features/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:app_web_project/features/profile/presentation/widgets/bottom_no_data.dart';
import 'package:app_web_project/features/profile/presentation/widgets/bottom_profile.dart';
import 'package:app_web_project/features/profile/presentation/widgets/draw_profile.dart';
import 'package:app_web_project/features/profile/presentation/widgets/mid_profile.dart';
import 'package:app_web_project/features/profile/presentation/widgets/top_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final String userId;

  ProfileScreen({Key? key, required this.userModel, required this.userId})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthenticationCubit authenticationCubit;
  late ProfileCubit profileCubit;
UserModel userNull =UserModel(id: """
""", email: '', displayName: '', imgUrl: '');
  @override
  void initState() {
    // TODO: implement initState
    authenticationCubit = inject<AuthenticationCubit>();
    profileCubit = inject<ProfileCubit>();
    profileCubit.getUserinfo(widget.userModel.id??'');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => profileCubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if(state.isSelectImage ==true){
            if (kIsWeb) {
              profileCubit.uploadImgToDB(PickImageType.none,widget.userModel);
            } else {
              final type = await showBottomChooseImage(context);
              profileCubit.uploadImgToDB(type,state.userModel??widget.userModel);
            }
          }
        },
        builder: (context,state){
          return Scaffold(
            drawer: state.isMe??false
                ? Drawer(
              child: DrawProfile(
                userModel: state.userModel??userNull,
                authenticationCubit: authenticationCubit,
              ),
            )
                : null,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black38),
              backgroundColor: Color(0xfffcf3f4),
              centerTitle: false,
              title: Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Color(0xff6a515e),
                  fontWeight: FontWeight.w300,
                ),
              ),
              actions: <Widget>[
                //Padding(
                //  padding: const EdgeInsets.all(8.0),
                // child: Icon(Icons.more_vert),
                //  ),
                state.isMe??false
                    ? PopupMenuButton<int>(
                  color: Color(0xfffcf3f4),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0))),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upload photo',
                            textAlign: TextAlign.start,
                          ),
                          Icon(Icons.edit_outlined, color: Colors.black),
                        ],
                      ),
                    ),
                    // PopupMenuItem(
                    //   value: 2,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text('Logout'),
                    //       Icon(Icons.logout, color: Colors.black),
                    //     ],
                    //   ),
                    // ),
                  ],
                  onCanceled: () {
                    print("You have canceled the menu.");
                  },
                  onSelected: (value) {
                    if (value == 1) {
                      profileCubit.selectTypeImg();
                    }
                  },
                  icon: Icon(Icons.more_vert),
                )
                    : Container()
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  TopProfile(
                    userModel: state.userModel??userNull,
                  ),
                  MidProfile(userModel: state.userModel??userNull),
                  state.userModel!.id==''?Expanded(child: BottomProfileNoData()): Expanded(child: BottomProfile(userId: state.userModel!.id,))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
