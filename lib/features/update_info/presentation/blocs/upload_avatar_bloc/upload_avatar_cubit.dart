import 'dart:io';
import 'dart:typed_data';

import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'upload_avatar_state.dart';

class UploadAvatarCubit extends Cubit<UploadAvatarState> {
  LoadingCubit loadingCubit;
  Repository repository;
  SnackBarCubit snackBarCubit;

  UploadAvatarCubit(this.loadingCubit, this.repository, this.snackBarCubit)
      : super(UploadAvatarState(avatar: ''));

  void setAvatar(String avatar) {
    emit(state.copyWith(avatar));
  }

  void pickAvatar(PickImageType type) async {
    if (kIsWeb) {
      PickedFile? pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        Uint8List? file = await pickedFile.readAsBytes();
        loadingCubit.showLoading();
        String? imgSrc = await repository.sendImgToDBWeb(file);
        if (imgSrc != null) {
          loadingCubit.hideLoading();
          emit(state.copyWith(imgSrc));
        } else {
          loadingCubit.hideLoading();
          snackBarCubit.showSnackBar(SnackBarType.error, 'Can not pick image');
        }
      } else {
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(SnackBarType.error, 'Can not pick image');
      }
    } else {
      switch (type) {
        case PickImageType.camera:
          PickedFile? pickedFile =
              await ImagePicker().getImage(source: ImageSource.camera);
          if (pickedFile != null) {
            final File imageFile = File(pickedFile.path);
            loadingCubit.showLoading();
            String? imgSrc = await repository.sendImgToDB(imageFile);
            if (imgSrc != null) {
              loadingCubit.hideLoading();
              emit(state.copyWith(imgSrc));
            } else {
              loadingCubit.showLoading();
              snackBarCubit.showSnackBar(
                  SnackBarType.error, 'Can not pick image');
            }
          } else {
            loadingCubit.showLoading();
            snackBarCubit.showSnackBar(
                SnackBarType.error, 'Can not pick image');
          }

          break;
        case PickImageType.gallery:
          PickedFile? pickedFile =
              await ImagePicker().getImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            final File imageFile = File(pickedFile.path);
            loadingCubit.showLoading();
            String? imgSrc = await repository.sendImgToDB(imageFile);
            if (imgSrc != null) {
              loadingCubit.hideLoading();
              emit(state.copyWith(imgSrc));
            } else {
              loadingCubit.showLoading();
              snackBarCubit.showSnackBar(
                  SnackBarType.error, 'Can not pick image');
            }
          } else {
            loadingCubit.showLoading();
            snackBarCubit.showSnackBar(
                SnackBarType.error, 'Can not pick image');
          }
          break;
        case PickImageType.none:
          break;
      }
    }
  }
}
