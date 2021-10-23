import 'dart:convert';

import 'package:app_web_project/core/components/dialog.dart';
import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/utils/constaints.dart';
import 'package:app_web_project/core/utils/list_room_default.dart';
import 'package:app_web_project/core/widgets/dialog_delete.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/chat_list_bloc/chat_list_bloc.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/chat_list_bloc/chat_list_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatTitle extends StatelessWidget {
  final ChatRoom chatRoomInfo;
  final ChatListBloc chatListBloc;
  ChatTitle({Key? key, required this.chatRoomInfo, required this.chatListBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSimpleRoom;
    bool isNumber = _isNumeric(chatRoomInfo.id);
    if (isNumber == true) {
      isSimpleRoom = listRoomDefault.contains(int.parse(chatRoomInfo.id ?? ''));
    } else {
      isSimpleRoom = false;
    }
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.15,
      child: Padding(
        padding: EdgeInsets.only(right: 5.w),
        child: Container(
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
                          image: imageProvider, fit: BoxFit.fill)),
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
                        text: chatRoomInfo.lastMessageType == 'text'
                            ? utf8.decode(
                                base64.decode(chatRoomInfo.lastMessage ?? ''))
                            : chatRoomInfo.lastMessage,
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
        ),
      ),
      secondaryActions: [
        !isSimpleRoom
            ? IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  showDialogApp(context, DialogDelete(voidCallback: () {
                    chatListBloc.add(
                        DeleteChatRoomEvent(chatRoomId: chatRoomInfo.id ?? ''));
                  }));
                },
              )
            : Container(),
        IconSlideAction(
            caption: 'Close',
            color: Colors.black12,
            icon: Icons.close,
            onTap: () {},
            closeOnTap: true)
      ],
    );
  }

  bool _isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }
}
