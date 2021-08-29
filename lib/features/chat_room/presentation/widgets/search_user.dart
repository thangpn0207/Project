import 'package:app_web_project/core/components/bottom_sheet_app.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_event.dart';
import 'package:app_web_project/features/chat/presentation/pages/chat_room_screen.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/search_user_loc/search_user_bloc.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/search_user_loc/search_user_event.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/search_user_loc/search_user_state.dart';
import 'package:app_web_project/features/chat_room/presentation/widgets/create_chat_room.dart';
import 'package:app_web_project/features/chat_room/presentation/widgets/search_user_title.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SearchUserScreen extends StatefulWidget {
  UserModel user;

  SearchUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchUserBloc, SearchUserState>(
      listener: (context,state){
        if(state is CreateChatRoom){
          return showBottomSheetApp(context,
            child: CreateChatRoomInfo(friend: state.friendUser, searchUserBloc: BlocProvider.of<SearchUserBloc>(context), user: state.user,)
          );
        } else if( state is GoToChatRoom){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) {
            return BlocProvider(
              create: (_) => ChatRoomBloc(
                  user: widget.user,
                  chatRoomId: state.chatRoomInfo.id ?? '')
                ..add(ChatRoomLoad()),
              child: ChatRoomScreen(
                userModel: state.userModel,
                chatRoomInfo: state.chatRoomInfo,
              ),
            );
          }));
        }
      },
        builder: (context, state) {
      if (state is SearchUserStateLoaded) {
        return Expanded(
            child: ListView.builder(
                itemCount: 1,
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      // String chatRoomId = await _chatService.addChatRoom(  widget.user, state.user[index]!);
                      // DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                      //     await _repository.getChatRoom(chatRoomId);
                      // ChatRoom chatRoomInfo = ChatRoom(
                      //     id: documentSnapshot.data()!['id'],
                      //     title: documentSnapshot.data()!['title'],
                      //     imgUrl: documentSnapshot.data()!['imgUrl'],
                      //     lastMessageBy:
                      //         documentSnapshot.data()!['lastMessageBy']);


                      BlocProvider.of<SearchUserBloc>(context).add(EventCreateChatRoom(user:  widget.user, friendUser:  state.user));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: SearchUserTitle(userModel: state.user),
                    ),
                  );
                }));
      } else if(state is  SearchUserStateLoading){
        return Center(
          child: CircularProgressIndicator(),
        );
      }else if(state is SearchUserStateNotFound){
        return Center(
          child: Container(
            child: Text("Not Found User"),
          ),
        );
      }else{
        return Container();
      }
    });
  }
}
