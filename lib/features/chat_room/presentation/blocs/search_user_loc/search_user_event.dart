

import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';

abstract class SearchEvent{}
class SearchEventLoad extends SearchEvent{
  UserModel users;
  SearchEventLoad({required this.users});
}
class SearchEventButtonPressed extends SearchEvent{
  String displayName;
  SearchEventButtonPressed({required this.displayName});
}
class EventAddChatRoom extends SearchEvent{
  UserModel user;
  String nameRoom;
  UserModel friendUser;
  EventAddChatRoom({required this.user,required this.friendUser,required this.nameRoom});
}
class EventCreateChatRoom extends SearchEvent{
  UserModel user;
  UserModel friendUser;
  EventCreateChatRoom({required this.user,required this.friendUser});
}
class EventGotoChatRoom extends SearchEvent{
  UserModel user;
  ChatRoom chatRoom;
  EventGotoChatRoom(this.user,this.chatRoom);
}