

import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';

abstract class ChatTitleState{}
class ChatTitleLoading extends ChatTitleState{
}
class ChatTitleLoaded extends ChatTitleState{
  ChatRoom chatRoomInfo;
  UserModel userModel;
  ChatTitleLoaded({required this.chatRoomInfo,required this.userModel});
}