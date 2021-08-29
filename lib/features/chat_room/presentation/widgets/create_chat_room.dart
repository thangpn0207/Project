import 'package:app_web_project/core/components/text_field_nomal.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/search_user_loc/search_user_bloc.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/search_user_loc/search_user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateChatRoomInfo extends StatefulWidget {
  SearchUserBloc searchUserBloc;
  UserModel user;
  UserModel friend;

  CreateChatRoomInfo(
      {Key? key, required this.searchUserBloc, required this.user, required this.friend})
      : super(key: key);

  @override
  _CreateChatRoomState createState() => _CreateChatRoomState();
}

class _CreateChatRoomState extends State<CreateChatRoomInfo> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFieldNormal(labelText: 'Type chat room name',
              textEditingController: textEditingController),
          SizedBox(height: 20.h),
          Container(
            margin:
            EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 5.h),
            width: 364.w,
            height: 48.h,
            child: ButtonTheme(
                child: ElevatedButton(
                  onPressed: () {
                    if (
                    textEditingController.text != ''
                    ){
                      widget.searchUserBloc.add(EventAddChatRoom(user: widget.user, friendUser: widget.friend,nameRoom: textEditingController.text));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add Chat Room",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.redAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.redAccent))),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
