part of 'upload_avatar_cubit.dart';

@immutable
class UploadAvatarState {
  final String? avatar;

  UploadAvatarState({this.avatar});

  UploadAvatarState copyWith(String? avatar) =>
      UploadAvatarState(avatar: avatar ?? this.avatar);
}
