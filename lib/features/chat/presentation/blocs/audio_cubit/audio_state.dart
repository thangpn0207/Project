part of 'audio_cubit.dart';

@immutable
abstract class AudioState {}

class AudioInitial extends AudioState {}
class AudioStateLoading extends AudioState{}
class AudioStateLoaded extends AudioState{
  bool isPlaying;
  Duration newDuration;
  Duration newPosition;
  AudioStateLoaded({required this.newDuration,required this.isPlaying,required this.newPosition});
}
class AudioStateFail extends AudioState{}