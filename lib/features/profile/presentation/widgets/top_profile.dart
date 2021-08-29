import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/features/chat/presentation/widgets/full_photo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TopProfile extends StatelessWidget {
  UserModel userModel;
  TopProfile({Key? key,required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url='';
    if(userModel.imgUrl==''){
      url = 'https://images.squarespace-cdn.com/content/v1/54b7b93ce4b0a3e130d5d232/1519987020970-8IQ7F6Z61LLBCX85A65S/icon.png?format=1000w';
    }else{
      url = userModel.imgUrl??'';
    }
    return Container(
      color: Color(0xfffae7e9),
      height: 220.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
            color: Color(0xfffcf3f4),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(60),
            )),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.h,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullPhoto(url: userModel.imgUrl!.replaceAll('///', '//'))));
              },
              child: CachedNetworkImage(
                imageUrl:url.replaceAll('///', '//'),
                imageBuilder: (context, imageProvider) => Container(
                    height: 85.h,
                    width: 85.h,
                    child: CircleAvatar(
                      backgroundImage: imageProvider,
                    )),
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
            SizedBox(
              height: 5.h,
            ),
            Text(
              userModel.displayName ?? '',
              style: TextStyle(
                fontSize: 25.sp,
                color: Color(0xff6a515e),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h,),
            Text(
              'Email: ${userModel.email}',
              style: TextStyle(
                fontSize: 15.sp,
                color: Color(0xffc7abba),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h,),
            Container(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Text('Locaiton:',style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp
              ),),
            ),
            Expanded(
              child: Container(
                child: Text(userModel.location??'',overflow: TextOverflow.ellipsis,style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
