


import 'package:app_web_project/core/model/chat_room.dart';

abstract class ChatListEvent{}
class ChatListStart extends ChatListEvent{}
class ChatListLoaded extends ChatListEvent{
  final List<ChatRoom> chatList;
  ChatListLoaded({required this.chatList});
}