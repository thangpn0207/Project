

import 'package:app_web_project/core/model/chat_room.dart';

abstract class ChatListState{}
class ChatListInitial extends ChatListState{}
class ChatListLoading extends ChatListState{}
class ChatListLoadSuccess extends ChatListState{
  final List<ChatRoom> chatList;
  ChatListLoadSuccess({required this.chatList});
}
