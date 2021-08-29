import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/features/chat/presentation/blocs/audio_cubit/audio_cubit.dart';
import 'package:app_web_project/features/chat/presentation/widgets/slider/slider_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderWidget extends StatefulWidget {
  double animBeginValue;
  double animEndValue;
  AudioCubit audioCubit;

  SliderWidget({Key? key,
    required this.animBeginValue,
    required this.animEndValue,
    required this.audioCubit})
      : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>
    with SingleTickerProviderStateMixin {
  final double widgetWidth = 300.w;
  final double widgetHeight = 100.h;

  Offset _dragPosition = Offset(0, 0);

  // Animation
  late AnimationController _animationController;
  late Animation _sliderAnimation;

  double _animBeginValue = 0;
  double _animEndValue = 0;

  bool _isDragging = false;

  double _progress = 0;

  @override
  void initState() {
    super.initState();

    // Init default anim values
    _animBeginValue = widgetHeight / 2;
    _animEndValue = widgetHeight / 2;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // init animation
    _initAnimation();

    // play anim
    _animationController.forward();
  }

  void _initAnimation() {
    _sliderAnimation = Tween<double>(
      begin: _animBeginValue,
      end: _animEndValue,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    )
      ..addListener(() {
        setState(() {});
      });
  }

  // Cap drag values between widget height and width
  void _capDragPosition() {
    // Y-Axis
    if (_dragPosition.dy >= widgetHeight) {
      _dragPosition = Offset(_dragPosition.dx, widgetHeight);
    } else if (_dragPosition.dy <= 0) {
      _dragPosition = Offset(_dragPosition.dx, 0);
    }

    // X-Axis
    if (_dragPosition.dx >= widgetWidth) {
      _dragPosition = Offset(widgetWidth, _dragPosition.dy);
    } else if (_dragPosition.dx <= 0) {
      _dragPosition = Offset(0, _dragPosition.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      bloc: widget.audioCubit,
      builder: (context, state) {
        if(state is AudioStateLoaded){
          return GestureDetector(
            onPanUpdate: (value) {
              setState(() {
                _isDragging = true;
                // Dragging,
                _dragPosition =
                    Offset(value.localPosition.dx, value.localPosition.dy);
                _capDragPosition();
                // set progress
               _progress = (_dragPosition.dx / widgetWidth) * 100;
               widget.audioCubit.changInSlider(_progress);
              });
            },
            onPanEnd: (value) {
              setState(() {
                _isDragging = false;

                _animBeginValue = _dragPosition.dy;
                _animEndValue = widgetHeight / 2;

                _animationController.reset();

                _initAnimation();

                _animationController.forward();
              });
            },
            child: Container(
                  width: widgetWidth,
                  height: widgetHeight,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: widgetWidth,
                          height: widgetHeight,
                          child: CustomPaint(
                            painter: SliderPainter(
                              dragPosition: _isDragging
                                  ? _dragPosition
                                  : Offset(
                                  _dragPosition.dx, _sliderAnimation.value),
                              sliderColor: Colors.black.withAlpha(30),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        child: Align(
                          alignment: Alignment.topLeft,
                          widthFactor: state.newPosition.inSeconds.toDouble()/state.newDuration.inSeconds.toDouble(),
                          child: Container(
                            decoration: BoxDecoration(),
                            width: widgetWidth,
                            height: widgetHeight,
                            child: CustomPaint(
                              painter: SliderPainter(
                                dragPosition: _isDragging
                                    ? _dragPosition
                                    : Offset(
                                    _dragPosition.dx, _sliderAnimation.value),
                                sliderColor: HexColor('#ffccbb'),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
          );
        }else{
          return Container();
        }
      },
    );
  }
}
