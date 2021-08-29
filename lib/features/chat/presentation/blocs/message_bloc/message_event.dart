


import 'package:app_web_project/core/model/chat_message.dart';

abstract class MessageEvent{}
class MessageEventStart extends MessageEvent{
  ChatMessage message;
  MessageEventStart({required this.message});
}
