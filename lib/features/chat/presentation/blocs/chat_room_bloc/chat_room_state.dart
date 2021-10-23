import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/model/song.dart';
import 'package:file_picker/file_picker.dart';

class ChatRoomState {
  List<ChatMessage>? messages;
  String? songUrlPick;
  bool? isLoading;
  FilePickerResult? filePickerResult;
  bool? selectSuccess;
  Song? song;
  bool? isPlay;
  bool? setSongUrl;

  ChatRoomState(
      {this.messages,
      this.songUrlPick,
      this.isLoading,
      this.filePickerResult,
      this.selectSuccess,
      this.song,
      this.isPlay,
      this.setSongUrl});

  ChatRoomState copyWith(
      {List<ChatMessage>? messages,
      String? songUrlPick,
      bool? isLoading,
      FilePickerResult? filePickerResult,
      bool? selectSuccess,
      Song? song,
      bool? isPlay,
      bool? setSongUrl}) {
    return ChatRoomState(
        messages: messages ?? this.messages,
        songUrlPick: songUrlPick ?? this.songUrlPick,
        isLoading: isLoading ?? this.isLoading,
        filePickerResult: filePickerResult ?? this.filePickerResult,
        selectSuccess: selectSuccess ?? this.selectSuccess,
        song: song ?? this.song,
        isPlay: isPlay ?? this.isPlay,
        setSongUrl: setSongUrl ?? this.setSongUrl);
  }
}
