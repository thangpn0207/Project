


import 'package:app_web_project/core/model/song.dart';

abstract class SongState{}
class SongStateInitial extends SongState{}
class SongStateLoading extends SongState{}
class SongStateLoadSuccess extends SongState{
  List<Song> listSong;
  SongStateLoadSuccess({required this.listSong});
}
