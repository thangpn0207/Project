part of 'bottom_profile_cubit.dart';

@immutable
class BottomProfileState {
  List<ImageModel>? listImage;

  BottomProfileState({this.listImage});

  BottomProfileState copyWith(List<ImageModel>? listImage) =>
      BottomProfileState(listImage: listImage ?? this.listImage);
}
