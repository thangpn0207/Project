

import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/chat_message.dart';

abstract class ChatRoomEvent{}
class ChatRoomLoad extends ChatRoomEvent{}
class SendMessage extends ChatRoomEvent{
  final String message;
  SendMessage({required this.message});
}
class SendPhoto extends ChatRoomEvent{
  PickImageType type;
  SendPhoto(this.type);
}
class DeleteMessage extends ChatRoomEvent{
  final ChatMessage message;
  DeleteMessage({required this.message});
}
class ReceiveMessage extends ChatRoomEvent{
  final List<ChatMessage> message;
  ReceiveMessage({required this.message});
}
class UploadSong extends ChatRoomEvent{
  UploadSong();
}