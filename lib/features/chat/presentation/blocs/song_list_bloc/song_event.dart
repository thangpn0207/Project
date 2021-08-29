


import 'package:app_web_project/core/model/song.dart';

abstract class SongEvent{}
class SongEventStart extends SongEvent{}
class SongEventLoaded extends SongEvent{
  List<Song> listSong;
  SongEventLoaded({required this.listSong});
}