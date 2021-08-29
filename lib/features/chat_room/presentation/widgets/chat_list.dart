
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_event.dart';
import 'package:app_web_project/features/chat/presentation/pages/chat_room_screen.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/chat_list_bloc/chat_list_bloc.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/chat_list_bloc/chat_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_list_title.dart';

// ignore: must_be_immutable
class ChatListScreen extends StatefulWidget {
  UserModel userModel;

  ChatListScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(builder: (context, state) {
      if (state is ChatListLoadSuccess) {
        return Expanded(
            child: ListView.builder(
                itemCount: state.chatList.length,
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 60.h),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return BlocProvider(
                          create: (_) => ChatRoomBloc(
                              user: widget.userModel,
                              chatRoomId: state.chatList[index].id ?? 'null')
                            ..add(ChatRoomLoad()),
                          child: ChatRoomScreen(
                            userModel: widget.userModel,
                            chatRoomInfo: state.chatList[index],
                          ),
                        );
                      }));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: ChatTitle(
                        chatRoomInfo: state.chatList[index],
                      ),
                    ),
                  );
                }));
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
