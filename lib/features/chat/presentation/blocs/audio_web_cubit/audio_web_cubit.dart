import 'package:app_web_project/features/chat/presentation/widgets/play_music_web/common.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'audio_web_state.dart';

class AudioWebCubit extends Cubit<AudioWebState> {
  AudioWebCubit() : super(AudioWebInitial());
  final _player = AudioPlayer();
  Duration _duration = new Duration();
  Duration _bufferedPosition = new Duration();
  Duration _position = new Duration();
  bool isPlaying = true;
  Future<void> loadAudio(String audioUrl) async {
    emit(AudioWebLoading());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
      await _player.setLoopMode(LoopMode.one); //
      _duration= await _player.load()??Duration.zero;
      _player.play();
      _player.positionStream.listen((position) {
        isPlaying = _player.playerState.playing;
        emit(AudioWebPlay(isPlaying, _duration, position, ));
      });

    } catch (e) {
      emit(AudioWebFail(e.toString()));
    }
  }

  Future<void> seekAudio(double value)async{
    _player.seek(Duration(seconds: value.round()));
  }
  Future<void> onClickButtonPlay() async {
    isPlaying = _player.playerState.playing;
    if (isPlaying != true) {
      _player.play();
    }else{
      _player.pause();
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _player.dispose();
    return super.close();
  }
}
