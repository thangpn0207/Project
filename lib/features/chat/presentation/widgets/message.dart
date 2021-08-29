import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/features/chat/presentation/blocs/message_bloc/message_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/message_bloc/message_state.dart';
import 'package:app_web_project/features/profile/presentation/pages/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'full_photo.dart';

class MessageItem extends StatelessWidget {
  final String userId;
  final ChatMessage message;

  MessageItem({Key? key, required this.message, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = userId == message.sendBy;
    return BlocBuilder<MessageBLoc, MessageState>(
      builder: (context, state) {
        if (state is MessageStateLoaded) {
          return Container(
            margin: EdgeInsets.only(bottom: 5.h),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                isMe
                    ? Container()
                    : GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(userModel:state.userModel,userId: userId,)));
                  },
                      child: CachedNetworkImage(
                          imageUrl:
                              state.userModel.imgUrl!.replaceAll('///', '//'),
                          imageBuilder: (context, imageProvider) => Container(
                          height:40.h,
                          width: 40.h,
                          child: CircleAvatar(
                          backgroundImage: imageProvider,
                          )),
                          placeholder: (context, url) => Container(
                            transform: Matrix4.translationValues(0, 0, 0),
                            child: Container(
                                width: 40.w,
                                height: 40.h,
                                child: Center(
                                    child: new CircularProgressIndicator())),
                          ),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                          width: 40.w,
                          height: 40.h,
                          fit: BoxFit.cover,
                        ),
                    ),
                message.type == 'text'
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: isMe
                                ? HexColor('#f26968')
                                : HexColor('#dfe2d2'),
                            borderRadius: isMe
                                ? BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  )),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65.w,
                          minHeight: 40.h,
                        ),
                        child: Text(
                          message.message,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    : imageMessage(context, message.message)
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget imageMessage(context, imageUrlFromFB) {
    return Container(
      width: 160.w,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullPhoto(url: imageUrlFromFB)));
        },
        child: CachedNetworkImage(
          imageUrl: imageUrlFromFB,
          imageBuilder: (context, imageProvider) => Container(
            height: 160.h,
            width: 160.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            transform: Matrix4.translationValues(0, 0, 0),
            child: Container(
                width: 60.w,
                height: 80.h,
                child: Center(child: new CircularProgressIndicator())),
          ),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          width: 60.w,
          height: 80.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
