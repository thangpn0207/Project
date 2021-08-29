abstract class MusicState{}
class MusicStateInitial extends MusicState{}
class MusicStateLoading extends MusicState{}
class MusicStateLoaded extends MusicState{
  bool isPlaying;
  Duration newDuration;
  Duration newPosition;
  MusicStateLoaded({required this.newDuration,required this.isPlaying,required this.newPosition});
}
class MusicStateFail extends MusicState{}