import 'dart:async';

import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongService {
  final Repository _repository;

  SongService(this._repository);

  Stream<List<Song>> getSongInChatRoom(String chatRoomId) {
    return _repository
        .getSongInChatRoom(chatRoomId)
        .transform(documentToChatMessagesTransformer);
  }

  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<Song>>
      documentToChatMessagesTransformer = StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>, List<Song>>.fromHandlers(
          handleData: (QuerySnapshot<Map<String, dynamic>> snapShot,
              EventSink<List<Song>> sink) {
    List<Song> result = <Song>[];
    snapShot.docs.forEach((doc) {
      result.add(Song(
        singerName: doc['singerName'],
        songName: doc['songName'],
        songUrl: doc['songUrl'],
      ));
    });
    sink.add(result);
  });
}
