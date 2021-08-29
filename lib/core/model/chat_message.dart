class ChatMessage{
  final String sendBy;
  final  lastMessageTs;
  final String message;
  final String type;
  ChatMessage({required this.type,required this.sendBy,required this.lastMessageTs,required this.message});
  Map<String,dynamic> toJson(){
    return {
      'type':this.type,
      'sendBy':this.sendBy,
      'lastMessageTs':this.lastMessageTs,
      'message':this.message,
    };
  }

}