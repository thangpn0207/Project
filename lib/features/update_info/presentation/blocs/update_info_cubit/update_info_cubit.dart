import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:app_web_project/features/update_info/presentation/blocs/upload_avatar_bloc/upload_avatar_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_info_state.dart';

class UpdateInfoCubit extends Cubit<UpdateInfoState> {
  UploadAvatarCubit uploadAvatarCubit;
  LoadingCubit loadingCubit;
  Repository repository;
  SnackBarCubit snackBarCubit;

  UpdateInfoCubit(this.uploadAvatarCubit, this.repository, this.snackBarCubit,
      this.loadingCubit)
      : super(UpdateInfoInitial());

  Future<void> updateInfoUser(String id, String email, String disPlayName,
      String phone, String age, String location) async {
    loadingCubit.showLoading();
    try {
      UserModel userModel = UserModel(
        id: id,
        email: email,
        displayName: disPlayName,
        imgUrl: uploadAvatarCubit.state.avatar,
        location: location,
        phone: phone,
        age: age,
      );
      await repository.updateUserInfo(userModel);
      loadingCubit.hideLoading();
      emit(UpdateInfoSuccess());
    } catch (_) {
      loadingCubit.hideLoading();
      snackBarCubit.showSnackBar(SnackBarType.error, "Something Wrong");
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    uploadAvatarCubit.close();
    return super.close();
  }
}
