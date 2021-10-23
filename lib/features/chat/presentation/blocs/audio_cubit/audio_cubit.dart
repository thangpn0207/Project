
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/song.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  SnackBarCubit snackBarCubit;

  AudioCubit(this.snackBarCubit) : super(AudioInitial());
  final _assetAudioPlay = AssetsAudioPlayer();
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = true;
  late VoidCallback callbackClose;
  Future<void> openSong(Song song, String roomUrl) async {

    emit(AudioStateLoading());
    try {
      final audio = Audio.network(song.songUrl,
          metas:
              Metas(title: song.songName, image: MetasImage.network(roomUrl)));
      await _assetAudioPlay.stop();
      await _assetAudioPlay.open(audio,
          showNotification: true,
          playInBackground: PlayInBackground.enabled,
          audioFocusStrategy: AudioFocusStrategy.request(
              resumeAfterInterruption: true,
              resumeOthersPlayersAfterDone: true),
          notificationSettings: NotificationSettings(
              seekBarEnabled: false,
              stopEnabled: true,
              prevEnabled: false,
              customStopAction: (player){
                closeAudio();
              },
              customPlayPauseAction: (player) {
                _assetAudioPlay.playOrPause();
                isPlaying = _assetAudioPlay.isPlaying.value;
                _position = _assetAudioPlay.currentPosition.value;
                emit(AudioStateLoaded(
                    newDuration: _duration,
                    isPlaying: isPlaying,
                    newPosition: _position));
              }));
      _duration = _assetAudioPlay.current.value!.audio.duration;
      _assetAudioPlay.setLoopMode(LoopMode.single);
      _assetAudioPlay.currentPosition.listen((position) {
        if(position<=_duration){
          setPosition(position);
        }else{
          setPosition( Duration.zero);
        }
      });
    } catch (e) {
      snackBarCubit.showSnackBar(SnackBarType.error, 'Server error');
      emit(AudioStateFail());
    }
  }

  Future<void> startOrPauseSong() async {
    _assetAudioPlay.playOrPause();
    final PlayerState state = _assetAudioPlay.playerState.value;
    if (state == PlayerState.pause) {
      isPlaying = true;
    } else {
      isPlaying = false;
    }
  }


  void setPosition(Duration position) {
    emit(AudioStateLoaded(
        newDuration: _duration, isPlaying: isPlaying, newPosition: position));
  }
  Future<void> changInSlider(double persen) async {
    Duration newPosition = _duration * (persen / 100);
    _assetAudioPlay.seek(newPosition);
  }
  void setCallback(VoidCallback callback){
    callbackClose =callback;
  }
  void closeAudio(){
    _assetAudioPlay.dispose();
    callbackClose.call();
  }

}
