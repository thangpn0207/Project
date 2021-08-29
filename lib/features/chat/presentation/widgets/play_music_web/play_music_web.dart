import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/features/chat/presentation/blocs/audio_web_cubit/audio_web_cubit.dart';
import 'package:app_web_project/features/chat/presentation/widgets/play_music_animation.dart';
import 'package:app_web_project/features/chat/presentation/widgets/play_music_web/play_music_web_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../injection_container.dart';
import 'common.dart';

class PlayMusicWeb extends StatefulWidget {
  Song song;
String roomUrl;
VoidCallback callback;
  PlayMusicWeb({Key? key,required this.song,required this.roomUrl,required this.callback}) : super(key: key);

  @override
  _PlayMusicWebState createState() => _PlayMusicWebState();
}

class _PlayMusicWebState extends State<PlayMusicWeb>
    with WidgetsBindingObserver {
  late AudioWebCubit audioWebCubit;
  @override
  void initState() {
    // TODO: implement initState
    audioWebCubit = inject<AudioWebCubit>();
    WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    audioWebCubit.loadAudio(widget.song.songUrl);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance?.removeObserver(this);
    audioWebCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioWebCubit>(
      create: (context) => audioWebCubit,
      child: BlocBuilder<AudioWebCubit, AudioWebState>(
        builder: (context, state) {
          if (state is AudioWebPlay) {
            return Container(
                  height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      child: InkWell(
                        onTap: widget.callback,
                        child: Icon(
                          Icons.close,
                          color: Colors.black38,
                          size: 25.sp,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                          height: 75.h,
                          width: 75.w,
                          child: Container(
                            child: PlayMusicWebAnimation(
                              isPlay: state.isPlaying,
                              roomUrl: widget.roomUrl,
                              audioCubit: audioWebCubit,
                            ),
                          )),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Row(
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
                              Slider(
                                  activeColor: HexColor('#ffbbcc'),
                                  inactiveColor: Colors.grey,
                                  value: state.newPosition.inSeconds.toDouble(),
                                  min: 0.0,
                                  max: state.newDuration.inSeconds.toDouble(),
                                  onChanged: (double value) {
                                    audioWebCubit.seekAudio(value);
                                    value = value;
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Container(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
