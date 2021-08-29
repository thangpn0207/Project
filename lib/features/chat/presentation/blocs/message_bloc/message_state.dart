


import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/model/user_model.dart';

abstract class MessageState{}
class MessageStateLoading extends MessageState{}
class MessageStateLoaded extends MessageState{
  ChatMessage message;
  UserModel  userModel;
  MessageStateLoaded({required this.userModel,required this.message});
}