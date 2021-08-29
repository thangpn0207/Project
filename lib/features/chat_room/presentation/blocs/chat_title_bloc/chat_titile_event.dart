
import 'package:app_web_project/core/model/chat_room.dart';

abstract class ChatTitleEvent{}
class ChatTitleStart extends ChatTitleEvent{
  ChatRoom chatRoomInfo;
  ChatTitleStart({required this.chatRoomInfo});
}