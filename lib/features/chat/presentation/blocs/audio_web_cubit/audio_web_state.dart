part of 'audio_web_cubit.dart';

@immutable
abstract class AudioWebState {}

class AudioWebInitial extends AudioWebState {}
class AudioWebLoading extends AudioWebState {
}
class AudioWebPlay extends AudioWebState {
  bool isPlaying;
  Duration newDuration;
  Duration newPosition;
  AudioWebPlay(this.isPlaying,this.newDuration,this.newPosition);
}

class AudioWebFail extends AudioWebState {
  String message;
  AudioWebFail(this.message);
}
