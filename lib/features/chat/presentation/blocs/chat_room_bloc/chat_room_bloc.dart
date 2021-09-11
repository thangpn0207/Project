import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/features/update_info/presentation/pages/update_info.dart';
import 'package:app_web_project/services/chat_service.dart';
import 'package:app_web_project/services/imge_services.dart';
import 'package:app_web_project/services/repository_service.dart';
import 'package:app_web_project/services/song_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../../../../../injection_container.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final UserModel user;
  final String chatRoomId;

  ChatRoomBloc({required this.user, required this.chatRoomId})
      : super(ChatRoomState(
            messages: [], isLoading: false, selectSuccess: false));
  ChatService _chatService = inject<ChatService>();
  SnackBarCubit snackBarCubit = inject<SnackBarCubit>();
  LoadingCubit loadingCubit = inject<LoadingCubit>();

  SongService songService = inject<SongService>();
  Repository repository = inject<Repository>();
  StreamSubscription? chatRoom;

  @override
  Stream<ChatRoomState> mapEventToState(ChatRoomEvent event) async* {
    // TODO: implement mapEventToState
    if (event is ChatRoomLoad) {
      yield (state.copyWith(isLoading: true));
      chatRoom?.cancel();
      chatRoom = _chatService.getChatMessages(chatRoomId).listen((messages) {
        add(ReceiveMessage(message: messages));
      });
    } else if (event is ReceiveMessage) {
      yield state.copyWith(messages: event.message, isLoading: false);
    } else if (event is SendMessage) {
      ChatMessage message = ChatMessage(
        lastMessageTs: DateTime.now().millisecondsSinceEpoch.toString(),
        message: event.message,
        sendBy: user.id ?? '',
        type: 'text',
      );
      _chatService.sendChatMessage(chatRoomId, message);
      _chatService.setChatRoomLastMessage(chatRoomId, message);
    } else if (event is DeleteMessage) {
      if (event.message.sendBy == user.id) {
        _chatService.deleteMessage(chatRoomId, event.message);
      }
    } else if (event is SendPhoto) {
      if (kIsWeb) {
        await ImageController.instance.imageFromWeb().then((croppedFile) async {
          if (croppedFile != null) {
            loadingCubit.showLoading();
            String? takeImageURL = await _chatService.sendPhotoMessageFromWeb(
                croppedFile, chatRoomId);
            if (takeImageURL != null) {
              ChatMessage message = ChatMessage(
                lastMessageTs: DateTime.now().millisecondsSinceEpoch.toString(),
                message: takeImageURL,
                sendBy: user.id ?? '',
                type: 'image',
              );
              await _chatService.sendChatMessage(chatRoomId, message);
              await _chatService.setChatRoomLastMessage(chatRoomId, message);
              loadingCubit.hideLoading();
            } else {
              loadingCubit.hideLoading();
              snackBarCubit.showSnackBar(
                  SnackBarType.error, "Cannot upload photo from your phone");
            }
          } else {
            loadingCubit.hideLoading();
            snackBarCubit.showSnackBar(
                SnackBarType.error, "Cannot take photo from your phone");
          }
        });
      } else {
        switch (event.type) {
          case PickImageType.camera:
            final pickedFile =
                await ImagePicker().getImage(source: ImageSource.camera);
            if (pickedFile != null) {
              final File imageFile = File(pickedFile.path);
              loadingCubit.showLoading();
              String? takeImageURL =
                  await _chatService.sendPhotoMessage(imageFile, chatRoomId);
              if (takeImageURL != null) {
                ChatMessage message = ChatMessage(
                  lastMessageTs:
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  message: takeImageURL,
                  sendBy: user.id ?? '',
                  type: 'image',
                );
                await _chatService.sendChatMessage(chatRoomId, message);
                await _chatService.setChatRoomLastMessage(chatRoomId, message);
                loadingCubit.hideLoading();
              } else {
                loadingCubit.hideLoading();

                snackBarCubit.showSnackBar(
                    SnackBarType.error, "Cannot upload photo from your phone");
              }
            } else {
              loadingCubit.hideLoading();
              snackBarCubit.showSnackBar(
                  SnackBarType.error, "Cannot take photo from your phone");
            }
            break;
          case PickImageType.gallery:
            await ImageController.instance
                .cropImageFromFile()
                .then((croppedFile) async {
              if (croppedFile != null) {
                loadingCubit.showLoading();
                String? takeImageURL = await _chatService.sendPhotoMessage(
                    croppedFile, chatRoomId);
                if (takeImageURL != null) {
                  ChatMessage message = ChatMessage(
                    lastMessageTs:
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    message: takeImageURL,
                    sendBy: user.id ?? '',
                    type: 'image',
                  );
                  await _chatService.sendChatMessage(chatRoomId, message);
                  await _chatService.setChatRoomLastMessage(
                      chatRoomId, message);
                  loadingCubit.hideLoading();
                } else {
                  loadingCubit.hideLoading();
                  snackBarCubit.showSnackBar(SnackBarType.error,
                      "Cannot upload photo from your phone");
                }
              } else {
                loadingCubit.hideLoading();
                snackBarCubit.showSnackBar(
                    SnackBarType.error, "Cannot take photo from your phone");
              }
            });
            break;
          case PickImageType.none:
            break;
        }
      }
    } else if (event is UploadSong) {
      loadingCubit.showLoading();
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.audio, withData: true);
      if (result != null) {
        loadingCubit.hideLoading();
        yield state.copyWith(selectSuccess: true, filePickerResult: result);
      } else {
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(
            SnackBarType.error, "Cannot take song from your phone");
      }
    } else if (event is UploadInfoSong) {
      try {
        loadingCubit.showLoading();
        File file = File(event.filePickerResult?.files.single.path ?? '');
        Uint8List fileBytes = file.readAsBytesSync();
        String fileName = event.filePickerResult!.files.first.name;
        await repository.uploadFileSong(
            fileBytes, chatRoomId, fileName, event.nameSong, event.nameSinger);
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(SnackBarType.success, "Upload Success");
        yield state.copyWith(selectSuccess: false, filePickerResult: null);
      } catch (e) {
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(SnackBarType.error, e.toString());
      }
    } else if (event is SetUrlSong) {
      yield state.copyWith(isPlay: true, song: event.song, setSongUrl: false);
    } else if (event is CloseMusic) {
      yield state.copyWith(isPlay: false);
    } else if (event is ImportSongURl) {
      yield state.copyWith(setSongUrl: true);
    }
  }

  @override
  Future<void> close() {
    chatRoom?.cancel();
    return super.close();
  }
}
