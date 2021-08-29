import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/utils/constaints.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ChatMessageInput extends StatelessWidget {
  ChatRoomBloc chatRoomBloc;
  VoidCallback voidCallback;
  ChatMessageInput({Key? key, required this.chatRoomBloc,required this.voidCallback}) : super(key: key);
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
           Container(
            margin:  EdgeInsets.symmetric(horizontal: 2.h),
            child: new IconButton(
                icon: new Icon(Icons.photo,color: Colors.cyan[900],),
                onPressed: voidCallback,
          ),),
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: Constants.border,
                disabledBorder: Constants.border,
                border: Constants.border,
                errorBorder: Constants.border,
                focusedBorder: Constants.border,
                focusedErrorBorder: Constants.border,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Container(
            height: 50.h,
            width: 50.h,
            child: IconButton(
              onPressed: () {
                if(_controller.text!=''){
                  chatRoomBloc.add(SendMessage(message: _controller.text.trim()));
                  _controller.text='';
                }
              },
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
