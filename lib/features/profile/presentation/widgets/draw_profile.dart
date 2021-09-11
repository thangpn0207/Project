import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/components/dialog.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/navigator/route_names.dart';
import 'package:app_web_project/core/widgets/dialog_logout.dart';
import 'package:app_web_project/features/chat/presentation/widgets/full_photo.dart';
import 'package:app_web_project/features/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes.dart';
class DrawProfile extends StatefulWidget {
  UserModel userModel;
  AuthenticationCubit authenticationCubit;
  DrawProfile({Key? key,  required this.userModel,required this.authenticationCubit}) : super(key: key);
  @override
  _DrawProfileState createState() => _DrawProfileState();
}

class _DrawProfileState extends State<DrawProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  'assets/images/login/Background.png'))),
      padding: EdgeInsets.symmetric(horizontal: kIsWeb?5.w:20.w,vertical: 40.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPhoto(url: widget.userModel.imgUrl!.replaceAll('///', '//'))));
            },
            child: CachedNetworkImage(
              imageUrl: widget.userModel.imgUrl!.replaceAll('///', '//'),
              imageBuilder: (context, imageProvider) => Container(
                height: 85.h,
                width: 85.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                    )
                ),
              ),
              placeholder: (context, url) => Container(
                transform: Matrix4.translationValues(0, 0, 0),
                child: Container(
                    width: 85.w,
                    height: 85.h,
                    child: Center(child: new CircularProgressIndicator())),
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              width: 85.w,
              height: 85.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20.h,),
          InkWell(
            onTap: (){
              Routes.instance.navigateTo(RouteNames.editInfo,arguments: widget.userModel);

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text('Edit account',style: TextStyle(
                    fontSize: 16.sp,color: Colors.black87,fontWeight: FontWeight.w600
                  ),),
                ),
                Icon(Icons.edit,size: 20.sp,color: Colors.black87,)
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          InkWell(
            onTap: (){
              Routes.instance.navigateTo(RouteNames.changePassword);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text('Changed password',style: TextStyle(
                      fontSize: 16.sp,color: Colors.black87,fontWeight: FontWeight.w600
                  ),),
                ),
                Icon(Icons.lock,size: 20.sp,color: Colors.black87,)
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          InkWell(
            onTap: ()async{
            return showDialogApp(context, DialogLogOut());
            },
            child: Row(            mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  child: Text('Logout',style: TextStyle(
                      fontSize: 16.sp,color: Colors.deepOrange,fontWeight: FontWeight.w600
                  ),),
                ),
                Icon(Icons.logout,size: 20.sp,color: Colors.deepOrange,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
