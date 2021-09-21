import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/containts/spref_constants.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/authentication.dart';
import 'package:app_web_project/core/utils/spref_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Authentication authentication;
  SnackBarCubit snackBarCubit;
  LoadingCubit loadingCubit;
  HomeCubit(this.authentication, this.snackBarCubit, this.loadingCubit)
      : super(HomeInitial());

  Future<void> getUserInfo() async {
    loadingCubit.showLoading();
    try {
      final user = await authentication.getUser();

      if (user != null) {
        await SPrefUtil.instance
            .setString(SPrefConstants.userId, user.id ?? '');
        loadingCubit.hideLoading();
        emit(Loaded(userModel: user));
      } else {
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(
            SnackBarType.error, "Fail when get user Info");
        emit(Loading());
      }
    } catch (_) {
      loadingCubit.hideLoading();
      snackBarCubit.showSnackBar(SnackBarType.error, "Fail when get user Info");
      emit(Loading());
    }
  }
}
