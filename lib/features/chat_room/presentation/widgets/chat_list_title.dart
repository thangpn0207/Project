import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/utils/constaints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTitle extends StatelessWidget {
  ChatRoom chatRoomInfo;

  ChatTitle({Key? key, required this.chatRoomInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: chatRoomInfo.imgUrl!.replaceAll('///', '//'),
            imageBuilder: (context, imageProvider) => Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill
                  )
              ),
            ),
            placeholder: (context, url) => Container(
              transform: Matrix4.translationValues(0, 0, 0),
              child: Container(
                  width: 50.w,
                  height: 50.h,
                  child: Center(child: new CircularProgressIndicator())),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            width: 50.w,
            height: 50.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chatRoomInfo.title ?? 'null',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6a515e),
                  ),
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: chatRoomInfo.lastMessage,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xff6a515e),
                    ),
                  ),
                )
              ],
            ),
          ),
          chatRoomInfo.lastMessageTs != ''
              ? Text(Constants.millisecondsToFormatString(
                  chatRoomInfo.lastMessageTs ?? ''))
              : Container(),
        ],
      ),
    );
  }
}
