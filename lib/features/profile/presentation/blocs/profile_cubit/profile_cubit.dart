import 'dart:io';
import 'dart:typed_data';

import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/containts/spref_constants.dart';
import 'package:app_web_project/core/model/image_model.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:app_web_project/core/utils/spref_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  LoadingCubit loadingCubit;
  Repository repository;
  SnackBarCubit snackBarCubit;

  ProfileCubit(this.repository, this.snackBarCubit, this.loadingCubit)
      : super(ProfileState(
            isMe: true, isSelectImage: false, userModel: UserModel(id: """
""", email: '', displayName: '', imgUrl: '')));

  Future<void> getUserinfo(String userId) async {
    try {
      final user = await repository.getUser(userId);

      if (user != null) {
        String? myId =
            await SPrefUtil.instance.getString(SPrefConstants.userId);
        loadingCubit.hideLoading();
        emit(state.copyWith(
            userModel: user, isMe: myId == user.id, isSelectImage: false));
      } else {
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(
            SnackBarType.error, "Fail when get user Info");
      }
    } catch (_) {
      loadingCubit.hideLoading();
      snackBarCubit.showSnackBar(SnackBarType.error, "Fail when get user Info");
    }
  }

  void selectTypeImg() {
    emit(state.copyWith(isSelectImage: true));
  }

  Future<void> uploadImgToDB(PickImageType type, UserModel userModel) async {
    if (kIsWeb) {
      PickedFile? pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        Uint8List? file = await pickedFile.readAsBytes();
        loadingCubit.showLoading();
        String? imgSrc = await repository.sendImgToDBWeb(file);
        if (imgSrc != null) {
          ImageModel imageModel = ImageModel(
              imageTs: DateTime.now().millisecondsSinceEpoch.toString(),
              imageUrl: imgSrc);
          try {
            await repository.sendPhotoToDb(
                userModel.id ?? '', imageModel, userModel.photos ?? 0);
            loadingCubit.hideLoading();
            snackBarCubit.showSnackBar(SnackBarType.success, 'Upload Success');
            await getUserinfo(userModel.id ?? "");
          } catch (e) {
            loadingCubit.hideLoading();
            snackBarCubit.showSnackBar(SnackBarType.error, e.toString());
          }
        } else {
          loadingCubit.hideLoading();
          snackBarCubit.showSnackBar(SnackBarType.error, 'Can not pick image2');
        }
      } else {
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(SnackBarType.error, 'Can not pick image1');
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
              ImageModel imageModel = ImageModel(
                  imageTs: DateTime.now().millisecondsSinceEpoch.toString(),
                  imageUrl: imgSrc);
              try {
                await repository.sendPhotoToDb(
                    userModel.id ?? '', imageModel, userModel.photos ?? 0);
                loadingCubit.hideLoading();
                snackBarCubit.showSnackBar(
                    SnackBarType.success, 'Upload Success');
                await getUserinfo(userModel.id ?? "");
              } catch (e) {
                loadingCubit.hideLoading();
                snackBarCubit.showSnackBar(SnackBarType.error, e.toString());
              }
            } else {
              loadingCubit.hideLoading();
              snackBarCubit.showSnackBar(
                  SnackBarType.error, 'Can not pick image');
            }
          } else {
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
              ImageModel imageModel = ImageModel(
                  imageTs: DateTime.now().millisecondsSinceEpoch.toString(),
                  imageUrl: imgSrc);
              try {
                await repository.sendPhotoToDb(
                    userModel.id ?? '', imageModel, userModel.photos ?? 0);
                loadingCubit.hideLoading();
                snackBarCubit.showSnackBar(
                    SnackBarType.success, 'Upload Success');
                await getUserinfo(userModel.id ?? "");
              } catch (e) {
                loadingCubit.hideLoading();
                snackBarCubit.showSnackBar(SnackBarType.error, e.toString());
              }
            } else {
              loadingCubit.hideLoading();
              snackBarCubit.showSnackBar(
                  SnackBarType.error, 'Can not pick image');
            }
          } else {
            loadingCubit.hideLoading();
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
