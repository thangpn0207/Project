import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/features/chat/presentation/blocs/audio_cubit/audio_cubit.dart';
import 'package:app_web_project/features/chat/presentation/widgets/play_music_animation.dart';
import 'package:app_web_project/features/chat/presentation/widgets/slider/slider_widget.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayAudioMusic extends StatefulWidget {
  Song song;
  String roomUrl;
  VoidCallback callback;

  PlayAudioMusic(
      {Key? key,
      required this.song,
      required this.roomUrl,
      required this.callback})
      : super(key: key);

  @override
  _PlayAudioMusicState createState() => _PlayAudioMusicState();
}

class _PlayAudioMusicState extends State<PlayAudioMusic> {
  late AudioCubit audioCubit;
  late PlayMusicAnimation _myapp;

  @override
  void initState() {
    // TODO: implement initState
    audioCubit = inject<AudioCubit>();
    audioCubit.openSong(widget.song, widget.roomUrl);
    audioCubit.setCallback(widget.callback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> _icons = [Icons.play_circle_fill, Icons.pause_circle_filled];
    return BlocProvider<AudioCubit>(
      create: (context) => audioCubit,
      child: BlocConsumer<AudioCubit, AudioState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AudioStateLoaded) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: HexColor('#e2e8e4')),
              padding: EdgeInsets.only(
                  left: 30.w, right: 30.w, top: 10.h, bottom: 20.h),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      child: InkWell(
                        onTap:(){
                          audioCubit.closeAudio();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black38,
                          size: 25.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: 75.h,
                      width: 75.w,
                      child: Container(
                        child: PlayMusicAnimation(
                          isPlay: state.isPlaying,
                          roomUrl: widget.roomUrl,
                          audioCubit: audioCubit,
                        ),
                      )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.newPosition.toString().split('.')[0],
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          state.newDuration.toString().split('.')[0],
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SliderWidget(
                      audioCubit: audioCubit,
                      animBeginValue: state.newPosition.inSeconds.toDouble(),
                      animEndValue: state.newDuration.inSeconds.toDouble())
                ],
              ),
            );
          } else if (state is AudioStateFail) {
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioCubit.close();
    super.dispose();
  }
}
