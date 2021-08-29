


import 'package:app_web_project/core/model/chat_message.dart';

abstract class ChatRoomState{}
class ChatRoomStateInitial extends ChatRoomState{}
class ChatRoomLoading extends ChatRoomState{}
class ChatRoomLoadSuccess extends ChatRoomState{
  final List<ChatMessage> messages;
  ChatRoomLoadSuccess({required this.messages});
}
class ChatRoomLoadFailed extends ChatRoomState{}