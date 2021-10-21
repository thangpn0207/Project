class ChatRoom {
  final String? id;
  final String? title;
  final String? imgUrl;
  final String? lastMessageBy;
  final String? lastMessage;
  final String? lastMessageTs;
  final String? lastMessageType;

  ChatRoom(
      {required this.lastMessageType,
      required this.id,
      required this.title,
      required this.imgUrl,
      required this.lastMessageBy,
      this.lastMessage,
      this.lastMessageTs});
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'imgUrl': this.imgUrl,
      'lastMessageBy': this.lastMessageBy,
      'lastMessage': this.lastMessage,
      'lastMessageTs': this.lastMessageTs,
      'lastMessageType': this.lastMessageType,
    };
  }
}
