
import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';

abstract class SearchUserState{}
class SearchUserStateInitial extends SearchUserState{}
class SearchUserStateLoading extends SearchUserState{}
class SearchUserStateLoaded extends SearchUserState{
  final UserModel user;
  SearchUserStateLoaded({required this.user});
}
class GoToChatRoom extends SearchUserState{
   ChatRoom chatRoomInfo;
   UserModel userModel;
  GoToChatRoom({required this.userModel,required this.chatRoomInfo});
}
class SearchUserStateNotFound extends SearchUserState{}
class CreateChatRoom extends SearchUserState{
  UserModel user;
  UserModel friendUser;
  CreateChatRoom(this.user,this.friendUser);
}
