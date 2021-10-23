

import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/model/song.dart';
import 'package:file_picker/file_picker.dart';

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
class UploadInfoSong extends ChatRoomEvent{
  FilePickerResult? filePickerResult;
  String nameSong;
  String nameSinger;
  UploadInfoSong(this.nameSinger,this.nameSong,this.filePickerResult);
}
class SetUrlSong extends ChatRoomEvent{
  Song song;
  SetUrlSong(this.song);
}
class CloseMusic extends ChatRoomEvent{
  CloseMusic();
}
class ImportSongURl extends ChatRoomEvent{
  ImportSongURl();
}