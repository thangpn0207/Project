abstract class MusicEvent{}
class MusicEventOnPressedButtonRunOrPause extends MusicEvent{
  Duration newDuration;
  Duration newPosition;
  MusicEventOnPressedButtonRunOrPause({required this.newDuration,required this.newPosition});
}
class MusicStart extends MusicEvent{}
class MusicLoadSuccess extends MusicEvent{
  Duration newDuration;
  Duration newPosition;
  MusicLoadSuccess({required  this.newPosition,required this.newDuration});
}
class OnButtonFast extends MusicEvent{
}
class OnButtonBack extends MusicEvent{
}
class OnChangeSlide extends MusicEvent{
  int second;
  OnChangeSlide({required this.second});
}
class OnCloseButton extends MusicEvent{}