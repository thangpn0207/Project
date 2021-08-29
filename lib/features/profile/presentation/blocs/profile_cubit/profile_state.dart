part of 'profile_cubit.dart';

@immutable
class ProfileState {
  bool? isMe;
  bool? isSelectImage;
  UserModel? userModel;

  ProfileState({this.isMe =true, this.userModel, this.isSelectImage=false});

  ProfileState copyWith({bool? isMe, UserModel? userModel, bool? isSelectImage}) =>
      ProfileState(
          isMe : isMe ?? this.isMe,
          userModel : userModel ?? this.userModel,
          isSelectImage : isSelectImage ?? this.isSelectImage);
}
