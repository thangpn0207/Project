import 'dart:math';

import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/features/chat/presentation/blocs/audio_cubit/audio_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayMusicAnimation extends StatefulWidget {
  String roomUrl;
  bool isPlay;
  AudioCubit audioCubit;
  PlayMusicAnimation({Key? key,required this.roomUrl,required this.isPlay,required this.audioCubit}) : super(key: key);
  @override
  _PlayMusicAnimationState createState() => _PlayMusicAnimationState();
}

class _PlayMusicAnimationState extends State<PlayMusicAnimation>  with TickerProviderStateMixin{
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.85;
  bool get _showWaves => widget.audioCubit.isPlaying;
  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;
  late bool isPlaying;
  @override
  void initState() {
    // TODO: implement initState
    _rotationController =
    AnimationController(vsync: this, duration: _kRotationDuration)
      ..addListener(() => setState(_updateRotation))
      ..repeat();
    _scaleController =
    AnimationController(vsync: this, duration: _kToggleDuration)
      ..addListener(() => setState(_updateScale));
    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }
    super.initState();
  }
  void _onToggle() {
    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }
  }
  void function(){
    widget.audioCubit.startOrPauseSong();
    _onToggle();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_showWaves) ...[
              Blob(color: HexColor('#006c84'), scale: _scale, rotation: _rotation),
              Blob(color:  HexColor('#ffccbb'), scale: _scale, rotation: _rotation * 2 - 30),
              Blob(color:  HexColor('#6eb5c0'), scale: _scale, rotation: _rotation * 3 - 45),
            ],
            Container(
              constraints: BoxConstraints.expand(
                height: 75.h,
                width: 75.w
              ),

              child: AnimatedSwitcher(
                duration: _kToggleDuration,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.roomUrl),
                  fit: BoxFit.cover
                ),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}



class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob({required this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(200),
            ),
          ),
        ),
      ),
    );
  }}