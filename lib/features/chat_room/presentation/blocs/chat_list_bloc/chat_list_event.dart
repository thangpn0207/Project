import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';

abstract class ChatListEvent {}

class ChatListStart extends ChatListEvent {
  final UserModel userModel;

  ChatListStart({required this.userModel});
}

class ChatListLoaded extends ChatListEvent {
  final List<ChatRoom> chatList;
  ChatListLoaded({required this.chatList});
}

class DeleteChatRoomEvent extends ChatListEvent {
  final String chatRoomId;
  DeleteChatRoomEvent({required this.chatRoomId});
}
