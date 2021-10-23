import 'dart:async';

import 'package:app_web_project/core/services/song_service.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_event.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class SongBLoc extends Bloc<SongEvent, SongState> {
  final String chatRoomId;
  SongBLoc({required this.chatRoomId}) : super(SongStateInitial());
  SongService _songService = inject<SongService>();
  StreamSubscription? songList;

  @override
  Stream<SongState> mapEventToState(SongEvent event) async* {
    // TODO: implement mapEventToState
    if (event is SongEventStart) {
      yield SongStateLoading();
      songList?.cancel();
      songList = _songService.getSongInChatRoom(chatRoomId).listen((songs) {
        add(SongEventLoaded(listSong: songs));
      });
    } else if (event is SongEventLoaded) {
      yield SongStateLoadSuccess(listSong: event.listSong);
    }
  }

  @override
  Future<void> close() {
    songList?.cancel();
    return super.close();
  }
}
